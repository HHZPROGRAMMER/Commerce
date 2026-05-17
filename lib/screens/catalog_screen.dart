import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';
import 'package:intl/intl.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _selectedCategory = 'Hammasi';

  final List<Map<String, dynamic>> _categories = [
    {'n': 'Hammasi', 'i': Icons.grid_view},
    {'n': 'MDF', 'i': Icons.door_back_door},
    {'n': 'Akfa', 'i': Icons.window},
    {'n': 'Yog\'och', 'i': Icons.park},
    {'n': 'Darvoza', 'i': Icons.fence},
    {'n': 'Furnitura', 'i': Icons.key},
  ];

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'uz_UZ', symbol: 'so\'m', decimalDigits: 0);

    // Tanlangan kategoriya bo'yicha filtrlash
    final filteredProducts = _selectedCategory == 'Hammasi'
        ? productProvider.items
        : productProvider.items.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Katalog', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: _categories.length,
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                final isSelected = _selectedCategory == cat['n'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat['n']),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF7000FF) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(cat['i'] as IconData, size: 18, color: isSelected ? Colors.white : Colors.black54),
                          const SizedBox(width: 8),
                          Text(
                            cat['n'] as String,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: filteredProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('$_selectedCategory bo\'limida mahsulotlar yo\'q', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (ctx, i) => _buildProductCard(context, filteredProducts[i], currencyFormatter),
            ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product p, NumberFormat formatter) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => ProductDetailScreen(product: p))),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: p.imageFile != null 
                  ? Image.file(p.imageFile!, fit: BoxFit.cover, width: double.infinity)
                  : (p.imageUrl.isNotEmpty 
                      ? Image.network(p.imageUrl, fit: BoxFit.cover, width: double.infinity)
                      : Container(color: Colors.grey[200])),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), maxLines: 2),
                  const SizedBox(height: 8),
                  Text(formatter.format(p.price), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF7000FF))),
                  const SizedBox(height: 4),
                  Text(p.material, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
