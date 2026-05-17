import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

class ProductProvider with ChangeNotifier {
  List<Product> _localProducts = [];
  final Map<String, CartItem> _cartItems = {};
  final List<String> _favoriteIds = []; // Sevimlilar ID ro'yxati

  ProductProvider() {
    loadProducts();
    _loadFavorites();
  }

  List<Product> get items => [..._localProducts];
  Map<String, CartItem> get cartItems => {..._cartItems};
  List<Product> get favoriteItems => _localProducts.where((p) => _favoriteIds.contains(p.id)).toList();
  int get cartCount => _cartItems.length;

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, cartItem) => total += cartItem.product.price * cartItem.quantity);
    return total;
  }

  // SEVIMLILAR LOGIKASI
  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favoriteIds);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorites');
    if (favs != null) {
      _favoriteIds.addAll(favs);
      notifyListeners();
    }
  }

  // MAHSULOTLAR LOGIKASI
  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? productsJson = prefs.getStringList('products');
    if (productsJson != null) {
      _localProducts = productsJson.map((item) => Product.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> productsJson = _localProducts.map((item) => item.toJson()).toList();
    await prefs.setStringList('products', productsJson);
  }

  Future<void> addProduct({
    required String name, required String category, required double price,
    required String description, required File imageFile, required String masterName,
    required String masterPhone, required String masterCard, int stock = 1,
    String material = '', List<String> colors = const [],
    int experienceYears = 1, int warrantyYears = 1,
  }) async {
    final newProduct = Product(
      id: DateTime.now().toString(), name: name, category: category,
      price: price, description: description, imageUrl: '', imageFile: imageFile,
      createdAt: DateTime.now(), colors: colors, material: material, stock: stock,
      masterName: masterName, masterPhone: masterPhone, masterCard: masterCard,
      experienceYears: experienceYears, warrantyYears: warrantyYears,
      isVerified: true, isDirectPrice: true,
    );
    _localProducts.insert(0, newProduct);
    await _saveToDisk();
    notifyListeners();
  }

  void addToCart(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems.update(product.id, (existing) => CartItem(product: existing.product, quantity: existing.quantity + 1));
    } else {
      _cartItems.putIfAbsent(product.id, () => CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) { _cartItems.remove(productId); notifyListeners(); }
  void clearCart() { _cartItems.clear(); notifyListeners(); }

  void deleteProduct(String id) async {
    _localProducts.removeWhere((p) => p.id == id);
    _favoriteIds.remove(id);
    await _saveToDisk();
    notifyListeners();
  }
}
