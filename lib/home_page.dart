import 'package:flutter/material.dart';

import 'quran_page.dart';
import 'recitations_page.dart';
import 'profile_page.dart';
import 'tasbeeh_page.dart';
import 'adhkar_page.dart';
import 'hadith_page.dart';
import 'prayer_page.dart';

class HomePage extends StatefulWidget {
  final String language;

  const HomePage({
    super.key,
    required this.language,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  Map<String, String> get texts {
    switch (widget.language) {
      case 'en':
        return {
          'title': "I'm Muslim",
          'home': 'Home',
          'quran': "Qur'an",
          'dhikr': 'Adhkar',
          'tasbeeh': 'Tasbeeh',
          'hadith': 'Hadith',
          'prayer': 'Prayer',
          'profile': 'Profile',
          'recitations': 'Recitation Majlis',
        };

      case 'fr':
        return {
          'title': 'Je suis Musulman',
          'home': 'Accueil',
          'quran': 'Coran',
          'dhikr': 'Adhkar',
          'tasbeeh': 'Tasbih',
          'hadith': 'Hadith',
          'prayer': 'Prière',
          'profile': 'Profil',
          'recitations': 'Majlis de récitation',
        };

      case 'tr':
        return {
          'title': 'Ben Müslümanım',
          'home': 'Ana Sayfa',
          'quran': 'Kur’an',
          'dhikr': 'Zikir',
          'tasbeeh': 'Tesbih',
          'hadith': 'Hadis',
          'prayer': 'Namaz',
          'profile': 'Profil',
          'recitations': 'Tilavet Meclisi',
        };

      case 'ur':
        return {
          'title': 'میں مسلمان ہوں',
          'home': 'ہوم',
          'quran': 'قرآن',
          'dhikr': 'اذکار',
          'tasbeeh': 'تسبیح',
          'hadith': 'حدیث',
          'prayer': 'نماز',
          'profile': 'پروفائل',
          'recitations': 'تلاوت کی مجلس',
        };

      case 'id':
        return {
          'title': 'Saya Muslim',
          'home': 'Beranda',
          'quran': 'Al-Qur’an',
          'dhikr': 'Dzikir',
          'tasbeeh': 'Tasbih',
          'hadith': 'Hadis',
          'prayer': 'Salat',
          'profile': 'Profil',
          'recitations': 'Majelis Tilawah',
        };

      case 'ms':
        return {
          'title': 'Saya Muslim',
          'home': 'Utama',
          'quran': 'Al-Quran',
          'dhikr': 'Zikir',
          'tasbeeh': 'Tasbih',
          'hadith': 'Hadis',
          'prayer': 'Solat',
          'profile': 'Profil',
          'recitations': 'Majlis Tilawah',
        };

      default:
        return {
          'title': 'أنا مسلم',
          'home': 'الرئيسية',
          'quran': 'القرآن',
          'dhikr': 'الأذكار',
          'tasbeeh': 'المسبحة',
          'hadith': 'الحديث',
          'prayer': 'الصلاة',
          'profile': 'الملف الشخصي',
          'recitations': 'مجلس التلاوة',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = texts;

    final isArabic =
        widget.language == 'ar' ||
        widget.language == 'ur';

    return Directionality(
      textDirection:
          isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t['title']!),
          centerTitle: true,
        ),

        body: _buildBody(),

        bottomNavigationBar: SafeArea(
          child: Container(
            height: 78,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surface,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, -2),
                  color: Colors.black12,
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Row(
                children: [
                  _bottomItem(
                    Icons.home_rounded,
                    t['home']!,
                    0,
                  ),

                  _bottomItem(
                    Icons.menu_book_rounded,
                    t['quran']!,
                    1,
                  ),

                  _bottomItem(
                    Icons.water_drop_rounded,
                    t['dhikr']!,
                    2,
                  ),

                  _bottomItem(
                    Icons.touch_app_rounded,
                    t['tasbeeh']!,
                    3,
                  ),

                  _bottomItem(
                    Icons.auto_stories_rounded,
                    t['hadith']!,
                    4,
                  ),

                  _bottomItem(
                    Icons.access_time_rounded,
                    t['prayer']!,
                    5,
                  ),

                  _bottomItem(
                    Icons.person_rounded,
                    t['profile']!,
                    6,
                  ),

                  _bottomItem(
                    Icons.record_voice_over_rounded,
                    t['recitations']!,
                    7,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (selectedIndex) {
      case 1:
        return QuranPage(
          language: widget.language,
        );

      case 2:
        return AdhkarPage(
          language: widget.language,
        );

      case 3:
        return TasbeehPage(
          language: widget.language,
        );

      case 4:
        return HadithPage(
          language: widget.language,
        );

      case 5:
        return PrayerPage(
          language: widget.language,
        );

      case 6:
        return ProfilePage(
          language: widget.language,
        );

      case 7:
        return RecitationsPage(
          language: widget.language,
        );

      default:
        return _homePage();
    }
  }

  Widget _homePage() {
    final t = texts;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.mosque_rounded,
            size: 80,
            color: Color(0xFF17604B),
          ),

          const SizedBox(height: 20),

          Text(
            t['title']!,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            t['home']!,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomItem(
    IconData icon,
    String label,
    int index,
  ) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: 92,
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 7,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 27,
              color: isSelected
                  ? Theme.of(context)
                      .colorScheme
                      .primary
                  : Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
            ),

            const SizedBox(height: 4),

            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                    : Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
