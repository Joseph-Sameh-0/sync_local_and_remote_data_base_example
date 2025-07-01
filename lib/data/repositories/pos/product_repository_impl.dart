import 'dart:async';
import 'dart:convert';
import 'dart:developer';


import '../../../core/services/network_info_service/network_info_service.dart';
import '../../../domain/Exception/exception_tree.dart';
import '../../../domain/entities/pos.dart';
import '../../../domain/repositories/pos/product_repository.dart';
import '../../datasources/local/pos/entities/operations/product_operation_entity.dart';
import '../../datasources/local/pos/entities/product_entity.dart';
import '../../datasources/local/pos/product_local_data_source.dart';
import '../../datasources/local/pos/product_operations_data_source.dart';
import '../../datasources/remote/pos/dtos/product_dto.dart';
import '../../datasources/remote/pos/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;
  final ProductRemoteDataSource remoteDataSource;
  final ProductOperationDataSource productOperationDataSource;
  final NetworkInfoService networkInfoService;
  StreamSubscription? _networkSub;

  ProductRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.productOperationDataSource,
    required this.networkInfoService,
  });

  @override
  Stream<List<Product>> getProducts() {
    _networkSub ??= networkInfoService.onStatusChange.listen((isConnected) {
      if (isConnected) {
        remoteDataSource.getProducts().listen((remoteProducts) async {
          localDataSource.overrideProducts(
            remoteProducts
                .map((transaction) => ProductEntity.fromDto(transaction))
                .toList(),
          );
        });
      }
    });

    // Always return local data stream for UI
    return localDataSource.getProducts().map(
      (models) => models.map((model) => model.toDomain()).toList(),
    );
  }

  @override
  Future<Product> getProductById({required String productId}) async {
    final productEntity = await localDataSource.getProductById(productId);
    if (productEntity == null) {
      throw AppExceptions.domainException.productNotFoundException;
    }
    return productEntity.toDomain();
  }

  @override
  Future<void> addProduct({required Product product}) async {
    if (await networkInfoService.isConnected) {
      await remoteDataSource.addProduct(
        ProductDto.fromDomain(product),
      );
    } else {
      productOperationDataSource.addProduct(product);
      await localDataSource.addProduct(
        ProductEntity.fromDomain(product),
      );
    }
  }

  @override
  Future<void> updateProductStock({
    required Product updatedProduct,
    required int deltaStock,
  }) async {
    try {
      if (await networkInfoService.isConnected) {
        return remoteDataSource.updateProduct(
          ProductDto.fromDomain(updatedProduct),
        );
      } else {
        productOperationDataSource.updateProductStock(
          updatedProduct.productId,
          deltaStock,
        );

        return localDataSource.updateProduct(
          ProductEntity.fromDomain(updatedProduct),
        );
      }
    } catch (e) {
      throw AppExceptions.domainException.productUpdateException;
    }
  }


  @override
  Future<void> deleteProduct({required String productId}) async{
    if (await networkInfoService.isConnected) {
      return remoteDataSource.deleteProduct(productId);
    } else {
      productOperationDataSource.deleteProduct(productId);
      return localDataSource.deleteProduct(productId);
    }
  }

  @override
  Future<void> sync() async {
    List<ProductOperationEntity> operations = await productOperationDataSource.getAllOperations();

    for (var operation in operations) {
      try {
        switch (operation.operationType) {
          case ProductOperationType.add:
            final product = Product.fromJson(jsonDecode(operation.value!));
            final dto = ProductDto.fromDomain(product);
            await remoteDataSource.addProduct(dto);
            break;

          case ProductOperationType.updateName:
            final remoteProduct = await remoteDataSource.getProductById(operation.productId);
            if (remoteProduct == null) continue;

            if (remoteProduct.lastUpdate.isBefore(operation.timestamp)) {
              await remoteDataSource.updateProduct(
                remoteProduct.copyWith(name: operation.value),
              );
            }
            break;

          case ProductOperationType.updateBarcode:
            final remoteProduct = await remoteDataSource.getProductById(operation.productId);
            if (remoteProduct == null) continue;

            if (remoteProduct.lastUpdate.isBefore(operation.timestamp)) {
              await remoteDataSource.updateProduct(
                remoteProduct.copyWith(barcode: operation.value),
              );
            }
            break;

          case ProductOperationType.updatePrice:
            final remoteProduct = await remoteDataSource.getProductById(operation.productId);
            if (remoteProduct == null) continue;

            final newPrice = double.tryParse(operation.value ?? '0') ?? 0.0;
            if (remoteProduct.lastUpdate.isBefore(operation.timestamp)) {
              await remoteDataSource.updateProduct(
                remoteProduct.copyWith(price: newPrice),
              );
            }
            break;

          case ProductOperationType.updateStock:
            final remoteProduct = await remoteDataSource.getProductById(operation.productId);
            if (remoteProduct == null) continue;

            final deltaStock = int.tryParse(operation.value ?? '0') ?? 0;
            final updatedStock = remoteProduct.stock + deltaStock;

            if (remoteProduct.lastUpdate.isBefore(operation.timestamp)) {
              await remoteDataSource.updateProduct(
                remoteProduct.copyWith(stock: updatedStock),
              );
            }
            break;

          case ProductOperationType.delete:
            await remoteDataSource.deleteProduct(operation.productId);
            break;
        }

        await productOperationDataSource.deleteOperation(operation.id);

      } catch (e, s) {
        // Log error and retry
        log("Sync failed for operation ID: ${operation.id}, Error: $e");
        log(s.toString());
      }
    }
  }

  @override
  void dispose() {
    _networkSub?.cancel();
    _networkSub = null;
  }
}
