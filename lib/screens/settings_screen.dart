import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:musaffo_sut/screens/help_center_screen.dart';
import 'package:musaffo_sut/screens/about_screen.dart';
import 'package:musaffo_sut/screens/privacy_policy_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _shareApp(BuildContext context) {
    Share.share(
      "Musaffo Sut ilovasini yuklab oling! https://play.google.com/store/apps/details?id=uz.musaffosut.musaffo_sut",
      subject: "Musaffo Sut ilovasi",
    );
  }

  void _rateApp(BuildContext context) async {
    final url = Uri.parse(
      'https://play.google.com/store/apps/details?id=uz.musaffosut.musaffo_sut',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Havolani ochib bo‘lmadi.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Sozlamalar',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 8),
          // ILLOVA SOZLAMALARI
          _SectionLabel('ILOVA SOZLAMALARI'),

          // Bildirishnomalar uchun to'g'ri ishlaydigan StatefulBuilder
          StatefulBuilder(
            builder: (context, setState) {
              // notificationsEnabled ni tashqarida saqlash uchun ValueNotifier ishlatamiz
              final ValueNotifier<bool> notificationsEnabled =
                  ValueNotifier<bool>(false);

              return ValueListenableBuilder<bool>(
                valueListenable: notificationsEnabled,
                builder: (context, value, _) {
                  return _SettingsTile(
                    icon: Iconsax.notification,
                    title: 'Bildirishnomalar',
                    trailing: Switch(
                      value: value,
                      onChanged: (v) {
                        notificationsEnabled.value = v;
                      },
                      activeColor: Color(0xFF2563FF),
                    ),
                    onTap: () {
                      notificationsEnabled.value = !notificationsEnabled.value;
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          // MA'LUMOT
          _SectionLabel("MA'LUMOT"),
          _SettingsTile(
            icon: Icons.help_outline,
            title: 'Yordam markazi',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HelpCenterScreen()),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'Biz haqimizda',
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AboutScreen()));
            },
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Maxfiylik siyosati',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          // BOSHQA
          _SectionLabel('BOSHQA'),
          _SettingsTile(
            icon: Icons.share_outlined,
            title: "Do'stlarga ulashish",
            onTap: () => _shareApp(context),
          ),
          _SettingsTile(
            icon: Icons.star_border,
            title: 'Ilovani baholash',
            onTap: () => _rateApp(context),
          ),
          const SizedBox(height: 32),
          // Versiya
          Center(
            child: Text(
              'Musaffo Sut v1.0.0',
              style: TextStyle(
                color: Color(0xFFB0B8C4),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 0, 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFB0B8C4),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListTile(
            leading: Icon(icon, color: const Color(0xFF7B8BB2)),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF222B45),
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing:
                trailing ??
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFFB0B8C4),
                ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            minLeadingWidth: 0,
            horizontalTitleGap: 12,
            dense: true,
          ),
        ),
      ),
    );
  }
}
