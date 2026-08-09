import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String language;

  const ProfilePage({
    super.key,
    required this.language,
  });

  Map<String, String> get texts {
    switch (language) {
      case 'en':
        return {
          'title': 'Profile',
          'welcome': 'My Profile',
          'name': 'Muslim',
          'faith': 'My Faith',
          'qibla': 'Qibla',
          'prayer': 'Prayer Times',
          'dhikr': 'Dhikr',
          'settings': 'Settings',
        };

      case 'fr':
        return {
          'title': 'Profil',
          'welcome': 'Mon profil',
          'name': 'Musulman',
          'faith': 'Ma foi',
          'qibla': 'Qibla',
          'prayer': 'Heures de prière',
          'dhikr': 'Dhikr',
          'settings': 'Paramètres',
        };

      case 'tr':
        return {
          'title': 'Profil',
          'welcome': 'Profilim',
          'name': 'Müslüman',
          'faith': 'İmanım',
          'qibla': 'Kıble',
          'prayer': 'Namaz Vakitleri',
          'dhikr': 'Zikir',
          'settings': 'Ayarlar',
        };

      case 'ur':
        return {
          'title': 'پروفائل',
          'welcome': 'میرا پروفائل',
          'name': 'مسلمان',
          'faith': 'میرا ایمان',
          'qibla': 'قبلہ',
          'prayer': 'نماز کے اوقات',
          'dhikr': 'اذکار',
          'settings': 'ترتیبات',
        };

      case 'id':
        return {
          'title': 'Profil',
          'welcome': 'Profil Saya',
          'name': 'Muslim',
          'faith': 'Iman Saya',
          'qibla': 'Kiblat',
          'prayer': 'Waktu Salat',
          'dhikr': 'Dzikir',
          'settings': 'Pengaturan',
        };

      case 'ms':
        return {
          'title': 'Profil',
          'welcome': 'Profil Saya',
          'name': 'Muslim',
          'faith': 'Iman Saya',
          'qibla': 'Kiblat',
          'prayer': 'Waktu Solat',
          'dhikr': 'Zikir',
          'settings': 'Tetapan',
        };

      default:
        return {
          'title': 'الملف الشخصي',
          'welcome': 'ملفي الشخصي',
          'name': 'مسلم',
          'faith': 'إيماني',
          'qibla': 'القبلة',
          'prayer': 'أوقات الصلاة',
          'dhikr': 'الأذكار',
          'settings': 'الإعدادات',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = texts;
    final isArabic = language == 'ar' || language == 'ur';

    return Directionality(
      textDirection:
          isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t['title']!),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 15),

              // بطاقة الملف الشخصي
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                ),
                child: Column(
                  children: [
                    // بدون صورة شخصية وبدون كاميرا
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary,
                      child: const Icon(
                        Icons.person,
                        size: 45,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      t['name']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      t['welcome']!,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              _profileItem(
                context,
                Icons.mosque,
                t['faith']!,
              ),

              _profileItem(
                context,
                Icons.explore,
                t['qibla']!,
              ),

              _profileItem(
                context,
                Icons.access_time,
                t['prayer']!,
              ),

              _profileItem(
                context,
                Icons.favorite,
                t['dhikr']!,
              ),

              _profileItem(
                context,
                Icons.settings,
                t['settings']!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileItem(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant,
        ),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 17,
        ),
        onTap: () {},
      ),
    );
  }
}
