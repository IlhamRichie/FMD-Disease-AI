import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  File? _image;
  String _predictionResult = "";
  CameraController? _cameraController;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Animasi untuk overlay garis
  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeAnimation();
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

  // Inisialisasi animasi
  void _initializeAnimation() {
    try {
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
      )..repeat(reverse: true); // Animasi berulang

      _slideAnimation = Tween<Offset>(
        begin: Offset(0, -1), // Mulai dari atas
        end: Offset(0, 1), // Berakhir di bawah
      ).animate(CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeInOut,
      ));
    } catch (e) {
      print("Error initializing animation: $e");
    }
  }

  // Ambil gambar dari kamera
  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print("Camera not initialized");
      return;
    }

    setState(() {
      _isLoading = true;
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
        _isLoading = false;
      });
    }
  }

  // Ambil gambar dari gallery
  Future<void> _pickImageFromGallery() async {
    setState(() {
      _isLoading = true;
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
        _isLoading = false;
      });
    }
  }

  // Kirim gambar ke API dan tampilkan hasil
  Future<void> _sendImageToAPI(File image) async {
    try {
      // Buat request multipart
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://928e-103-208-204-253.ngrok-free.app/predict'), // Ganti dengan URL API Flask Anda
      );

      // Tambahkan file gambar ke request
      var fileStream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile(
        'file',
        fileStream,
        length,
        filename: image.path.split('/').last,
      );
      request.files.add(multipartFile);

      // Kirim request
      var response = await request.send();

      // Cek status response
      if (response.statusCode == 200) {
        // Baca response
        var responseData = await response.stream.bytesToString();
        var result = jsonDecode(responseData);

        // Tampilkan hasil prediksi
        setState(() {
          _predictionResult = "Kondisi: ${result['predicted_class_label']}\n"
              "Probabilitas: ${(result['predicted_probability'] * 100).toStringAsFixed(2)}%";
        });
      } else {
        setState(() {
          _predictionResult = "Failed to get prediction";
        });
      }
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
    _animationController?.dispose(); // Hentikan animasi saat dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("FMD Detection"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Kamera Preview dengan overlay
          Expanded(
            child: Stack(
              children: [
                if (_cameraController != null && _cameraController!.value.isInitialized)
                  CameraPreview(_cameraController!),

                // Overlay garis turun naik
                if (_image == null && _slideAnimation != null) // Hanya tampilkan overlay saat kamera aktif
                  SlideTransition(
                    position: _slideAnimation!,
                    child: Center(
                      child: Container(
                        height: 2,
                        width: MediaQuery.of(context).size.width * 0.8,
                        color: Colors.red.withOpacity(0.7), // Warna garis
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Tombol Capture dan Gallery
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tombol Capture
                GestureDetector(
                  onTap: _isLoading ? null : _takePicture,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.blue.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Capture",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tombol Gallery
                GestureDetector(
                  onTap: _isLoading ? null : _pickImageFromGallery,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade700, Colors.green.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.photo_library, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Gallery",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Hasil Prediksi
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _predictionResult.isEmpty ? "No prediction yet" : _predictionResult,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),

          // Loading Indicator
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}