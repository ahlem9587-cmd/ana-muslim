import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String language;

  const HomePage({
    super.key,
    required this.language,
  });

  Map<String, String> get texts {
    switch (language) {
      case 'ar':
        return {
          'title': 'أنا مسلم',
          'welcome': 'مرحبًا بك في تطبيق أنا مسلم',
          'quran': 'القرآن الكريم',
          'prayer': 'أوقات الصلاة',
          'dhikr': 'الأذكار',
          'tasbeeh': 'المسبحة',
          'profile': 'الملف الشخصي',
        };

      case 'en':
        return {
          'title': "I'm Muslim",
          'welcome': "Welcome to I'm Muslim",
          'quran': 'Holy Quran',
          'prayer': 'Prayer Times',
          'dhikr': 'Dhikr',
          'tasbeeh': 'Tasbeeh',
          'profile': 'Profile',
        };

      case 'fr':
        return {
          'title': 'Je suis Musulman',
          'welcome': 'Bienvenue dans Je suis Musulman',
          'quran': 'Coran',
          'prayer': 'Heures de prière',
          'dhikr': 'Dhikr',
          'tasbeeh': 'Tasbih',
          'profile': 'Profil',
        };

      case 'tr':
        return {
          'title': 'Ben Müslümanım',
          'welcome': 'Ben Müslümanım uygulamasına hoş geldiniz',
          'quran': 'Kur’an-ı Kerim',
          'prayer': 'Namaz Vakitleri',
          'dhikr': 'Zikir',
          'tasbeeh': 'Tesbih',
          'profile': 'Profil',
        };

      case 'ur':
        return {
          'title': 'میں مسلمان ہوں',
          'welcome': 'میں مسلمان ہوں ایپ میں خوش آمدید',
          'quran': 'قرآن مجید',
          'prayer': 'نماز کے اوقات',
          'dhikr': 'اذکار',
          'tasbeeh': 'تسبیح',
          'profile': 'پروفائل',
        };

      case 'id':
        return {
          'title': 'Saya Muslim',
          'welcome': 'Selamat datang di Saya Muslim',
          'quran': 'Al-Qur’an',
          'prayer': 'Waktu Salat',
          'dhikr': 'Dzikir',
          'tasbeeh': 'Tasbih',
          'profile': 'Profil',
        };

      case 'ms':
        return {
          'title': 'Saya Muslim',
          'welcome': 'Selamat datang ke Saya Muslim',
          'quran': 'Al-Quran',
          'prayer': 'Waktu Solat',
          'dhikr': 'Zikir',
          'tasbeeh': 'Tasbih',
          'profile': 'Profil',
        };

      default:
        return {
          'title': 'أنا مسلم',
          'welcome': 'مرحبًا بك في تطبيق أنا مسلم',
          'quran': 'القرآن الكريم',
          'prayer': 'أوقات الصلاة',
          'dhikr': 'الأذكار',
          'tasbeeh': 'المسبحة',
          'profile': 'الملف الشخصي',
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
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Text(
                t['welcome']!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              _menuButton(
                Icons.menu_book,
                t['quran']!,
              ),

              _menuButton(
                Icons.access_time,
                t['prayer']!,
              ),

              _menuButton(
                Icons.favorite,
                t['dhikr']!,
              ),

              _menuButton(
                Icons.touch_app,
                t['tasbeeh']!,
              ),

              _menuButton(
                Icons.person,
                t['profile']!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton(
    IconData icon,
    String text,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
