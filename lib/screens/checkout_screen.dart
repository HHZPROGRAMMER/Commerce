import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/product_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cart = Provider.of<ProductProvider>(context, listen: false);
    
    String orderDetails = "Yangi Buyurtma:\n";
    orderDetails += "Mijoz: ${_nameController.text}\n";
    orderDetails += "Tel: ${_phoneController.text}\n";
    orderDetails += "Manzil: ${_addressController.text}\n\n";
    orderDetails += "Mahsulotlar:\n";
    
    cart.cartItems.forEach((key, item) {
      orderDetails += "- ${item.product.name} (${item.quantity} ta)\n";
    });
    orderDetails += "\nJami: ${cart.totalAmount} so'm";

    final String phoneNumber = "998916457373";
    final Uri url = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(orderDetails)}");
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      cart.clearCart();
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Buyurtmangiz yuborildi! Tez orada bog\'lanamiz.'), backgroundColor: Colors.green),
        );
      }
    } else {
      final Uri smsUrl = Uri.parse("sms:$phoneNumber?body=${Uri.encodeComponent(orderDetails)}");
      if (await canLaunchUrl(smsUrl)) {
        await launchUrl(smsUrl);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Buyurtma yuborishda xatolik yuz berdi.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ma\'lumotlarni to\'ldiring')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Buyurtmani tasdiqlash uchun ma\'lumotlaringizni kiriting. Biz siz bilan bog\'lanamiz.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Ismingiz', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Ismingizni kiriting' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Telefon raqamingiz', border: OutlineInputBorder(), prefixText: '+998 '),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'Telefon raqamingizni kiriting' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Yetkazib berish manzili', border: OutlineInputBorder()),
                  maxLines: 2,
                  validator: (v) => v!.isEmpty ? 'Manzilni kiriting' : null,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _submitOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7000FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Tasdiqlash va yuborish', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
