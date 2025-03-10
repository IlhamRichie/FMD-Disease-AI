import 'package:flutter/material.dart';

class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 400,
          color: Colors.black, // Simulasi kamera
          child: Center(
            child: Text(
              "Camera View",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}