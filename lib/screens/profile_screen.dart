import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF7000FF),
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hurmatli Mijoz', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text('+998 9x xxx xx xx', style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(5)),
                        child: const Text('ID: 25487', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Orders & Favorites
            _buildActionRow(context),

            const SizedBox(height: 10),

            // Menu Items
            _buildMenuItem(Icons.history, 'Buyurtmalar tarixi', () {}),
            _buildMenuItem(Icons.location_on_outlined, 'Mening manzillarim', () {}),
            _buildMenuItem(Icons.notifications_none, 'Bildirishnomalar', () {}),
            const Divider(height: 1),
            _buildMenuItem(Icons.headset_mic_outlined, 'Qo\'llab-quvvatlash (24/7)', () {
              launchUrl(Uri.parse('tel:+998916457373'));
            }),
            _buildMenuItem(Icons.info_outline, 'Ilova haqida', () {}),
            
            const SizedBox(height: 20),
            
            // Business Contact
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF7000FF), Color(0xFF9D50BB)]),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text('Savollaringiz bormi?', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('Bizning mutaxassislar sizga yordam berishga tayyor!', 
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _contactButton(Icons.phone, 'Qo\'ng\'iroq', () => launchUrl(Uri.parse('tel:+998916457373'))),
                      _contactButton(Icons.telegram, 'Telegram', () => launchUrl(Uri.parse('https://t.me/your_telegram'))),
                    ],
                  ),
                ],
              ),
            ),
            const Text('Versiya 1.0.2', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _actionItem(Icons.favorite_border, 'Sevimlilar'),
          Container(width: 1, height: 30, color: Colors.grey[200]),
          _actionItem(Icons.account_balance_wallet_outlined, 'Hamyon'),
          Container(width: 1, height: 30, color: Colors.grey[200]),
          _actionItem(Icons.card_giftcard, 'Promokodlar'),
        ],
      ),
    );
  }

  Widget _actionItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.black87),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(title, style: const TextStyle(fontSize: 15)),
        trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _contactButton(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF7000FF),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
