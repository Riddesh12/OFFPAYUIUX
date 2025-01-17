import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getContactPermission();
  }

  void getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContacts();
    } else {
      if (await Permission.contacts.request().isGranted) {
        fetchContacts();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void fetchContacts() async {
    Iterable<Contact> contactList = await ContactsService.getContacts();
    setState(() {
      contacts = contactList.toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : contacts.isEmpty
              ? Center(
                  child: Text(
                    "No contacts found or permission denied.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    var contact = contacts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Text(
                          contact.givenName?.substring(0, 1) ?? "?",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      title: Text(contact.givenName ?? "No Name"),
                      subtitle: contact.phones!.isNotEmpty
                          ? Text(contact.phones!.first.value ?? "No Number")
                          : Text("No Number"),
                    );
                  },
                ),
    );
  }
}
