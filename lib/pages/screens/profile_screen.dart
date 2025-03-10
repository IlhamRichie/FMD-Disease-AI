import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Teks menjadi bold
            fontSize: 20,
            color: Colors.green, // Warna hijau
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar pengguna dengan efek bayangan
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage("assets/fmd3.png"), // Ganti dengan gambar profil
              ),
            ),
            const SizedBox(height: 15),

            // Informasi pengguna
            const Text(
              "Ilham Rigan",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(
              "ilhamrigan22@gmail.com",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // Tombol Change Password
            _buildButton(
              text: "Change Password",
              color: Colors.green,
              textColor: Colors.white,
              onPressed: () {
                // Tambahkan fungsi ganti password di sini
              },
            ),
            const SizedBox(height: 12),

            // Tombol Delete Account
            _buildButton(
              text: "Delete Account",
              color: Colors.red.shade400,
              textColor: Colors.white,
              onPressed: () {
                // Tambahkan fungsi hapus akun di sini
              },
            ),
            const SizedBox(height: 12),

            // Tombol Logout (OutlinedButton)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.red, width: 2),
                ),
                onPressed: () {
                  // Tambahkan fungsi logout di sini
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk tombol utama
  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: textColor, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
