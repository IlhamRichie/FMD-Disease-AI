import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/services.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  String _predictionResult = "";
  bool _isLoading = false;
  String? _originalImageBase64;
  String? _overlayedImageBase64;
  final PageController _pageController = PageController();

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isLoading = true);
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile == null) return;

      File imageFile = File(pickedFile.path);
      setState(() => _image = imageFile);

      var result = await ApiService.predictImage(imageFile);
      setState(() {
        _predictionResult =
            result["error"] ?? "Kondisi: ${result["predicted_class_label"]}";
        _originalImageBase64 = result["original_image"];
        _overlayedImageBase64 = result["overlayed_image"];
      });
    } catch (e) {
      setState(() => _predictionResult = "Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Panduan Penggunaan"),
                content: Text(
                  "1. Pilih gambar dari kamera atau galeri.\n"
                  "2. Aplikasi akan memproses dan menampilkan hasil prediksi.\n"
                  "3. Swipe vertikal untuk melihat gambar asli dan overlay.\n"
                  "4. Lihat hasil diagnosis di bawah gambar.",
                ),
                actions: [
                  TextButton(
                    child: Text("Tutup"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          },
        ),
        title: Text("FMD Detection"),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_originalImageBase64 != null || _overlayedImageBase64 != null)
                _buildImageSlider(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton("Camera", Icons.camera_alt,
                      () => _pickImage(ImageSource.camera)),
                  _buildActionButton("Gallery", Icons.photo_library,
                      () => _pickImage(ImageSource.gallery)),
                ],
              ),
              SizedBox(height: 20),
              _isLoading ? CircularProgressIndicator() : SizedBox.shrink(),
              SizedBox(height: 20),
              _buildResultCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    List<String> images = [];
    if (_originalImageBase64 != null) images.add(_originalImageBase64!);
    if (_overlayedImageBase64 != null) images.add(_overlayedImageBase64!);

    // Tampilkan loading saat gambar belum ada tapi _isLoading masih true
    if (images.isEmpty && _isLoading) {
      return SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              "Memproses gambar...",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 300,
      child: Row(
        children: [
          // Gambar Slider Vertikal
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            index == 0 ? "Gambar Original" : "Gambar Overlay",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            child: Image.memory(
                              base64Decode(images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Page Indicator di Kanan
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, _) {
                  int currentPage = _pageController.hasClients
                      ? (_pageController.page ?? 0).round()
                      : 0;
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    width: 8,
                    height: currentPage == index ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPage == index
                          ? Colors.blue.shade800
                          : Colors.grey,
                    ),
                  );
                },
              );
            }),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            label == "Camera" ? Colors.blue.shade800 : Colors.green.shade800,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _predictionResult.isEmpty ? "No prediction yet" : _predictionResult,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
