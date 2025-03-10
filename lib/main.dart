import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/screens/splash/splash_screen1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: SplashScreen1(),
    );
  }
}
