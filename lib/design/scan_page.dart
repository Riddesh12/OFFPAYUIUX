import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:offpay/query/data.dart';
import 'package:offpay/query/trascation_query.dart';
import 'package:offpay/query/ussd.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String scannedResult =
      "No QR code scanned yet"; // For displaying scanned result
  TextEditingController amount = TextEditingController();
  bool visible = false;
  bool flashOn = false; // Flashlight state
  MobileScannerController scannerController = MobileScannerController();

  // Updated the function signature to match the expected callback
  void _onBarcodeDetect(BarcodeCapture barcodeCapture) {
    final barcode = barcodeCapture.barcodes.first;
    final String? code = barcode.rawValue;

    if (code != null) {
      setState(() {
        scannedResult = code;
        Variables.payTo = scannedResult;
        visible = true;
      });
      print("QR Code Scanned: $code");
    } else {
      setState(() {
        scannedResult = "No valid QR code detected.";
        Variables.payTo = "";
      });
    }
  }

  void extractUpiId(String upiUrl) {
    Uri uri = Uri.parse(upiUrl);
    String? upiId = uri.queryParameters['pa'];
    Variables.payTo = upiId ?? "";
    print(Variables.payTo);
    setState(() {
      scannedResult = upiId ?? "not changed$scannedResult";
    });
  }

  void toggleFlash() {
    setState(() {
      flashOn = !flashOn;
      scannerController.toggleTorch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAF9F6),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                MobileScanner(
                  controller: scannerController,
                  onDetect: _onBarcodeDetect, // Callback function
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(
                      flashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    ),
                    onPressed: toggleFlash,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            scannedResult,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: visible,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: amount,
                        decoration: InputDecoration(
                          labelText: "Enter Amount",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: visible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                        ),
                        onPressed: () {
                          UssdQuery.sendUssdCode(
                              "*99*1*1*${Variables.payTo}*${amount.text.trim()}*1#");
                          Variables.mapTransaction = {
                            "payto": Variables.payTo,
                            "amount": amount.text.trim(),
                            "time": DateTime.now().toString(),
                            "location": "",
                            "status": Variables.tranStatus,
                            "remark": "1",
                          };
                          Transaction()
                              .transactionCheckAndAdd(Variables.mapTransaction);
                        },
                        child: Text(
                          "Pay Now",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'USSD | OFFPay',
              style: TextStyle(color: Colors.black, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
