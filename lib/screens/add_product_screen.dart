import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '', _price = '', _desc = '', _category = 'MDF', _material = '', _masterName = '', _masterPhone = '', _masterCard = '';
  int _stock = 1, _exp = 1, _warranty = 1;
  File? _image;
  bool _isLoading = false;

  void _saveForm() async {
    if (!_formKey.currentState!.validate() || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Iltimos, rasm va barcha maydonlarni to\'ldiring!')));
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      await Provider.of<ProductProvider>(context, listen: false).addProduct(
        name: _name,
        category: _category,
        price: double.parse(_price),
        description: _desc,
        imageFile: _image!,
        masterName: _masterName,
        masterPhone: _masterPhone,
        masterCard: _masterCard,
        stock: _stock,
        material: _material,
        experienceYears: _exp,
        warrantyYears: _warranty,
      );
      
      if (mounted) {
        setState(() => _isLoading = false);
        _formKey.currentState!.reset();
        setState(() => _image = null);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mahsulot muvaffaqiyatli qo\'shildi!'), backgroundColor: Colors.green));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Xatolik: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E\'lon Joylashtirish', style: TextStyle(fontWeight: FontWeight.bold))),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildImagePicker(),
              const SizedBox(height: 20),
              TextFormField(decoration: const InputDecoration(labelText: 'Mahsulot nomi', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Nomini kiriting' : null, onSaved: (v) => _name = v!),
              const SizedBox(height: 15),
              Row(children: [
                Expanded(child: TextFormField(decoration: const InputDecoration(labelText: 'Narxi (so\'m)', border: OutlineInputBorder()), keyboardType: TextInputType.number, onSaved: (v) => _price = v!)),
                const SizedBox(width: 10),
                Expanded(child: TextFormField(decoration: const InputDecoration(labelText: 'Material', border: OutlineInputBorder()), onSaved: (v) => _material = v!)),
              ]),
              const SizedBox(height: 15),
              const Divider(),
              const Text('Sotuvchi Ma\'lumotlari', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(decoration: const InputDecoration(labelText: 'Ismingiz', border: OutlineInputBorder()), onSaved: (v) => _masterName = v!),
              const SizedBox(height: 10),
              TextFormField(decoration: const InputDecoration(labelText: 'Telefoningiz', border: OutlineInputBorder(), prefixText: '+998'), onSaved: (v) => _masterPhone = v!),
              const SizedBox(height: 10),
              TextFormField(decoration: const InputDecoration(labelText: 'Karta raqami (To\'lov uchun)', border: OutlineInputBorder()), onSaved: (v) => _masterCard = v!),
              const SizedBox(height: 15),
              Row(children: [
                Expanded(child: TextFormField(initialValue: '1', decoration: const InputDecoration(labelText: 'Kafolat (yil)', border: OutlineInputBorder()), keyboardType: TextInputType.number, onSaved: (v) => _warranty = int.parse(v!))),
                const SizedBox(width: 10),
                Expanded(child: TextFormField(initialValue: '5', decoration: const InputDecoration(labelText: 'Tajriba (yil)', border: OutlineInputBorder()), keyboardType: TextInputType.number, onSaved: (v) => _exp = int.parse(v!))),
              ]),
              const SizedBox(height: 15),
              TextFormField(decoration: const InputDecoration(labelText: 'Tavsif', border: OutlineInputBorder()), maxLines: 3, onSaved: (v) => _desc = v!),
              const SizedBox(height: 30),
              SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: _saveForm, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7000FF), foregroundColor: Colors.white), child: const Text('Bozorga chiqarish'))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () async {
        final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
        if (img != null) setState(() => _image = File(img.path));
      },
      child: Container(
        height: 160, width: double.infinity,
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFF7000FF).withAlpha(51))),
        child: _image != null ? ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.file(_image!, fit: BoxFit.cover)) : const Icon(Icons.add_a_photo, size: 40, color: Color(0xFF7000FF)),
      ),
    );
  }
}
