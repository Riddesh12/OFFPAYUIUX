import 'package:flutter/material.dart';
import 'package:offpay/design/home_page.dart';
import 'package:offpay/design/signin.dart';
import 'package:offpay/query/data.dart';
import 'package:offpay/query/fileHandling.dart';
import 'package:offpay/query/ussd.dart';

class SomeSecondPage extends StatefulWidget {
  const SomeSecondPage({super.key});

  @override
  State<SomeSecondPage> createState() => _SomeSecondPageState();
}

class _SomeSecondPageState extends State<SomeSecondPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await UssdQuery().permission(); // Ensure permissions are granted

    final profile = await FileHandle().readProfileData();
    print("Profile data: $profile");

    if (context.mounted) {
      // Ensure context is valid before navigation
      if (profile.isEmpty) {
        // Correct check for empty profile data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LogInState()),
        );
      } else {
        Variables.profile = profile; // Update the global profile variable
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assest/logo.png', // Fixed path typo
          width: 300,
          height: 700,
        ),
      ),
    );
  }
}
