import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'splash_screen2.dart';

class SplashScreen1 extends StatefulWidget {
  @override
  _SplashScreen1State createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 8), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen2()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: FadeInRight(
              duration: Duration(seconds: 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/8241004.png', height: 300),
                  SizedBox(height: 20),
                  Text(
                    'FMD Detection',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tools to support early detection of FMD \nquickly and accurately',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 30,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 30, color: Color(0xFF5AE4A7)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen2()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
