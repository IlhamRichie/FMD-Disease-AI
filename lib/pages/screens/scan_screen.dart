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
  String? _heatmapImageBase64;

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
        _predictionResult = result["error"] ?? "Kondisi: ${result["predicted_class_label"]}";
        _originalImageBase64 = result["original_image"];
        _heatmapImageBase64 = result["heatmap_image"];
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
        title: Text("FMD Detection"),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _originalImageBase64 != null
                  ? _buildImageCard("Gambar Original", _originalImageBase64!)
                  : SizedBox.shrink(),
              SizedBox(height: 20),
              _heatmapImageBase64 != null
                  ? _buildImageCard("Gambar Heatmap", _heatmapImageBase64!)
                  : SizedBox.shrink(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton("Camera", Icons.camera_alt, () => _pickImage(ImageSource.camera)),
                  _buildActionButton("Gallery", Icons.photo_library, () => _pickImage(ImageSource.gallery)),
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

  Widget _buildImageCard(String title, String base64Image) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(base64Decode(base64Image)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: label == "Camera" ? Colors.blue.shade800 : Colors.green.shade800,
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}