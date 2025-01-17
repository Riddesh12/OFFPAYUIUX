import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:offpay/design/dark_mode.dart';
import 'package:offpay/design/personal_info.dart';
import 'package:offpay/design/signin.dart';
import 'package:offpay/query/fileHandling.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Personal Info'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PersonalInfo()));
            },
          ),
          const SizedBox(
            height: 5,
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text("Get help"),
            onTap: () async {
              final url = "https://riddesh12.github.io/OFFPAY-contact-us-page/";
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("LogOut"),
            onTap: () async {
              FirebaseAuth.instance.signOut();
              FileHandle().deleteLocalFiles("profile.json");
              FileHandle().deleteLocalFiles("transactions.json");
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LogInState()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.dark_mode,
            ),
            title: Text('Dark Mode/ Light Mode'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => DarkMode()));
            },
          )
        ],
      ),
    );
  }
}
