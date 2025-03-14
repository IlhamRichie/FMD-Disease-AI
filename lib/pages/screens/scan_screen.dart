import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';

class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("FMD Detection"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.green),
        titleTextStyle: const TextStyle(
          color: Colors.green,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20), // Mengurangi padding atas

          // Kamera Container
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 320,
                height: 420,
                color: Colors.black, // Simulasi kamera
                child: const Center(
                  child: Text(
                    "Camera View",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10), // Mengurangi space agar tidak ketutupan

          // Label hasil scan
          Container(
            width: 320,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: const [
                Text(
                  "Label",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "The Accuracy is 100%",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80), // Memberikan ruang agar tidak tertutup bottom navigation
        ],
      ),

      // Bottom Navigation Bar dengan desain yang diperbaiki
      bottomNavigationBar: SizedBox(
        height: 30, // Pastikan ada ruang untuk bottom navigation
        child: Stack(
          clipBehavior: Clip.none, // Supaya icon tidak terpotong
          alignment: Alignment.center,
          children: [
            // Lapisan pertama (Rounded panjang, putih dengan border hijau)
            Positioned(
              bottom: 33,
              left: 40,
              right: 40,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.green, width: 2),
                ),
              ),
            ),

            // Lapisan kedua (Lingkaran besar di tengah, hijau)
            Positioned(
              bottom: 20, // Supaya lebih tinggi
              child: Container(
                width: 75,
                height: 75,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.history_rounded, color: Colors.white, size: 32),
              ),
            ),

            // Ikon kiri dan kanan sejajar, tidak tertutup
            Positioned(
              left: 80,
              bottom: 30,
              child: _buildBottomIcon(Icons.camera_alt),
            ),
            Positioned(
              right: 80,
              bottom: 30,
              child: _buildBottomIcon(Icons.photo),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomIcon(IconData icon) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.green, width: 2), // Border hijau
      ),
      child: Icon(icon, color: Colors.green, size: 28),
    );
  }
}
