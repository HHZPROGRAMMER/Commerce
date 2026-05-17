import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _heightController = TextEditingController();
  final _widthController = TextEditingController();
  String _selectedType = 'MDF Eshik';
  double _result = 0;

  final Map<String, double> _prices = {
    'MDF Eshik': 450000, // 1 kv.m uchun
    'Akfa Deraza': 550000,
    'Temir Darvoza': 850000,
    'Yog\'och Eshik': 750000,
  };

  void _calculate() {
    if (_heightController.text.isEmpty || _widthController.text.isEmpty) return;
    
    double h = double.tryParse(_heightController.text) ?? 0;
    double w = double.tryParse(_widthController.text) ?? 0;
    double pricePerMeter = _prices[_selectedType] ?? 0;

    setState(() {
      _result = (h * w) * pricePerMeter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.currency(locale: 'uz_UZ', symbol: 'so\'m', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Narx Kalkulyatori', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('O\'lchamlarni kiriting va taxminiy narxni biling:', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 25),
            DropdownButtonFormField(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'Mahsulot turi', border: OutlineInputBorder()),
              items: _prices.keys.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (val) => setState(() => _selectedType = val as String),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Bo\'yi (metrda)', border: OutlineInputBorder(), hintText: 'Masalan: 2.1'),
                    onChanged: (_) => _calculate(),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    controller: _widthController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Eni (metrda)', border: OutlineInputBorder(), hintText: 'Masalan: 0.9'),
                    onChanged: (_) => _calculate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFF7000FF).withAlpha(20),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF7000FF).withAlpha(50)),
              ),
              child: Column(
                children: [
                  const Text('Taxminiy narxi:', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(
                    f.format(_result),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF7000FF)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '*Aniq narx usta o\'lchab ketganidan so\'ng belgilanadi',
                    style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Nega bizda arzon?\nChunki bizda usta bilan to\'g\'ridan-to\'g\'ri bog\'lanasiz, o\'rtadagi do\'kon haqini to\'lamaysiz!',
              style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
