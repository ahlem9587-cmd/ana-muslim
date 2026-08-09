import 'package:flutter/material.dart';
import 'recitations_page.dart';

class HomePage extends StatelessWidget {
  final String language;

  const HomePage({
    super.key,
    required this.language,
  });

  Map<String, String> get texts {
    switch (language) {
      case 'en':
        return {
          'title': "I'm Muslim",
          'welcome': "Welcome to I'm Muslim",
          'quran': 'Holy Quran',
          'prayer': 'Prayer Times',
          'dhikr': 'Dhikr',
          'tasbeeh': 'Tasbeeh',
          'profile': 'Profile',
          'recitations': 'Recitation Majlis',
          'recitationsSub': 'Share and listen to Quran recitations',
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
          'recitations': 'Majlis de récitation',
          'recitationsSub': 'Partagez et écoutez des récitations',
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
          'recitations': 'Tilavet Meclisi',
          'recitationsSub': 'Tilavetleri paylaş ve dinle',
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
          'recitations': 'تلاوت کی مجلس',
          'recitationsSub': 'تلاوتیں شیئر کریں اور سنیں',
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
          'recitations': 'مجلس التلاوة',
          'recitationsSub': 'شارك واستمع إلى تلاوات القرآن',
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
                context,
                Icons.menu_book,
                t['quran']!,
              ),

              _menuButton(
                context,
                Icons.access_time,
                t['prayer']!,
              ),

              _menuButton(
                context,
                Icons.favorite,
                t['dhikr']!,
              ),

              _menuButton(
                context,
                Icons.touch_app,
                t['tasbeeh']!,
              ),

              _menuButton(
                context,
                Icons.person,
                t['profile']!,
              ),

              const SizedBox(height: 8),

              // مجلس التلاوة
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(
                    Icons.menu_book,
                    size: 38,
                  ),
                  title: Text(
                    t['recitations']!,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    t['recitationsSub']!,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecitationsPage(
                          language: language,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context,
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
