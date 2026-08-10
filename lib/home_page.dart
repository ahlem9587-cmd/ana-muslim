import 'package:flutter/material.dart';
import 'quran_page.dart';
import 'recitations_page.dart';
import 'profile_page.dart';
import 'tasbeeh_page.dart';

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
          'hadith': 'Hadith',
          'profile': 'Profile',
          'recitations': 'Recitation Majlis',
          'recitationsSub': 'Share and listen to Quran recitations',
          'prayer': 'Prayer Times',
          'tasbeeh': 'Tasbeeh',
          'welcome': "Welcome to I'm Muslim",
        };

      case 'fr':
        return {
          'title': 'Je suis Musulman',
          'home': 'Accueil',
          'quran': 'Coran',
          'dhikr': 'Adhkar',
          'hadith': 'Hadith',
          'profile': 'Profil',
          'recitations': 'Majlis de récitation',
          'recitationsSub': 'Partagez et écoutez les récitations',
          'prayer': 'Heures de prière',
          'tasbeeh': 'Tasbih',
          'welcome': 'Bienvenue',
        };

      case 'tr':
        return {
          'title': 'Ben Müslümanım',
          'home': 'Ana Sayfa',
          'quran': 'Kur’an',
          'dhikr': 'Zikir',
          'hadith': 'Hadis',
          'profile': 'Profil',
          'recitations': 'Tilavet Meclisi',
          'recitationsSub': 'Tilavetleri paylaş ve dinle',
          'prayer': 'Namaz Vakitleri',
          'tasbeeh': 'Tesbih',
          'welcome': 'Hoş geldiniz',
        };

      case 'ur':
        return {
          'title': 'میں مسلمان ہوں',
          'home': 'ہوم',
          'quran': 'قرآن',
          'dhikr': 'اذکار',
          'hadith': 'حدیث',
          'profile': 'پروفائل',
          'recitations': 'تلاوت کی مجلس',
          'recitationsSub': 'تلاوتیں شیئر کریں اور سنیں',
          'prayer': 'نماز کے اوقات',
          'tasbeeh': 'تسبیح',
          'welcome': 'خوش آمدید',
        };

      case 'id':
        return {
          'title': 'Saya Muslim',
          'home': 'Beranda',
          'quran': 'Al-Qur’an',
          'dhikr': 'Dzikir',
          'hadith': 'Hadis',
          'profile': 'Profil',
          'recitations': 'Majelis Tilawah',
          'recitationsSub':
              'Bagikan dan dengarkan tilawah Al-Qur’an',
          'prayer': 'Waktu Salat',
          'tasbeeh': 'Tasbih',
          'welcome': 'Selamat datang di Saya Muslim',
        };

      case 'ms':
        return {
          'title': 'Saya Muslim',
          'home': 'Utama',
          'quran': 'Al-Quran',
          'dhikr': 'Zikir',
          'hadith': 'Hadis',
          'profile': 'Profil',
          'recitations': 'Majlis Tilawah',
          'recitationsSub':
              'Kongsi dan dengar bacaan Al-Quran',
          'prayer': 'Waktu Solat',
          'tasbeeh': 'Tasbih',
          'welcome': 'Selamat datang ke Saya Muslim',
        };

      default:
        return {
          'title': 'أنا مسلم',
          'home': 'الرئيسية',
          'quran': 'القرآن',
          'dhikr': 'الأذكار',
          'hadith': 'الحديث',
          'profile': 'الملف الشخصي',
          'recitations': 'مجلس التلاوة',
          'recitationsSub': 'شارك واستمع إلى تلاوات القرآن',
          'prayer': 'أوقات الصلاة',
          'tasbeeh': 'المسبحة',
          'welcome': 'مرحبًا بك في تطبيق أنا مسلم',
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
                    Icons.person_rounded,
                    t['profile']!,
                    5,
                  ),

                  _bottomItem(
                    Icons.record_voice_over_rounded,
                    t['recitations']!,
                    6,
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

      case 3:
        return TasbeehPage(
          language: widget.language,
        );

      case 5:
        return ProfilePage(
          language: widget.language,
        );

      case 6:
        return RecitationsPage(
          language: widget.language,
        );

      case 2:
        return _simplePage(
          Icons.favorite_rounded,
          texts['dhikr']!,
        );

      case 4:
        return _simplePage(
          Icons.auto_stories_rounded,
          texts['hadith']!,
        );

      default:
        return _homeContent();
    }
  }

  Widget _homeContent() {
    final t = texts;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          Text(
            t['welcome']!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 28),

          _menuCard(
            Icons.menu_book_rounded,
            t['quran']!,
            () {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),

          _menuCard(
            Icons.access_time_rounded,
            t['prayer']!,
            () {},
          ),

          _menuCard(
            Icons.favorite_rounded,
            t['dhikr']!,
            () {
              setState(() {
                selectedIndex = 2;
              });
            },
          ),

          _menuCard(
            Icons.touch_app_rounded,
            t['tasbeeh']!,
            () {
              setState(() {
                selectedIndex = 3;
              });
            },
          ),

          _menuCard(
            Icons.person_rounded,
            t['profile']!,
            () {
              setState(() {
                selectedIndex = 5;
              });
            },
          ),

          const SizedBox(height: 10),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(18),
              leading: const Icon(
                Icons.record_voice_over_rounded,
                size: 42,
              ),
              title: Text(
                t['recitations']!,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  t['recitationsSub']!,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
              onTap: () {
                setState(() {
                  selectedIndex = 6;
                });
              },
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _menuCard(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 28,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 17,
                ),
              ],
            ),
          ),
        ),
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

  Widget _simplePage(
    IconData icon,
    String title,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Theme.of(context)
                .colorScheme
                .primary,
          ),

          const SizedBox(height: 20),

          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'قريبًا بإذن الله',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
