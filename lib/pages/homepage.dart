import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screens/profile_screen.dart';
import 'screens/scan_screen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? scannedImageBase64;
  String? overlayImageBase64;
  String? scanResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (scannedImageBase64 != null)
                      _buildImageCard(
                        title: "Input Image",
                        imageBase64: scannedImageBase64!,
                        label: scanResult ?? '',
                      ),
                    if (overlayImageBase64 != null)
                      _buildImageCard(
                        title: "GradCam",
                        imageBase64: overlayImageBase64!,
                        label: scanResult ?? '',
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAppBar(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScanScreen()),
          );

          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              scannedImageBase64 = result['image'];
              overlayImageBase64 = result['overlay'];
              scanResult = result['result'];
            });
          }
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
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "FMD Detection",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.green.shade800,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromARGB(255, 39, 150, 44),
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomIcon(
              icon: Icons.home,
              color: Colors.white,
              onPressed: () {},
            ),
            const SizedBox(width: 10),
            _buildBottomIcon(
              icon: Icons.person,
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
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
    return IconButton(
      icon: Icon(icon, color: color, size: 32),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: onPressed,
    );
  }

  Widget _buildImageCard({
    required String title,
    required String imageBase64,
    required String label,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.memory(
              base64Decode(imageBase64),
              fit: BoxFit.cover,
              height: 300,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}