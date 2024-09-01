import 'package:flutter/material.dart';
import 'package:todo_app/screens/home_screen.dart'; // Pastikan path ini benar
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Mengatur timer untuk navigasi ke HomeScreen setelah 3 detik
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/todo.pic.png'), // Pastikan ini benar
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: CircularProgressIndicator(), // Menampilkan indikator loading
          ),
        ),
      ),
    );
  }
}
