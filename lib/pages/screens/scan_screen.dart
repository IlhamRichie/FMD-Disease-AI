import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/services.dart'; // Pastikan path ini sesuai

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  String _predictionResult = "";
  CameraController? _cameraController;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false; // Untuk menampilkan loading indicator

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Inisialisasi kamera
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );

      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  // Ambil gambar dari kamera
  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print("Camera not initialized");
      return;
    }

    setState(() {
      _isLoading = true; // Tampilkan loading indicator
    });

    try {
      final image = await _cameraController!.takePicture();
      setState(() {
        _image = File(image.path);
      });

      // Kirim gambar ke API
      await _sendImageToAPI(_image!);
    } catch (e) {
      print("Error taking picture: $e");
      setState(() {
        _predictionResult = "Error capturing image";
      });
    } finally {
      setState(() {
        _isLoading = false; // Sembunyikan loading indicator
      });
    }
  }

  // Ambil gambar dari gallery
  Future<void> _pickImageFromGallery() async {
    setState(() {
      _isLoading = true; // Tampilkan loading indicator
    });

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        // Kirim gambar ke API
        await _sendImageToAPI(_image!);
      }
    } catch (e) {
      print("Error picking image: $e");
      setState(() {
        _predictionResult = "Error picking image";
      });
    } finally {
      setState(() {
        _isLoading = false; // Sembunyikan loading indicator
      });
    }
  }

  // Kirim gambar ke API dan tampilkan hasil
  Future<void> _sendImageToAPI(File image) async {
    try {
      var result = await ApiService.predictImage(image);
      setState(() {
        _predictionResult = result.toString();
      });
    } catch (e) {
      print("Error sending image to API: $e");
      setState(() {
        _predictionResult = "Error connecting to API";
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

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
          const SizedBox(height: 20),

          // Kamera Container
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _cameraController == null || !_cameraController!.value.isInitialized
                  ? Container(
                      width: 320,
                      height: 420,
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                  : SizedBox(
                      width: 320,
                      height: 420,
                      child: CameraPreview(_cameraController!),
                    ),
            ),
          ),

          const SizedBox(height: 10),

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
              children: [
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
                  _predictionResult.isEmpty ? "No prediction yet" : _predictionResult,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: SizedBox(
        height: 30,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
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

            Positioned(
              bottom: 20,
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

            // Tombol kamera
            Positioned(
              left: 80,
              bottom: 30,
              child: GestureDetector(
                onTap: _isLoading ? null : _takePicture, // Nonaktifkan tombol saat loading
                child: _buildBottomIcon(Icons.camera_alt),
              ),
            ),

            // Tombol gallery
            Positioned(
              right: 80,
              bottom: 30,
              child: GestureDetector(
                onTap: _isLoading ? null : _pickImageFromGallery, // Nonaktifkan tombol saat loading
                child: _buildBottomIcon(Icons.photo),
              ),
            ),
          ],
        ),
      ),

      // Loading indicator
      // if (_isLoading)
      //   Center(
      //     child: CircularProgressIndicator(),
      //   ),
    );
  }

  Widget _buildBottomIcon(IconData icon) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Icon(icon, color: Colors.green, size: 28),
    );
  }
}