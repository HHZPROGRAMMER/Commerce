import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'uz_UZ', symbol: 'so\'m', decimalDigits: 0);
    final cartProvider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainInfo(formatter),
                    const SizedBox(height: 20),
                    _buildMasterCard(),
                    const SizedBox(height: 25),
                    _buildSpecs(),
                    const SizedBox(height: 25),
                    const Text('Mahsulot haqida', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(product.description, style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5)),
                    const SizedBox(height: 30),
                    _buildTrustSection(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomSheet: _buildBottomAction(context, cartProvider),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      backgroundColor: const Color(0xFF7000FF),
      flexibleSpace: FlexibleSpaceBar(
        background: product.imageFile != null 
            ? Image.file(product.imageFile!, fit: BoxFit.cover) 
            : Image.network(product.imageUrl, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200])),
      ),
    );
  }

  Widget _buildMainInfo(NumberFormat f) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        if (product.isDirectPrice) Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.orange.withAlpha(26), borderRadius: BorderRadius.circular(5)), child: const Text('ZAVOD NARXI', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12))),
        const SizedBox(width: 10),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.green.withAlpha(26), borderRadius: BorderRadius.circular(5)), child: Text('${product.warrantyYears} YIL KAFOLAT', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12))),
      ]),
      const SizedBox(height: 15),
      Text(product.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Text(f.format(product.price), style: const TextStyle(fontSize: 24, color: Color(0xFF7000FF), fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _buildMasterCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const CircleAvatar(backgroundColor: Color(0xFF7000FF), child: Icon(Icons.person, color: Colors.white)),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(product.masterName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (product.isVerified) const Icon(Icons.verified, color: Colors.blue, size: 18),
            ]),
            Text('${product.experienceYears} yillik tajriba', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ])),
          IconButton(icon: const Icon(Icons.phone_in_talk, color: Colors.green), onPressed: () => launchUrl(Uri.parse('tel:+998${product.masterPhone}'))),
        ]),
        const Divider(height: 25),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('To\'lov uchun karta:', style: TextStyle(fontSize: 12, color: Colors.grey)),
          Text(product.masterCard, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
      ]),
    );
  }

  Widget _buildSpecs() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _specItem(Icons.layers_outlined, 'Material', product.material),
      _specItem(Icons.palette_outlined, 'Rang', product.colors.isNotEmpty ? product.colors[0] : 'Standart'),
      _specItem(Icons.verified_user_outlined, 'Sifat', 'Premium'),
    ]);
  }

  Widget _specItem(IconData i, String l, String v) {
    return Column(children: [
      Icon(i, color: Colors.grey),
      const SizedBox(height: 5),
      Text(l, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      Text(v, style: const TextStyle(fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _buildTrustSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10)),
      child: const Row(children: [
        Icon(Icons.security, color: Colors.blue),
        SizedBox(width: 15),
        Expanded(child: Text('Ushbu mahsulot sifat nazoratidan o\'tgan va usta tomonidan kafolatlangan.', style: TextStyle(fontSize: 13, color: Colors.blue))),
      ]),
    );
  }

  Widget _buildBottomAction(BuildContext context, ProductProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Row(children: [
        Expanded(child: OutlinedButton(onPressed: () => launchUrl(Uri.parse('tel:+998${product.masterPhone}')), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), side: const BorderSide(color: Color(0xFF7000FF))), child: const Text('QO\'NG\'IROQ QILISH'))),
        const SizedBox(width: 15),
        Expanded(child: ElevatedButton(onPressed: () {
          cartProvider.addToCart(product);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Savatchaga qo\'shildi!'), backgroundColor: Colors.green));
        }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7000FF), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)), child: const Text('SAVATCHAGA'))),
      ]),
    );
  }
}
