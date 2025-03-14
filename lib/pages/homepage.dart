import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screens/profile_screen.dart';
import 'screens/scan_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHealthDataCard(),
                  const SizedBox(height: 20),
                  _buildActionCard(
                    title: "Catat Kesehatan Sapi",
                    icon: FontAwesomeIcons.pen,
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade700, Colors.blue.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 15),
                  _buildActionCard(
                    title: "Riwayat Kesehatan Sapi",
                    subtitle: "Lihat data kesehatan sebelumnya",
                    icon: Icons.history,
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade700, Colors.orange.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomAppBar(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        elevation: 4,
        shape: const CircleBorder(), // Membuat FAB bulat
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScanScreen()),
          );
        },
        child: const Icon(
          FontAwesomeIcons.qrcode,
          color: Colors.white,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/fmd3.png'),
                radius: 30,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Halo sobat vet! 👋",
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  const Text("Ilham Rigan",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHealthDataCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1B641F), Colors.green.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget _buildStatistic(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    String? subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          title: Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          subtitle: subtitle != null
              ? Text(subtitle, style: const TextStyle(color: Colors.white70))
              : null,
          trailing: Icon(icon, color: Colors.white),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      color: Color.fromARGB(255, 39, 150, 44),
      shape: const CircularNotchedRectangle(),
      notchMargin: 10, // Kurangi notchMargin agar tidak terlalu tinggi
      child: Container(
        height: 60, // Sesuaikan tinggi agar tidak overflow
        padding:
            const EdgeInsets.symmetric(vertical: 0), // Hapus padding vertikal
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomIcon(
              icon: Icons.home,
              color: const Color.fromARGB(255, 255, 255, 255),
              onPressed: () {},
            ),
            const SizedBox(width: 10), // Kurangi jarak antar ikon
            _buildBottomIcon(
              icon: Icons.person,
              color: const Color.fromARGB(255, 255, 255, 255),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: color, size: 35), // Kurangi ukuran ikon
          padding: EdgeInsets.zero, // Hapus padding bawaan IconButton
          constraints:
              const BoxConstraints(), // Hilangkan batas bawaan IconButton
          onPressed: onPressed,
        ),
      ],
    );
  }
}
