import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:offpay/query/data.dart';

class PhoneAuth {
  String _verificationId = "";

  // This method verifies the phone number and sends the OTP
  Future<void> verifyPhone(String phone) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91$phone", // Use the passed phone number
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically sign in the user if verification is completed
          await FirebaseAuth.instance.signInWithCredential(credential);
          print('Phone number verification completed automatically.');
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // OTP sent callback
          _verificationId = verificationId;
          print("Verification code sent to $phone");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout reached for auto-retrieval
          print("Timeout reached for auto retrieval");
        },
      );
    } catch (e) {
      // Handle any errors during phone number verification
      print('Error verifying phone number: ${e.toString()}');
    }
  }

  // This method signs the user in using the SMS code (OTP)
  Future<void> signIn(String sms) async {
    try {
      // Create the credential using the verificationId and the SMS code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: sms,
      );

      // Sign in the user with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
      print("User signed in successfully");
    } catch (e) {
      // Handle any errors during sign-in
      print('Error signing in with OTP: ${e.toString()}');
    }
  }

  // Method to log in or create user profile in Firestore
  Future<void> databaseLogIn(String phone) async {
    try {
      final db = FirebaseFirestore.instance;
      final profileRef = db.collection(phone).doc("profile");
      final transactionRef = db.collection(phone).doc("transaction");

      // Check if profile already exists
      var profileDoc = await profileRef.get();
      if (!profileDoc.exists) {
        // If not, create profile document with data
        await profileRef.set(Variables.profile);
        print("Profile created for $phone");
      } else {
        print("Profile already exists for $phone");
      }

      // Initialize an empty transactions document if not already present
      var transactionDoc = await transactionRef.get();
      if (!transactionDoc.exists) {
        await transactionRef.set({});
        print("Transaction data initialized for $phone");
      } else {
        print("Transaction data already exists for $phone");
      }
    } catch (e) {
      print('Error during Firestore login: ${e.toString()}');
    }
  }

  // Sync transaction data to Firestore
  Future<void> transSync(List<dynamic> transaction) async {
    try {
      final db = FirebaseFirestore.instance;
      final phone = Variables.profile['Phone']; // Assuming the phone number is stored in Variables.profile
      final transactionRef = db.collection(phone).doc("transaction");

      // Get current transaction data and update
      var existingData = await transactionRef.get();
      if (existingData.exists) {
        // Update the transaction document with new data
        await transactionRef.update({
          DateTime.now().toString(): transaction,
        });
        print("Transaction data updated successfully.");
      } else {
        print("No existing transaction data found.");
      }
    } catch (e) {
      print('Error syncing transaction: ${e.toString()}');
    }
  }
}
