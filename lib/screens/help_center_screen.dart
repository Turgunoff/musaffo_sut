import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Yordam markazi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Savollaringiz bormi?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Biz bilan bog‘lanish uchun quyidagi kontaktlardan foydalaning:',
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.email_outlined, color: Colors.blue),
              title: Text('info@musaffosut.uz'),
            ),
            ListTile(
              leading: Icon(Icons.phone_outlined, color: Colors.blue),
              title: Text('+998 90 189 22 78'),
            ),
          ],
        ),
      ),
    );
  }
}
