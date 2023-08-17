import 'package:flutter/material.dart';
import 'package:pract_01/screens/home_screen.dart';
import 'package:pract_01/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    var d = const Duration(seconds: 2);
    Future.delayed(d, () {
      setState(() {});

      if (authToken != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const HomeScreen(selectedTabIndex: 2)),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FittedBox(
          fit: BoxFit.cover,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/error_image.png"),
              ),
            ),
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(70),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      titleTextStyle: TextStyle(color: Colors.white),
                      title: Text(
                        "Medical App",
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        "Bienvenido a la app",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(
                      color: Colors.indigo,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
