import 'package:flutter/material.dart';
import '../../homepage.dart'; // Pastikan ini sesuai dengan path ke HomePage Anda

class SplashScreens extends StatefulWidget {
  @override
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Daftar konten untuk setiap splash screen
  final List<Map<String, dynamic>> _splashData = [
    {
      "image": "assets/8241004.png",
      "title": "FMD Detection",
      "description": "Tools to support early detection of FMD \nquickly and accurately",
    },
    {
      "image": "assets/8240145.png",
      "title": "Fast & Reliable",
      "description": "Detect FMD in livestock with real-time \nanalysis",
    },
    {
      "image": "assets/fmd3.png",
      "title": "Protect Your Livestock",
      "description": "Prevention and early detection reduce the \nrisk of FMD outbreaks",
    },
  ];

  @override
  void initState() {
    super.initState();
    // Otomatis pindah ke HomePage setelah 5 detik di splash screen terakhir
    Future.delayed(Duration(seconds: 15), () {
      if (mounted && _currentPage == _splashData.length - 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _splashData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PageView untuk swipe antar splash screen
          PageView.builder(
            controller: _pageController,
            itemCount: _splashData.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      _splashData[index]["image"],
                      height: 300,
                    ),
                    SizedBox(height: 20),
                    Text(
                      _splashData[index]["title"],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _splashData[index]["description"],
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),

          // Tombol skip atau next di kanan bawah
          Positioned(
            bottom: 50,
            right: 30,
            child: IconButton(
              icon: Icon(
                _currentPage == _splashData.length - 1
                    ? Icons.check
                    : Icons.arrow_forward_ios,
                size: 30,
                color: Color(0xFF5AE4A7),
              ),
              onPressed: _goToNextPage,
            ),
          ),

          // Indikator halaman (dots)
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _splashData.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Color(0xFF5AE4A7)
                        : Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}