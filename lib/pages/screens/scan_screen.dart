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

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  String _predictionResult = "";
  CameraController? _cameraController;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

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
        Uri.parse(
            'https://928e-103-208-204-253.ngrok-free.app/predict'), // Ganti dengan URL API Flask Anda
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
          // Kamera Preview
          Expanded(
            child: _cameraController == null ||
                    !_cameraController!.value.isInitialized
                ? Center(child: CircularProgressIndicator())
                : CameraPreview(_cameraController!),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade700,
                            Colors.blue.shade400
                          ], // Gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(10), // Border radius
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.camera_alt,
                              color: Colors.white), // Ikon kamera
                          SizedBox(width: 8),
                          Text(
                            "Capture",
                            style: TextStyle(color: Colors.white), // Warna teks
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tombol Gallery
                  GestureDetector(
                    onTap: _isLoading ? null : _pickImageFromGallery,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade700,
                            Colors.green.shade400
                          ], // Gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(10), // Border radius
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.photo_library,
                              color: Colors.white), // Ikon galeri
                          SizedBox(width: 8),
                          Text(
                            "Gallery",
                            style: TextStyle(color: Colors.white), // Warna teks
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),

          // Hasil Prediksi
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _predictionResult.isEmpty
                  ? "No prediction yet"
                  : _predictionResult,
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
