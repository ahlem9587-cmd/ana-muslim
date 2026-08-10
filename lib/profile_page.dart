import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  File? _profileImage;

  Map<String, String> get texts {
    switch (widget.language) {
      case 'en':
        return {
          'title': 'Profile',
          'welcome': 'My Profile',
          'name': 'Muslim',
          'blessing': 'May Allah bless you',
          'progress': 'Qur’an Progress',
          'lastRead': 'Last Read',
          'saved': 'Saved Hadiths',
          'tasbeeh': 'Tasbeeh Count',
          'favorite': 'Favorite Adhkar',
          'info': 'Profile Information',
          'settings': 'Settings',
          'language': 'Language',
          'dark': 'Dark Mode',
          'quran': 'Qur’an',
          'adhkar': 'Adhkar',
          'hadith': 'Hadith',
          'home': 'Home',
          'camera': 'Camera',
          'gallery': 'Gallery',
          'cancel': 'Cancel',
          'quranValue': '45%',
          'juz': 'Juz 14 / 30',
          'surah': 'Surah Al-Kahf',
          'verse': 'Verse 1–74',
          'hadithValue': '128',
          'hadithText': 'Hadiths',
          'tasbeehValue': '2,458',
          'tasbeehText': 'Tasbeeh',
          'adhkarValue': '23',
          'adhkarText': 'Adhkar',
        };

      case 'fr':
        return {
          'title': 'Profil',
          'welcome': 'Mon profil',
          'name': 'Musulman',
          'blessing': 'Qu’Allah vous bénisse',
          'progress': 'Progression du Coran',
          'lastRead': 'Dernière lecture',
          'saved': 'Hadiths enregistrés',
          'tasbeeh': 'Compteur de Tasbeeh',
          'favorite': 'Adhkar favoris',
          'info': 'Informations du profil',
          'settings': 'Paramètres',
          'language': 'Langue',
          'dark': 'Mode sombre',
          'quran': 'Coran',
          'adhkar': 'Adhkar',
          'hadith': 'Hadith',
          'home': 'Accueil',
          'camera': 'Caméra',
          'gallery': 'Galerie',
          'cancel': 'Annuler',
          'quranValue': '45%',
          'juz': 'Juz 14 / 30',
          'surah': 'Sourate Al-Kahf',
          'verse': 'Versets 1–74',
          'hadithValue': '128',
          'hadithText': 'Hadiths',
          'tasbeehValue': '2 458',
          'tasbeehText': 'Tasbeeh',
          'adhkarValue': '23',
          'adhkarText': 'Adhkar',
        };

      case 'tr':
        return {
          'title': 'Profil',
          'welcome': 'Profilim',
          'name': 'Müslüman',
          'blessing': 'Allah sizi korusun',
          'progress': 'Kur’an İlerlemesi',
          'lastRead': 'Son Okunan',
          'saved': 'Kaydedilen Hadisler',
          'tasbeeh': 'Tesbih Sayacı',
          'favorite': 'Favori Zikirler',
          'info': 'Profil Bilgileri',
          'settings': 'Ayarlar',
          'language': 'Dil',
          'dark': 'Karanlık Mod',
          'quran': 'Kur’an',
          'adhkar': 'Zikir',
          'hadith': 'Hadis',
          'home': 'Ana Sayfa',
          'camera': 'Kamera',
          'gallery': 'Galeri',
          'cancel': 'İptal',
          'quranValue': '45%',
          'juz': 'Cüz 14 / 30',
          'surah': 'Kehf Suresi',
          'verse': 'Ayet 1–74',
          'hadithValue': '128',
          'hadithText': 'Hadis',
          'tasbeehValue': '2.458',
          'tasbeehText': 'Tesbih',
          'adhkarValue': '23',
          'adhkarText': 'Zikir',
        };

      case 'ur':
        return {
          'title': 'پروفائل',
          'welcome': 'میرا پروفائل',
          'name': 'مسلمان',
          'blessing': 'اللہ آپ کو برکت دے',
          'progress': 'قرآن کی پیش رفت',
          'lastRead': 'آخری تلاوت',
          'saved': 'محفوظ احادیث',
          'tasbeeh': 'تسبیح کاؤنٹر',
          'favorite': 'پسندیدہ اذکار',
          'info': 'پروفائل کی معلومات',
          'settings': 'ترتیبات',
          'language': 'زبان',
          'dark': 'ڈارک موڈ',
          'quran': 'قرآن',
          'adhkar': 'اذکار',
          'hadith': 'حدیث',
          'home': 'ہوم',
          'camera': 'کیمرہ',
          'gallery': 'گیلری',
          'cancel': 'منسوخ',
          'quranValue': '45%',
          'juz': 'جز 14 / 30',
          'surah': 'سورۃ الکہف',
          'verse': 'آیت 1–74',
          'hadithValue': '128',
          'hadithText': 'احادیث',
          'tasbeehValue': '2,458',
          'tasbeehText': 'تسبیح',
          'adhkarValue': '23',
          'adhkarText': 'اذکار',
        };

      case 'id':
        return {
          'title': 'Profil',
          'welcome': 'Profil Saya',
          'name': 'Muslim',
          'blessing': 'Semoga Allah memberkahi Anda',
          'progress': 'Kemajuan Al-Qur’an',
          'lastRead': 'Terakhir Dibaca',
          'saved': 'Hadis Tersimpan',
          'tasbeeh': 'Jumlah Tasbih',
          'favorite': 'Dzikir Favorit',
          'info': 'Informasi Profil',
          'settings': 'Pengaturan',
          'language': 'Bahasa',
          'dark': 'Mode Gelap',
          'quran': 'Al-Qur’an',
          'adhkar': 'Dzikir',
          'hadith': 'Hadis',
          'home': 'Beranda',
          'camera': 'Kamera',
          'gallery': 'Galeri',
          'cancel': 'Batal',
          'quranValue': '45%',
          'juz': 'Juz 14 / 30',
          'surah': 'Surah Al-Kahf',
          'verse': 'Ayat 1–74',
          'hadithValue': '128',
          'hadithText': 'Hadis',
          'tasbeehValue': '2.458',
          'tasbeehText': 'Tasbih',
          'adhkarValue': '23',
          'adhkarText': 'Dzikir',
        };

      case 'ms':
        return {
          'title': 'Profil',
          'welcome': 'Profil Saya',
          'name': 'Muslim',
          'blessing': 'Semoga Allah memberkati anda',
          'progress': 'Kemajuan Al-Quran',
          'lastRead': 'Bacaan Terakhir',
          'saved': 'Hadis Disimpan',
          'tasbeeh': 'Kiraan Tasbih',
          'favorite': 'Zikir Kegemaran',
          'info': 'Maklumat Profil',
          'settings': 'Tetapan',
          'language': 'Bahasa',
          'dark': 'Mod Gelap',
          'quran': 'Al-Quran',
          'adhkar': 'Zikir',
          'hadith': 'Hadis',
          'home': 'Laman Utama',
          'camera': 'Kamera',
          'gallery': 'Galeri',
          'cancel': 'Batal',
          'quranValue': '45%',
          'juz': 'Juz 14 / 30',
          'surah': 'Surah Al-Kahf',
          'verse': 'Ayat 1–74',
          'hadithValue': '128',
          'hadithText': 'Hadis',
          'tasbeehValue': '2,458',
          'tasbeehText': 'Tasbih',
          'adhkarValue': '23',
          'adhkarText': 'Zikir',
        };

      default:
        return {
          'title': 'الملف الشخصي',
          'welcome': 'ملفي الشخصي',
          'name': 'مسلم',
          'blessing': 'بارك الله فيك',
          'progress': 'تقدم القرآن',
          'lastRead': 'آخر قراءة',
          'saved': 'الأحاديث المحفوظة',
          'tasbeeh': 'عداد التسبيح',
          'favorite': 'الأذكار المفضلة',
          'info': 'معلومات الملف الشخصي',
          'settings': 'الإعدادات',
          'language': 'اللغة',
          'dark': 'الوضع الداكن',
          'quran': 'القرآن',
          'adhkar': 'الأذكار',
          'hadith': 'الحديث',
          'home': 'الرئيسية',
          'camera': 'الكاميرا',
          'gallery': 'المعرض',
          'cancel': 'إلغاء',
          'quranValue': '45%',
          'juz': 'الجزء 14 / 30',
          'surah': 'سورة الكهف',
          'verse': 'الآيات 1–74',
          'hadithValue': '128',
          'hadithText': 'حديث',
          'tasbeehValue': '2,458',
          'tasbeehText': 'تسبيحة',
          'adhkarValue': '23',
          'adhkarText': 'ذكر',
        };
    }
  }

  final Color darkGreen = const Color(0xFF064E3B);
  final Color green = const Color(0xFF0F766E);
  final Color gold = const Color(0xFFD4A64A);
  final Color cream = const Color(0xFFF8F1E3);

  Future<void> _changeProfileImage() async {
    final t = texts;

    showModalBottomSheet(
      context: context,
      backgroundColor: cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: darkGreen,
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(t['camera']!),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: darkGreen,
                    child: const Icon(
                      Icons.photo_library,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(t['gallery']!),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.close),
                  title: Text(t['cancel']!),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = texts;
    final isArabic = widget.language == 'ar' ||
        widget.language == 'ur';

    return Directionality(
      textDirection:
          isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: cream,

        appBar: AppBar(
          backgroundColor: darkGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            t['title']!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 21,
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              // =========================
              // HEADER
              // =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  20,
                  25,
                  20,
                  35,
                ),
                decoration: BoxDecoration(
                  color: darkGreen,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 62,
                            backgroundColor: green,
                            backgroundImage:
                                _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : null,
                            child: _profileImage == null
                                ? const Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),

                        Positioned(
                          bottom: 2,
                          right: 0,
                          child: GestureDetector(
                            onTap: _changeProfileImage,
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: cream,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: darkGreen,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: darkGreen,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Text(
                      t['name']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      t['blessing']!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '☘',
                      style: TextStyle(
                        color: gold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    // =========================
                    // QURAN PROGRESS
                    // =========================
                    _progressCard(
                      icon: Icons.menu_book_rounded,
                      title: t['progress']!,
                      value: t['quranValue']!,
                      subtitle: t['juz']!,
                    ),

                    const SizedBox(height: 15),

                    // =========================
                    // TWO CARDS
                    // =========================
                    Row(
                      children: [
                        Expanded(
                          child: _smallCard(
                            Icons.menu_book_rounded,
                            t['lastRead']!,
                            t['surah']!,
                            t['verse']!,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _smallCard(
                            Icons.favorite,
                            t['saved']!,
                            t['hadithValue']!,
                            t['hadithText']!,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _smallCard(
                            Icons.auto_awesome,
                            t['tasbeeh']!,
                            t['tasbeehValue']!,
                            t['tasbeehText']!,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _smallCard(
                            Icons.star,
                            t['favorite']!,
                            t['adhkarValue']!,
                            t['adhkarText']!,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // =========================
                    // SETTINGS LIST
                    // =========================
                    _settingsCard(
                      Icons.person,
                      t['info']!,
                    ),

                    _settingsCard(
                      Icons.settings,
                      t['settings']!,
                    ),

                    _settingsCard(
                      Icons.language,
                      t['language']!,
                      trailingText:
                          widget.language.toUpperCase(),
                    ),

                    _settingsCard(
                      Icons.dark_mode,
                      t['dark']!,
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {},
                        activeColor: green,
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),

        // =========================
        // BOTTOM NAVIGATION
        // =========================
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 4,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: darkGreen,
          unselectedItemColor: Colors.grey,
          backgroundColor: cream,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              label: t['home'],
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.menu_book_outlined),
              label: t['quran'],
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.water_drop_outlined),
              label: t['adhkar'],
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.menu_book),
              label: t['hadith'],
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: t['title'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: gold,
              size: 32,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        color: darkGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: 0.45,
                    minHeight: 9,
                    backgroundColor:
                        Colors.grey.shade200,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(
                      darkGreen,
                    ),
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
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
    IconData icon,
    String title,
    String value,
    String subtitle,
  ) {
    return Container(
      height: 125,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: gold,
            size: 30,
          ),

          const SizedBox(height: 5),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),

          const Spacer(),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: darkGreen,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsCard(
    IconData icon,
    String title, {
    String? trailingText,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        leading: Icon(
          icon,
          color: darkGreen,
          size: 25,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: trailing ??
            (trailingText != null
                ? Text(
                    trailingText,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  )
                : const Icon(
                    Icons.chevron_right,
                  )),
        onTap: () {},
      ),
    );
  }
}
