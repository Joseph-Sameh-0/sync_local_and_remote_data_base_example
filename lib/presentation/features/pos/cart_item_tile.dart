import 'package:flutter/material.dart';

import '../../../domain/entities/pos.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return ListTile(
      title: Text(item.product.name),
      subtitle: Text('\$${item.product.price.toStringAsFixed(2)}'),
      trailing: SizedBox(
        width: isMobile ? 120 : 160,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(icon: Icon(Icons.remove), onPressed: onDecrease),
            Text(
              item.quantity.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(icon: Icon(Icons.add), onPressed: onIncrease),
          ],
        ),
      ),
    );
  }
}