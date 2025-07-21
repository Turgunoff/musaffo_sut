import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          'Biz haqimizda',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Musaffo Sut',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Bizning maqsadimiz — mijozlarga eng toza va sifatli sut mahsulotlarini tez va ishonchli yetkazib berishdir. Musaffo Sut jamoasi har doim siz uchun xizmatda!',
            ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.email_outlined, color: Colors.blue),
              title: Text('info@musaffosut.uz'),
            ),
          ],
        ),
      ),
    );
  }
}
