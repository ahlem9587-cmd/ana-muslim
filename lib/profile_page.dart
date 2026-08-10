import 'package:flutter/material.dart';
import 'quran_page.dart';
import 'recitations_page.dart';

class ProfilePage extends StatefulWidget {
  final String language;

  const ProfilePage({
    super.key,
    required this.language,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool darkMode = false;

  // اسم الحساب
  String userName = '';

  Map<String, String> get texts {
    switch (widget.language) {
      case 'en':
        return {
          'title': 'Profile',
          'chooseName': 'Choose your name',
          'blessing': 'May Allah bless you 🌿',
          'quranProgress': 'Qur’an Progress',
          'juz': 'Juz 14 / 30',
          'lastRead': 'Last Read',
          'surah': 'Surah Al-Kahf',
          'verse': 'Verse 1–74',
          'savedHadith': 'Saved Hadiths',
          'hadiths': 'Hadiths',
          'tasbeeh': 'Tasbeeh Count',
          'tasbeehText': 'Tasbeeh',
          'favorite': 'Favorite Adhkar',
          'adhkar': 'Adhkar',
          'profileInfo': 'Profile Information',
          'settings': 'Settings',
          'language': 'Language',
          'english': 'English',
          'dark': 'Dark Mode',
          'home': 'Home',
          'quran': 'Qur’an',
          'adhkarNav': 'Adhkar',
          'hadithNav': 'Hadith',
          'profile': 'Profile',
          'majlis': 'Recitation Majlis',
          'nameTitle': 'Choose your name',
          'nameHint': 'Enter your name',
          'cancel': 'Cancel',
          'save': 'Save',
        };

      case 'fr':
        return {
          'title': 'Profil',
          'chooseName': 'Choisissez votre nom',
          'blessing': 'Qu’Allah vous bénisse 🌿',
          'quranProgress': 'Progression du Coran',
          'juz': 'Juz 14 / 30',
          'lastRead': 'Dernière lecture',
          'surah': 'Sourate Al-Kahf',
          'verse': 'Versets 1–74',
          'savedHadith': 'Hadiths enregistrés',
          'hadiths': 'Hadiths',
          'tasbeeh': 'Compteur de Tasbih',
          'tasbeehText': 'Tasbih',
          'favorite': 'Adhkar favoris',
          'adhkar': 'Adhkar',
          'profileInfo': 'Informations du profil',
          'settings': 'Paramètres',
          'language': 'Langue',
          'english': 'Français',
          'dark': 'Mode sombre',
          'home': 'Accueil',
          'quran': 'Coran',
          'adhkarNav': 'Adhkar',
          'hadithNav': 'Hadith',
          'profile': 'Profil',
          'majlis': 'Majlis de récitation',
          'nameTitle': 'Choisissez votre nom',
          'nameHint': 'Entrez votre nom',
          'cancel': 'Annuler',
          'save': 'Enregistrer',
        };

      case 'tr':
        return {
          'title': 'Profil',
          'chooseName': 'Adınızı seçin',
          'blessing': 'Allah seni bereketlendirsin 🌿',
          'quranProgress': 'Kur’an İlerlemesi',
          'juz': 'Cüz 14 / 30',
          'lastRead': 'Son Okuma',
          'surah': 'Kehf Suresi',
          'verse': 'Ayet 1–74',
          'savedHadith': 'Kaydedilen Hadisler',
          'hadiths': 'Hadis',
          'tasbeeh': 'Tesbih Sayacı',
          'tasbeehText': 'Tesbih',
          'favorite': 'Favori Zikirler',
          'adhkar': 'Zikir',
          'profileInfo': 'Profil Bilgileri',
          'settings': 'Ayarlar',
          'language': 'Dil',
          'english': 'Türkçe',
          'dark': 'Karanlık Mod',
          'home': 'Ana Sayfa',
          'quran': 'Kur’an',
          'adhkarNav': 'Zikir',
          'hadithNav': 'Hadis',
          'profile': 'Profil',
          'majlis': 'Tilavet Meclisi',
          'nameTitle': 'Adınızı seçin',
          'nameHint': 'Adınızı girin',
          'cancel': 'İptal',
          'save': 'Kaydet',
        };

      case 'ur':
        return {
          'title': 'پروفائل',
          'chooseName': 'اپنا نام منتخب کریں',
          'blessing': 'اللہ آپ کو برکت دے 🌿',
          'quranProgress': 'قرآن کی پیشرفت',
          'juz': 'جز 14 / 30',
          'lastRead': 'آخری تلاوت',
          'surah': 'سورۃ الکہف',
          'verse': 'آیت 1–74',
          'savedHadith': 'محفوظ احادیث',
          'hadiths': 'احادیث',
          'tasbeeh': 'تسبیح کاؤنٹ',
          'tasbeehText': 'تسبیح',
          'favorite': 'پسندیدہ اذکار',
          'adhkar': 'اذکار',
          'profileInfo': 'پروفائل کی معلومات',
          'settings': 'ترتیبات',
          'language': 'زبان',
          'english': 'اردو',
          'dark': 'ڈارک موڈ',
          'home': 'ہوم',
          'quran': 'قرآن',
          'adhkarNav': 'اذکار',
          'hadithNav': 'حدیث',
          'profile': 'پروفائل',
          'majlis': 'تلاوت کی مجلس',
          'nameTitle': 'اپنا نام منتخب کریں',
          'nameHint': 'اپنا نام لکھیں',
          'cancel': 'منسوخ',
          'save': 'محفوظ کریں',
        };

      default:
        return {
          'title': 'الملف الشخصي',
          'chooseName': 'اختر اسمك',
          'blessing': 'بارك الله فيك 🌿',
          'quranProgress': 'تقدم القرآن',
          'juz': 'الجزء 14 / 30',
          'lastRead': 'آخر قراءة',
          'surah': 'سورة الكهف',
          'verse': 'الآية 1–74',
          'savedHadith': 'الأحاديث المحفوظة',
          'hadiths': 'حديث',
          'tasbeeh': 'عداد التسبيح',
          'tasbeehText': 'تسبيحة',
          'favorite': 'الأذكار المفضلة',
          'adhkar': 'أذكار',
          'profileInfo': 'معلومات الملف الشخصي',
          'settings': 'الإعدادات',
          'language': 'اللغة',
          'english': 'العربية',
          'dark': 'الوضع الداكن',
          'home': 'الرئيسية',
          'quran': 'القرآن',
          'adhkarNav': 'الأذكار',
          'hadithNav': 'الحديث',
          'profile': 'البروفايل',
          'majlis': 'مجلس التلاوة',
          'nameTitle': 'اختر اسمك',
          'nameHint': 'اكتب اسمك',
          'cancel': 'إلغاء',
          'save': 'حفظ',
        };
    }
  }

  Future<void> _chooseName() async {
    final t = texts;

    final controller = TextEditingController(
      text: userName,
    );

    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t['nameTitle']!),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: t['nameHint']!,
              prefixIcon: const Icon(Icons.person),
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) {
              final name = controller.text.trim();

              if (name.isNotEmpty) {
                Navigator.pop(dialogContext, name);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(t['cancel']!),
            ),
            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();

                if (name.isNotEmpty) {
                  Navigator.pop(dialogContext, name);
                }
              },
              child: Text(t['save']!),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.trim().isNotEmpty) {
      setState(() {
        userName = newName.trim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = texts;

    final isArabic =
        widget.language == 'ar' ||
        widget.language == 'ur';

    final displayName =
        userName.isEmpty ? t['chooseName']! : userName;

    return Directionality(
      textDirection:
          isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: darkMode
            ? const Color(0xFF10251F)
            : const Color(0xFFF4EDE1),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    12,
                    18,
                    20,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "I’m Muslim",
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: darkMode
                              ? Colors.white
                              : const Color(0xFF173D32),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // الصورة الشخصية
                      GestureDetector(
                        onTap: _chooseName,
                        child: Container(
                          width: 118,
                          height: 118,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFE8DDCC),
                            border: Border.all(
                              color: const Color(0xFFF5F0E8),
                              width: 6,
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 62,
                            color: Color(0xFF55736B),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // اسم المستخدم
                      GestureDetector(
                        onTap: _chooseName,
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                displayName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: userName.isEmpty
                                      ? const Color(0xFF17604B)
                                      : (darkMode
                                          ? Colors.white
                                          : const Color(
                                              0xFF172D27,
                                            )),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.edit,
                              size: 20,
                              color: darkMode
                                  ? Colors.white70
                                  : const Color(0xFF55736B),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        t['blessing']!,
                        style: TextStyle(
                          fontSize: 16,
                          color: darkMode
                              ? Colors.white70
                              : const Color(0xFF555555),
                        ),
                      ),

                      const SizedBox(height: 28),

                      _progressCard(
                        context,
                        t['quranProgress']!,
                        t['juz']!,
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _smallCard(
                              context,
                              Icons.menu_book,
                              t['lastRead']!,
                              t['surah']!,
                              t['verse']!,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _smallCard(
                              context,
                              Icons.favorite,
                              t['savedHadith']!,
                              '128',
                              t['hadiths']!,
                              iconColor: Colors.red,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: _smallCard(
                              context,
                              Icons.circle_outlined,
                              t['tasbeeh']!,
                              '2,458',
                              t['tasbeehText']!,
                              iconColor:
                                  const Color(0xFFB86F27),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _smallCard(
                              context,
                              Icons.star,
                              t['favorite']!,
                              '23',
                              t['adhkar']!,
                              iconColor:
                                  const Color(0xFFE6AA28),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: darkMode
                              ? const Color(0xFF19342C)
                              : const Color(0xFFFFFAF2),
                          borderRadius:
                              BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            _settingTile(
                              context,
                              Icons.person,
                              t['profileInfo']!,
                              onTap: _chooseName,
                            ),
                            _divider(),
                            _settingTile(
                              context,
                              Icons.settings,
                              t['settings']!,
                              onTap: () {},
                            ),
                            _divider(),
                            _settingTile(
                              context,
                              Icons.language,
                              t['language']!,
                              trailingText:
                                  t['english']!,
                              onTap: () {},
                            ),
                            _divider(),
                            _settingTile(
                              context,
                              Icons.dark_mode,
                              t['dark']!,
                              trailing: Switch(
                                value: darkMode,
                                onChanged: (value) {
                                  setState(() {
                                    darkMode = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              _bottomNavigation(context, t),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressCard(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkMode
            ? const Color(0xFF19342C)
            : const Color(0xFFFFFAF2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF17604B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.menu_book,
              color: Color(0xFFEBCB78),
              size: 38,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: darkMode
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      '45%',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: darkMode
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: 0.45,
                    minHeight: 10,
                    backgroundColor:
                        const Color(0xFFE5DED3),
                    valueColor:
                        const AlwaysStoppedAnimation(
                      Color(0xFF17604B),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: darkMode
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    String subtitle, {
    Color iconColor = const Color(0xFF17604B),
  }) {
    return Container(
      height: 155,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: darkMode
            ? const Color(0xFF19342C)
            : const Color(0xFFFFFAF2),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 45,
            color: iconColor,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              color: darkMode
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: darkMode
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: darkMode
                  ? Colors.white70
                  : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingTile(
    BuildContext context,
    IconData icon,
    String title, {
    String? trailingText,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 3,
      ),
      leading: Icon(
        icon,
        size: 29,
        color: darkMode
            ? Colors.white70
            : const Color(0xFF536761),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: darkMode
              ? Colors.white
              : Colors.black87,
        ),
      ),
      trailing: trailing ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null)
                Text(
                  trailingText,
                  style: TextStyle(
                    fontSize: 15,
                    color: darkMode
                        ? Colors.white60
                        : Colors.black54,
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                size: 17,
              ),
            ],
          ),
      onTap: onTap,
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      indent: 20,
      endIndent: 20,
      color: darkMode
          ? Colors.white12
          : Colors.black12,
    );
  }

  Widget _bottomNavigation(
    BuildContext context,
    Map<String, String> t,
  ) {
    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: darkMode
            ? const Color(0xFF17352D)
            : const Color(0xFFFFFAF2),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _navItem(
              context,
              Icons.home_outlined,
              t['home']!,
              false,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _navItem(
              context,
              Icons.menu_book_outlined,
              t['quran']!,
              false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuranPage(
                      language: widget.language,
                    ),
                  ),
                );
              },
            ),
            _navItem(
              context,
              Icons.favorite_border,
              t['adhkarNav']!,
              false,
            ),
            _navItem(
              context,
              Icons.auto_stories_outlined,
              t['hadithNav']!,
              false,
            ),
            _navItem(
              context,
              Icons.menu_book,
              t['majlis']!,
              false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecitationsPage(
                      language: widget.language,
                    ),
                  ),
                );
              },
            ),
            _navItem(
              context,
              Icons.person,
              t['profile']!,
              true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    bool selected, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 88,
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 29,
              color: selected
                  ? const Color(0xFF17604B)
                  : (darkMode
                      ? Colors.white70
                      : Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: selected
                    ? const Color(0xFF17604B)
                    : (darkMode
                        ? Colors.white70
                        : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
