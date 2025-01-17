import 'package:flutter/material.dart';
import 'package:offpay/component/box.dart';
import 'package:offpay/design/account_payment.dart';
import 'package:offpay/design/upi_payment.dart';
import 'package:offpay/query/data.dart';
import 'package:offpay/query/trascation_query.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

class SendPage extends StatelessWidget {
  const SendPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for the input fields
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController remarkController = TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xffFBFCFA),
      // appBar: AppBar(
      // title: Text('Send Money'),
      //),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                    suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.perm_contact_cal_outlined))),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: remarkController,
                decoration: InputDecoration(
                  labelText: 'Add Message (optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.contact_support_outlined),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Fetch values from the controllers
                        String phone = phoneController.text;
                        String amount = amountController.text;
                        String remark = remarkController.text.isEmpty
                            ? "1"
                            : remarkController.text.trim();
                        // Simple validation
                        if (phone.isEmpty || amount.isEmpty || remark.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Please fill all the fields')),
                          );
                        } else {
                          //UssdQuery.sendUssdCode(
                          //  "*99*1*1*${phoneController.text.trim()}*${amountController.text.trim()}*$remark#");
                          UssdAdvanced.sendUssd(
                              code:
                                  "*99*1*1*${phoneController.text.trim()}*${amountController.text.trim()}*$remark#");
                          Variables.mapTransaction = {
                            "payto": phoneController.text.trim(),
                            "amount": amountController.text.trim(),
                            "time": DateTime.now().toString(),
                            "location": "",
                            "status": Variables.tranStatus,
                            "remark": remark
                          };
                          Transaction()
                              .transactionCheckAndAdd(Variables.mapTransaction);
                          /////enter transaction code here and check transaction status
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff32A64F),
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: Text(
                        'Pay',
                        style: TextStyle(color: Colors.white),
                      ),
                    ), // Space between button and text
                  ],
                ),
              ),
              SizedBox(height: 100),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'OFFPay Feature',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    ClickBox(
                        icons: Icons.account_balance,
                        text: "Check\nBalance",
                        onTap: () {
                          UssdAdvanced.sendUssd(code: "*99*3#");
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    ClickBox(
                        icons: Icons.phone_android,
                        text: "Mobile\nRecharge",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AccountPayment(), // Replace with your page
                            ),
                          );
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    ClickBox(
                        icons: Icons.payment,
                        text: "Pay UPI",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpiPayment()));
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//send page
