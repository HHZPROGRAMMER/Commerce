import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';
import 'package:intl/intl.dart';
import 'calculator_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    
    final products = productProvider.items.where((product) {
      final nameLower = product.name.toLowerCase();
      final searchLower = _searchQuery.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    final currencyFormatter = NumberFormat.currency(locale: 'uz_UZ', symbol: 'so\'m', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            if (_searchQuery.isEmpty) SliverToBoxAdapter(child: _buildPromoBanner()),
            
            if (_searchQuery.isEmpty) SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalculatorScreen())),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withAlpha(50)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.calculate_outlined, color: Colors.orange),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Narxni hisoblash', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('O\'lchamlarni kiriting va narxni biling', style: TextStyle(fontSize: 12, color: Colors.black54)),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.orange),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            products.isEmpty 
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text(
                          _searchQuery.isEmpty ? 'Hozircha mahsulotlar yo\'q' : 'Mahsulot topilmadi', 
                          style: const TextStyle(color: Colors.grey)
                        ),
                      ],
                    ),
                  )
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _buildProductCard(context, products[i], currencyFormatter, productProvider),
                      childCount: products.length,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[100], 
                  borderRadius: BorderRadius.circular(10), 
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Mahsulotlarni qidirish...',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                    icon: const Icon(Icons.search, color: Colors.grey, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty 
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          child: const Icon(Icons.clear, color: Colors.grey, size: 20),
                        ) 
                      : null,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            const Badge(label: Text('3'), child: Icon(Icons.notifications_outlined, size: 26)),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 120),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF7000FF), Color(0xFF9D50BB)]), 
        borderRadius: BorderRadius.circular(15)
      ),
      child: Stack(children: [
        Positioned(
          right: -10, 
          bottom: -10, 
          child: Icon(Icons.door_front_door, size: 100, color: Colors.white.withAlpha(40))
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('VOSITACHISIZ BOZOR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            const Text('To\'g\'ridan-to\'g\'ri ustadan oling\nva 30% gacha tejang!', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 12),
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: () {}, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, 
                  foregroundColor: const Color(0xFF7000FF),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                ), 
                child: const Text('Ko\'rish')
              ),
            )
          ],
        )
      ]),
    );
  }

  Widget _buildProductCard(BuildContext context, Product p, NumberFormat formatter, ProductProvider provider) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => ProductDetailScreen(product: p))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(12), 
          border: Border.all(color: Colors.grey[200]!)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Expanded(
              child: Stack(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: p.imageFile != null 
                      ? Image.file(p.imageFile!, fit: BoxFit.cover) 
                      : Image.network(p.imageUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(color: Colors.grey[100])),
                  ),
                ),
                if (p.isDirectPrice)
                  Positioned(
                    top: 6, 
                    left: 6, 
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), 
                      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)), 
                      child: const Text('ZAVOD NARXI', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold))
                    )
                  ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _showDeleteDialog(context, p, provider),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.white.withAlpha(200), shape: BoxShape.circle),
                      child: const Icon(Icons.delete_outline, color: Colors.red, size: 16),
                    ),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text(p.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Row(children: [
                    const Icon(Icons.star, color: Colors.orange, size: 10),
                    Text(' 4.9', style: TextStyle(color: Colors.grey[600], fontSize: 10)),
                    const Spacer(),
                    if (p.isVerified) const Icon(Icons.verified, color: Colors.blue, size: 12),
                  ]),
                  const SizedBox(height: 6),
                  Text(formatter.format(p.price), style: const TextStyle(color: Color(0xFF7000FF), fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text('${p.warrantyYears} yil kafolat', style: const TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold)),
                ]
              ),
            ),
          ]
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Product p, ProductProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('O\'chirish', style: TextStyle(fontSize: 18)),
        content: Text('${p.name} mahsulotini o\'chirib tashlamoqchimisiz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Bekor qilish')),
          TextButton(
            onPressed: () {
              provider.deleteProduct(p.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('O\'chirildi')));
            },
            child: const Text('O\'chirish', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
