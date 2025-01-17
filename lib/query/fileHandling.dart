import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileHandle{
// Get file path (modify as needed for your file location)
  /*Future<String> getFilePath(String fileName) async {
    final directory = Directory.current.path; // Adjust for your app's directory
    return '$directory/$fileName';
  }*/

// Write profile data
  Future<void> writeProfileData(Map<String, dynamic> profileData) async {
    final filePath = await getFilePath('profile.json');
    File file = File(filePath);

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode({}));
    }

    // Write profile data
    await file.writeAsString(jsonEncode(profileData));
    print('Profile data written successfully!');
  }

// Read profile data

  Future<String> getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory(); // Get the app's documents directory
    return '${directory.path}/$fileName'; // Return the full path to the file
  }

  Future<Map<String, dynamic>> readProfileData() async {
    try {
      final filePath = await getFilePath('profile.json');
      File file = File(filePath);

      if (!await file.exists()) {
        await file.create(recursive: true);
        await file.writeAsString(jsonEncode({}));
        print('Created new profile.json file.');
        return {};
      }

      final content = await file.readAsString();
      return content.trim().isEmpty ? {} : jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      print('Error reading profile: $e');
      return {};
    }
  }

// Write transaction history
  Future<void> writeTransaction(Map<String, dynamic> transaction) async {
    try {
      // Resolve the file path
      final filePath = await getFilePath('transactions.json');
      File file = File(filePath);

      // Create the file if it doesn't exist
      if (!await file.exists()) {
        await file.create(recursive: true);
        await file.writeAsString(jsonEncode([])); // Initialize with an empty list
      }

      // Read existing transactions
      final content = await file.readAsString();
      List<dynamic> transactions = content.trim().isEmpty
          ? []
          : jsonDecode(content) as List<dynamic>;

      // Add the new transaction
      transactions.add(transaction);

      // Write updated transactions back to the file
      await file.writeAsString(jsonEncode(transactions));
      print('Transaction added successfully!');
    } catch (e) {
      print('Error writing transaction: $e');
    }
  }

// Read transaction history
  Future<List<Map<String, dynamic>>> readTransactions() async {
    final filePath = await getFilePath('transactions.json');
    File file = File(filePath);

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode([])); // Initialize with an empty list
      print('Created new transactions.json file.');
      return [];
    }

    final content = await file.readAsString();
    return content.trim().isEmpty
        ? []
        : (jsonDecode(content) as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  Future<void> deleteLocalFiles(String filename) async {
    try {
      // Get the app's documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Specify the file to delete or iterate over files in the directory
      final filePath = '${directory.path}/$filename'; // Change as needed
      final file = File(filePath);

      // Check if the file exists, then delete it
      if (await file.exists()) {
        await file.delete();
        print('File deleted: $filePath');
      } else {
        print('File does not exist: $filePath');
      }

      // Alternatively, delete all files in the directory:
      // final files = directory.listSync();
      // for (var file in files) {
      //   if (file is File) {
      //     await file.delete();
      //     print('Deleted: ${file.path}');
      //   }
      // }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

}