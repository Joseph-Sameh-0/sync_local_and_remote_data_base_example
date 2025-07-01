import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/pos_cubit.dart';
import '../../cubit/pos_state.dart';
import 'cart_item_tile.dart';
import 'product_card.dart';

class POSPage extends StatelessWidget {
  const POSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Point of Sale')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout - stacked vertically
            return _buildMobileLayout(context);
          } else {
            // Desktop/Tablet layout - side by side
            return Row(
              children: [
                Expanded(flex: 3, child: _buildProductsList(context)),
                Expanded(flex: 2, child: _buildCartSection(context)),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _buildProductsList(context)),
        SizedBox(
          height: 350, // Fixed height for cart section on mobile
          child: _buildCartSection(context),
        ),
      ],
    );
  }

  Widget _buildProductsList(BuildContext context) {
    final searchController = TextEditingController();
    return BlocBuilder<POSCubit, POSState>(
      builder: (context, state) {
        if (state is POSLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is POSError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<POSCubit>().loadProducts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is POSLoaded) {
          final products = searchController.text.isNotEmpty
              ? state.filteredProducts
              : state.products;
          final emptyMessage = searchController.text.isNotEmpty
              ? 'No products found for "${searchController.text}"'
              : 'No products available';

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by name or barcode',
                    prefixIcon: Icon(Icons.search),
                  ),
                  controller: searchController,
                  onChanged: (query) => context.read<POSCubit>().search(query),
                ),
              ),

              if (products.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      emptyMessage,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                )
              else
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(context),
                      childAspectRatio: 0.9,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () =>
                            context.read<POSCubit>().addItemToCart(product),
                      );
                    },
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add Product'),
                  onPressed: () async {
                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) {
                        final nameController = TextEditingController();
                        final barcodeController = TextEditingController();
                        final priceController = TextEditingController();
                        final stockController = TextEditingController();
                        return AlertDialog(
                          title: Text('Add Product'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(labelText: 'Name'),
                              ),
                              TextField(
                                controller: barcodeController,
                                decoration: InputDecoration(
                                  labelText: 'Barcode',
                                ),
                              ),
                              TextField(
                                controller: priceController,
                                decoration: InputDecoration(labelText: 'Price'),
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                              TextField(
                                controller: stockController,
                                decoration: InputDecoration(labelText: 'Stock'),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop({
                                  'name': nameController.text,
                                  'barcode': barcodeController.text,
                                  'price':
                                      double.tryParse(priceController.text) ??
                                      0.0,
                                  'stock':
                                      int.tryParse(stockController.text) ?? 0,
                                });
                              },
                              child: Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                    if (result != null) {
                      context.read<POSCubit>().addNewProduct(
                        name: result['name'],
                        barcode: result['barcode'],
                        price: result['price'],
                        stock: result['stock'] ?? 0,
                      );
                    }
                  },
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 300) return 1; // Extra small phones
    if (width < 400) return 2; // Small phones
    if (width < 800) return 3; // Phones
    if (width < 1000) return 4;
    if (width < 1200) return 5;
    if (width < 1400) return 6;
    if (width < 1600) return 7; // Large Tablets
    return 8; // Tablets/Desktops
  }

  Widget _buildCartSection(BuildContext context) {
    return BlocBuilder<POSCubit, POSState>(
      builder: (context, state) {
        if (state is POSLoaded) {
          final total = state.cart.fold(
            0.0,
            (sum, item) => sum + (item.product.price * item.quantity),
          );
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cart (${state.cart.length} items)',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.cart.length,
                      itemBuilder: (context, index) {
                        final item = state.cart[index];
                        return CartItemTile(
                          item: item,
                          onIncrease: () => context
                              .read<POSCubit>()
                              .addItemToCart(item.product),
                          onDecrease: () => context
                              .read<POSCubit>()
                              .removeItemFromCart(item.product.productId),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Text(
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.read<POSCubit>().checkout(),
                          child: const Text('Checkout'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/transactions');
                          },
                          child: const Text('Transactions'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
