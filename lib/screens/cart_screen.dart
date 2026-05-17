import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'package:intl/intl.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<ProductProvider>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'uz_UZ', symbol: 'so\'m', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savatcha', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (cart.cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => cart.clearCart(),
            )
        ],
      ),
      body: cart.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('Savatchangiz bo\'sh', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.cartItems.length,
                    itemBuilder: (ctx, i) {
                      final item = cart.cartItems.values.toList()[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: item.product.imageFile != null
                                ? Image.file(item.product.imageFile!, width: 50, height: 50, fit: BoxFit.cover)
                                : Image.network(item.product.imageUrl, width: 50, height: 50, fit: BoxFit.cover, 
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image)),
                          ),
                          title: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${currencyFormatter.format(item.product.price)} x ${item.quantity}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                            onPressed: () => cart.removeFromCart(item.product.id),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Jami summa:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(currencyFormatter.format(cart.totalAmount),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF7000FF))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7000FF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Buyurtma berish', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
