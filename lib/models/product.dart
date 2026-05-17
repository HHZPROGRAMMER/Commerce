import 'dart:io';
import 'dart:convert';

class Review {
  final String userName;
  final String comment;
  final double rating;
  final String? date;

  Review({required this.userName, required this.comment, required this.rating, this.date});

  Map<String, dynamic> toMap() => {'userName': userName, 'comment': comment, 'rating': rating, 'date': date};
  factory Review.fromMap(Map<String, dynamic> map) => Review(
    userName: map['userName'],
    comment: map['comment'],
    rating: map['rating'].toDouble(),
    date: map['date'],
  );
}

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
  final File? imageFile;
  final DateTime createdAt;
  final List<String> colors;
  final String material;
  final int stock;
  
  final String masterName;
  final String masterPhone;
  final String masterCard;
  final int experienceYears;
  final bool isVerified;
  final int warrantyYears;
  final bool isDirectPrice;
  
  final List<Review> reviews;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.imageFile,
    required this.createdAt,
    this.colors = const [],
    this.material = '',
    this.stock = 1,
    required this.masterName,
    required this.masterPhone,
    required this.masterCard,
    this.experienceYears = 1,
    this.isVerified = false,
    this.warrantyYears = 1,
    this.isDirectPrice = true,
    this.reviews = const [],
  });

  String toJson() {
    return json.encode({
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'imagePath': imageFile?.path,
      'createdAt': createdAt.toIso8601String(),
      'colors': colors,
      'material': material,
      'stock': stock,
      'masterName': masterName,
      'masterPhone': masterPhone,
      'masterCard': masterCard,
      'experienceYears': experienceYears,
      'isVerified': isVerified,
      'warrantyYears': warrantyYears,
      'isDirectPrice': isDirectPrice,
      'reviews': reviews.map((r) => r.toMap()).toList(),
    });
  }

  factory Product.fromJson(String source) {
    final data = json.decode(source);
    return Product(
      id: data['id'],
      name: data['name'],
      category: data['category'],
      price: data['price'].toDouble(),
      description: data['description'],
      imageUrl: data['imageUrl'],
      imageFile: data['imagePath'] != null ? File(data['imagePath']) : null,
      createdAt: DateTime.parse(data['createdAt']),
      colors: List<String>.from(data['colors'] ?? []),
      material: data['material'] ?? '',
      stock: data['stock'] ?? 1,
      masterName: data['masterName'] ?? '',
      masterPhone: data['masterPhone'] ?? '',
      masterCard: data['masterCard'] ?? '',
      experienceYears: data['experienceYears'] ?? 1,
      isVerified: data['isVerified'] ?? false,
      warrantyYears: data['warrantyYears'] ?? 1,
      isDirectPrice: data['isDirectPrice'] ?? true,
      reviews: (data['reviews'] as List? ?? []).map((r) => Review.fromMap(r)).toList(),
    );
  }
}
