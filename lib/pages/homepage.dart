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
              context, MaterialPageRoute(builder: (context) => ScanScreen()));
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
          colors: [
            const Color(0xFF1B641F),
            Colors.green.shade400
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Data Kesehatan 12 Sapi",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text("Di desa: Pepedan, Dukuhturi",
              style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatistic("572 kg", "Berat \nRata-rata"),
              _buildStatistic("5", "Kasus \nFMD"),
              _buildStatistic("80%", "Kesehatan \nBaik"),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          (value.toInt() + 1).toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 74),
                      FlSpot(1, 75),
                      FlSpot(2, 80),
                      FlSpot(3, 85),
                      FlSpot(4, 80),
                      FlSpot(5, 87),
                      FlSpot(6, 85),
                    ],
                    isCurved: true,
                    color: Colors.white,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.green.shade700,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
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
