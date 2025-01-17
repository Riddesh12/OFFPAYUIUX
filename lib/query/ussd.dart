import 'package:flutter/services.dart';
import 'package:offpay/query/data.dart';
import 'package:permission_handler/permission_handler.dart';


class UssdQuery{
  Future<void> permission() async {
    PermissionStatus status = await Permission.phone.request();
    PermissionStatus status2=await Permission.sms.request();
    PermissionStatus status3=await Permission.camera.request();
    PermissionStatus status4=await Permission.location.request();
    PermissionStatus status5=await Permission.contacts.request();

    print(status.isGranted);
    if (status.isGranted&&status2.isGranted&&status3.isGranted&&status4.isGranted&&status5.isGranted) {
      Variables.permission=true;
    } else {
      // Handle permission denial
      print('Permission denied');
      Variables.permission=false;
    }
  }

  /*Future<bool> sendUssd(String code) async {
    String encodedUssd = Uri.encodeFull(code);
    Uri ussdUri = Uri.parse("tel:$encodedUssd");

    try{
      if (await canLaunchUrl(ussdUri)) {
        await launchUrl(ussdUri);
        return true;
      } else {
        throw 'Could not launch $ussdUri';
      }
    } catch(e){
      print(e.toString());
      return false;
    }
  }
*/

  static const platform = MethodChannel('com.example.offpay/ussd');

  // Function to send a USSD code
  static Future<void> sendUssdCode(String ussdCode) async {
    try {
      if(Variables.permission==true){
        final String response = await platform.invokeMethod('sendUssdCode', {"code": ussdCode});
        print("USSD Request: $response");
      } else {
        UssdQuery().permission();
      }
    } catch (e) {
      print("Failed to send USSD code: $e");
    }
  }
/*
  // Listener for incoming USSD responses
  static void listenForUssdResponse(Function(String) onResponse) {
    platform.setMethodCallHandler((call) async {
      if (call.method == "onUssdResponse") {
        onResponse(call.arguments);
      }
    });
  }*/
}

