// lib/screens/privacy_policy_screen.dart

import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Maxfiylik Siyosati',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'So\'nggi yangilanish: 19-iyul, 2025-yil',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('1. Kirish'),
            _buildSectionContent(
              'Ushbu Maxfiylik siyosati "Musaffo Sut" mobil ilovasi ("Ilova") foydalanuvchilaridan olingan ma\'lumotlarni qanday yig\'ishimiz, ishlatishimiz va himoya qilishimizni tushuntiradi. Ilovadan foydalanish orqali siz ushbu siyosat shartlariga rozilik bildirasiz.',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('2. Biz to\'playdigan ma\'lumotlar'),
            _buildSectionContent(
              'Biz sizdan faqat buyurtmani amalga oshirish uchun zarur bo\'lgan minimal ma\'lumotlarni yig\'amiz. Bu ma\'lumotlar siz ilovada doimiy profil yaratmaganingiz uchun hech qanday akkauntga bog\'lanmaydi. Yig\'iladigan ma\'lumotlar:',
            ),
            _buildListItem('Ism va Familiya'),
            _buildListItem('Telefon raqami'),
            _buildListItem('Yetkazib berish manzili'),
            const SizedBox(height: 24),
            _buildSectionTitle('3. Ma\'lumotlardan qanday foydalanamiz'),
            _buildSectionContent(
              'Siz taqdim etgan ma\'lumotlardan quyidagi maqsadlarda foydalaniladi:',
            ),
            _buildListItem(
              'Buyurtmalaringizni qayta ishlash va yetkazib berish.',
            ),
            _buildListItem(
              'Buyurtma holati bo\'yicha siz bilan bog\'lanish (operatorlar tomonidan).',
            ),
            _buildListItem('Xizmat sifatini yaxshilash.'),
            _buildSectionContent(
              '\nBiz sizning shaxsiy ma\'lumotlaringizni uchinchi shaxslarga sotmaymiz yoki ijaraga bermaymiz.',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('4. Ma\'lumotlar xavfsizligi'),
            _buildSectionContent(
              'Biz sizning ma\'lumotlaringizni ruxsatsiz kirish, o\'zgartirish yoki yo\'q qilishdan himoya qilish uchun zarur texnik va tashkiliy choralarni ko\'ramiz. Barcha buyurtma ma\'lumotlari xavfsiz serverlarda saqlanadi.',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('5. Siyosatga o\'zgartirishlar'),
            _buildSectionContent(
              'Biz ushbu maxfiylik siyosatini vaqti-vaqti bilan yangilashimiz mumkin. Har qanday o\'zgarishlar ushbu sahifada e\'lon qilinadi.',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('6. Biz bilan bog\'lanish'),
            _buildSectionContent(
              'Ushbu maxfiylik siyosati bo\'yicha savollaringiz bo\'lsa, biz bilan bog\'laning:',
            ),
            _buildListItem('Email: info@musaffosut.uz'),
            _buildListItem('Telefon: +998 90 189 22 78'),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Sarlavhalar uchun yordamchi vidjet
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Matnlar uchun yordamchi vidjet
  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
      textAlign: TextAlign.justify,
    );
  }

  // Ro'yxat elementlari uchun yordamchi vidjet
  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
