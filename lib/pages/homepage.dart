import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0), // Padding vertikal diubah ke 0
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHealthDataCard(), // Card besar diposisikan lebih ke atas
                  const SizedBox(height: 20),
                  _buildActionCard(
                    title: "Catat Kesehatan Sapi",
                    icon: FontAwesomeIcons.pen,
                    color: Colors.blue,
                    onTap: () {},
                  ),
                  const SizedBox(height: 15),
                  _buildActionCard(
                    title: "Riwayat Kesehatan Sapi",
                    subtitle: "Lihat data kesehatan sebelumnya",
                    icon: Icons.history,
                    color: Colors.orange,
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
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ScanScreen()));
        },
        child: const Icon(FontAwesomeIcons.qrcode, color: Colors.white, size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 20), // AppBar diturunkan
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
                  Text("Halo sobat vet! 👋", style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  const Text("Ilham Rigan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
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
      margin: const EdgeInsets.only(top: 0), // Margin dihapus atau diatur ke 0
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.green.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Data Kesehatan Sapi", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text("Desa: Pepedan", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatistic("500 kg", "Berat \nRata-rata"),
              _buildStatistic("5", "Kasus \nFMD"),
              _buildStatistic("80%", "Kesehatan \nBaik"),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(), // Sumbu Y tidak menampilkan label
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        // Menampilkan label mingguan
                        switch (value.toInt()) {
                          case 0:
                            return Text("1", style: TextStyle(color: Colors.white70, fontSize: 12));
                          case 1:
                            return Text("2", style: TextStyle(color: Colors.white70, fontSize: 12));
                          case 2:
                            return Text("3", style: TextStyle(color: Colors.white70, fontSize: 12));
                          case 3:
                            return Text("4", style: TextStyle(color: Colors.white70, fontSize: 12));
                          default:
                            return const Text("");
                        }
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false), // Menghilangkan border grafik
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 50), // Data untuk Minggu 1
                      FlSpot(1, 70), // Data untuk Minggu 2
                      FlSpot(2, 60), // Data untuk Minggu 3
                      FlSpot(3, 90), // Data untuk Minggu 4
                    ],
                    isCurved: false, // Garis lurus
                    color: Colors.white, // Warna garis
                    barWidth: 3, // Lebar garis
                    dotData: const FlDotData(show: false), // Menghilangkan titik pada garis
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    String? subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      color: Colors.white, // Warna card diubah menjadi putih
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: Icon(icon, color: color),
        onTap: onTap,
      ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomIcon(
              icon: Icons.home,
              label: "Home",
              color: Colors.green.shade700,
              onPressed: () {},
            ),
            const SizedBox(width: 50),
            _buildBottomIcon(
              icon: Icons.person,
              label: "Profile",
              color: Colors.grey.shade700,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomIcon({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: color, size: 30),
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}