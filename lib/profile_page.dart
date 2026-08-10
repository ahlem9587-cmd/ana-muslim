import 'package:flutter/material.dart';

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

  Map<String, String> get texts {
    switch (widget.language) {
      case 'en':
        return {
          'title': 'Profile',
          'name': 'Muslim',
          'blessing': 'May Allah bless you 🌿',
          'quranProgress': 'Qur’an Progress',
          'juz': 'Juz 14 / 30',
          'lastRead': 'Last Read',
          'surah': 'Surah Al-Kahf',
          'verses': 'Verse 1–74',
          'savedHadith': 'Saved Hadiths',
          'hadiths': 'Hadiths',
          'tasbeeh': 'Tasbeeh Count',
          'tasbeehWord': 'Tasbeeh',
          'favorite': 'Favorite Adhkar',
          'adhkar': 'Adhkar',
          'profileInfo': 'Profile Information',
          'settings': 'Settings',
          'language': 'Language',
          'darkMode': 'Dark Mode',
          'english': 'English',
        };

      case 'fr':
        return {
          'title': 'Profil',
          'name': 'Musulman',
          'blessing': 'Qu’Allah vous bénisse 🌿',
          'quranProgress': 'Progression du Coran',
          'juz': 'Juz 14 / 30',
          'lastRead': 'Dernière lecture',
          'surah': 'Sourate Al-Kahf',
          'verses': 'Versets 1–74',
          'savedHadith': 'Hadiths enregistrés',
          'hadiths': 'Hadiths',
          'tasbeeh': 'Compteur de Tasbih',
          'tasbeehWord': 'Tasbih',
          'favorite': 'Adhkar favoris',
          'adhkar': 'Adhkar',
          'profileInfo': 'Informations du profil',
          'settings': 'Paramètres',
          'language': 'Langue',
          'darkMode': 'Mode sombre',
          'english': 'Français',
        };

      case 'tr':
        return {
          'title': 'Profil',
          'name': 'Müslüman',
          'blessing': 'Allah seni bereketlendirsin 🌿',
          'quranProgress': 'Kur’an İlerlemesi',
          'juz': 'Cüz 14 / 30',
          'lastRead': 'Son Okunan',
          'surah': 'Kehf Suresi',
          'verses': 'Ayet 1–74',
          'savedHadith': 'Kaydedilen Hadisler',
          'hadiths': 'Hadis',
          'tasbeeh': 'Tesbih Sayacı',
          'tasbeehWord': 'Tesbih',
          'favorite': 'Favori Zikirler',
          'adhkar': 'Zikir',
          'profileInfo': 'Profil Bilgileri',
          'settings': 'Ayarlar',
          'language': 'Dil',
          'darkMode': 'Karanlık Mod',
          'english': 'Türkçe',
        };

      case 'ur':
        return {
          'title': 'پروفائل',
          'name': 'مسلمان',
          'blessing': 'اللہ آپ کو برکت دے 🌿',
          'quranProgress': 'قرآن کی پیش رفت',
          'juz': 'جز 14 / 30',
          'lastRead': 'آخری تلاوت',
          'surah': 'سورۃ الکہف',
          'verses': 'آیات 1–74',
          'savedHadith': 'محفوظ احادیث',
          'hadiths': 'احادیث',
          'tasbeeh': 'تسبیح کاؤنٹ',
          'tasbeehWord': 'تسبیح',
          'favorite': 'پسندیدہ اذکار',
          'adhkar': 'اذکار',
          'profileInfo': 'پروفائل کی معلومات',
          'settings': 'ترتیبات',
          'language': 'زبان',
          'darkMode': 'ڈارک موڈ',
          'english': 'اردو',
        };

      default:
        return {
          'title': 'الملف الشخصي',
          'name': 'مسلم',
          'blessing': 'بارك الله فيك 🌿',
          'quranProgress': 'تقدم القرآن',
          'juz': 'الجزء 14 / 30',
          'lastRead': 'آخر قراءة',
          'surah': 'سورة الكهف',
          'verses': 'الآيات 1–74',
          'savedHadith': 'الأحاديث المحفوظة',
          'hadiths': 'حديث',
          'tasbeeh': 'عدد التسبيحات',
          'tasbeehWord': 'تسبيح',
          'favorite': 'الأذكار المفضلة',
          'adhkar': 'أذكار',
          'profileInfo': 'معلومات الملف الشخصي',
          'settings': 'الإعدادات',
          'language': 'اللغة',
          'darkMode': 'الوضع الداكن',
          'english': 'العربية',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = texts;
    final isArabic =
        widget.language == 'ar' || widget.language == 'ur';

    return Directionality(
      textDirection:
          isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Theme(
        data: darkMode
            ? ThemeData.dark(useMaterial3: true)
            : ThemeData.light(useMaterial3: true),
        child: Scaffold(
          appBar: AppBar(
            title: Text(t['title']!),
            centerTitle: true,
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              18,
              10,
              18,
              30,
            ),
            child: Column(
              children: [
                // =========================
                // الصورة والاسم
                // =========================
                const SizedBox(height: 8),

                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 76,
                      backgroundColor:
                          Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                      child: const CircleAvatar(
                        radius: 71,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 80,
                        ),
                      ),
                    ),

                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 23,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Text(
                  t['name']!,
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  t['blessing']!,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 28),

                // =========================
                // تقدم القرآن
                // =========================
                _quranProgress(context, t),

                const SizedBox(height: 16),

                // =========================
                // آخر قراءة + الأحاديث
                // =========================
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        context,
                        icon: Icons.menu_book,
                        title: t['lastRead']!,
                        value: t['surah']!,
                        subtitle: t['verses']!,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _statCard(
                        context,
                        icon: Icons.favorite,
                        title: t['savedHadith']!,
                        value: '128',
                        subtitle: t['hadiths']!,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // =========================
                // التسبيح + الأذكار
                // =========================
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        context,
                        icon: Icons.auto_awesome,
                        title: t['tasbeeh']!,
                        value: '2,458',
                        subtitle: t['tasbeehWord']!,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _statCard(
                        context,
                        icon: Icons.star,
                        title: t['favorite']!,
                        value: '23',
                        subtitle: t['adhkar']!,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // =========================
                // المعلومات والإعدادات
                // =========================
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withOpacity(0.45),
                    borderRadius:
                        BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      _settingsItem(
                        context,
                        Icons.person,
                        t['profileInfo']!,
                        showArrow: true,
                      ),

                      _divider(context),

                      _settingsItem(
                        context,
                        Icons.settings,
                        t['settings']!,
                        showArrow: true,
                      ),

                      _divider(context),

                      _settingsItem(
                        context,
                        Icons.language,
                        t['language']!,
                        trailingText: t['english']!,
                        showArrow: true,
                      ),

                      _divider(context),

                      _settingsItem(
                        context,
                        Icons.dark_mode,
                        t['darkMode']!,
                        switchValue: darkMode,
                        onSwitchChanged: (value) {
                          setState(() {
                            darkMode = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quranProgress(
    BuildContext context,
    Map<String, String> t,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 3),
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(14),
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                ),
                child: const Icon(
                  Icons.menu_book,
                  size: 36,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  t['quranProgress']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Text(
                '45%',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0.45,
              minHeight: 12,
            ),
          ),

          const SizedBox(height: 12),

          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              t['juz']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      height: 155,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0, 2),
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 38,
          ),

          const SizedBox(height: 8),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsItem(
    BuildContext context,
    IconData icon,
    String title, {
    String? trailingText,
    bool showArrow = false,
    bool? switchValue,
    ValueChanged<bool>? onSwitchChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 5,
      ),
      leading: Icon(
        icon,
        size: 29,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: switchValue != null
          ? Switch(
              value: switchValue,
              onChanged: onSwitchChanged,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (trailingText != null)
                  Text(
                    trailingText,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                if (showArrow)
                  const SizedBox(width: 10),
                if (showArrow)
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
              ],
            ),
      onTap: () {},
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(
      height: 1,
      indent: 22,
      endIndent: 22,
      color: Theme.of(context)
          .colorScheme
          .outlineVariant,
    );
  }
}
