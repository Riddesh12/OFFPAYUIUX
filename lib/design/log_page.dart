import 'package:flutter/material.dart';
import 'package:offpay/design/home_page.dart';
import 'package:offpay/query/data.dart';
import 'package:offpay/query/fileHandling.dart';
import 'package:offpay/query/phone.dart';
import 'package:offpay/query/ussd.dart';

class LogInPage extends StatefulWidget {
  final String code;
  const LogInPage({required this.code, super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  Future<void> afterOtp() async {
    PhoneAuth().signIn(otpController.text.trim());
    Variables.profile = {
      "Name": nameController.text.trim(),
      "Phone": phoneController.text.trim()
    };
    await FileHandle().writeProfileData(Variables.profile);
    print(FileHandle().readProfileData());
    PhoneAuth().databaseLogIn(phoneController.text.trim());
    UssdQuery.sendUssdCode(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disables back navigation
      child: Scaffold(
        backgroundColor: const Color(0xFFF3E5F5),
        appBar: AppBar(
          automaticallyImplyLeading: false, // Removes back arrow
          title: const Text(
            "Log In",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 219, 181, 248),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Welcome to OffPay!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please log in to continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Enter your name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Enter your phone number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for OTP request
                    PhoneAuth().verifyPhone(phoneController.text.trim());
                  },
                  child: const Text("GET OTP"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: otpController,
                  decoration: InputDecoration(
                    labelText: "OTP",
                    hintText: "Enter the OTP",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: (){
                    afterOtp();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                  },
                  child: const Text("ENTER THE APP"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
