import 'package:flutter/material.dart';
import 'home_screen.dart'; // jika navigasi ke home_screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/logo.png",
              width: 150,
              height: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                children: [
                  TextSpan(
                    text: 'Kodein',
                    style: TextStyle(color: Colors.black),
                  ),
                  WidgetSpan(
                      child: SizedBox(
                    width: 5,
                  )),
                  TextSpan(
                      text: 'Notes',
                      style: TextStyle(color: Colors.deepOrangeAccent))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
