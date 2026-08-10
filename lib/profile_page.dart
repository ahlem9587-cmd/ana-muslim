import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final ImagePicker _picker = ImagePicker();

  bool darkMode = false;

  String userName = '';
  String? profileImagePath;

  int tasbeehCount = 0;
  String lastSurah = '—';
  int favoriteAdhkarCount = 0;
  int favoriteHadithCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      userName = prefs.getString('user_name') ?? '';

      profileImagePath =
          prefs.getString('profile_image_path');

      tasbeehCount =
          prefs.getInt('tasbeeh_count') ?? 0;

      lastSurah =
          prefs.getString('last_surah') ?? '—';

      final adhkar =
          prefs.getStringList('favorite_adhkar') ?? [];

      final hadith =
          prefs.getStringList('favorite_hadith') ?? [];

      favoriteAdhkarCount = adhkar.length;
      favoriteHadithCount = hadith.length;
    });
  }

  Map<String, String> get texts {
    switch (widget.language) {
      case 'en':
        return {
          'title': 'Profile',
          'chooseName': 'Choose your name',
          'blessing': 'May Allah bless you 🌿',
          'lastRead': 'Last Read',
          'savedHadith': 'Favorite Hadiths',
          'hadiths': 'Hadiths',
          'tasbeeh': 'Tasbeeh Count',
          'tasbeehText': 'Tasbeeh',
          'favorite': 'Favorite Adhkar',
          'adhkar': 'Adhkar',
          'settings': 'Settings',
          'language': 'Language',
          'dark': 'Dark Mode',
          'nameTitle': 'Choose your name',
          'nameHint': 'Enter your name',
          'cancel': 'Cancel',
          'save': 'Save',
          'surah': 'Last Surah',
          'camera': 'Camera',
          'gallery': 'Gallery',
          'choosePhoto': 'Choose a profile photo',
        };

      case 'fr':
        return {
          'title': 'Profil',
          'chooseName': 'Choisissez votre nom',
          'blessing': 'Qu’Allah vous bénisse 🌿',
          'lastRead': 'Dernière lecture',
          'savedHadith': 'Hadiths favoris',
          'hadiths': 'Hadiths',
          'tasbeeh': 'Compteur de Tasbih',
          'tasbeehText': 'Tasbih',
          'favorite': 'Adhkar favoris',
          'adhkar': 'Adhkar',
          'settings': 'Paramètres',
          'language': 'Langue',
          'dark': 'Mode sombre',
          'nameTitle': 'Choisissez votre nom',
          'nameHint': 'Entrez votre nom',
          'cancel': 'Annuler',
          'save': 'Enregistrer',
          'surah': 'Dernière sourate',
          'camera': 'Caméra',
          'gallery': 'Galerie',
          'choosePhoto': 'Choisir une photo de profil',
        };

      case 'tr':
        return {
          'title': 'Profil',
          'chooseName': 'Adınızı seçin',
          'blessing': 'Allah seni bereketlendirsin 🌿',
          'lastRead': 'Son Okuma',
          'savedHadith': 'Favori Hadisler',
          'hadiths': 'Hadis',
          'tasbeeh': 'Tesbih Sayacı',
          'tasbeehText': 'Tesbih',
          'favorite': 'Favori Zikirler',
          'adhkar': 'Zikir',
          'settings': 'Ayarlar',
          'language': 'Dil',
          'dark': 'Karanlık Mod',
          'nameTitle': 'Adınızı seçin',
          'nameHint': 'Adınızı girin',
          'cancel': 'İptal',
          'save': 'Kaydet',
          'surah': 'Son Sure',
          'camera': 'Kamera',
          'gallery': 'Galeri',
          'choosePhoto': 'Profil fotoğrafı seçin',
        };

      case 'ur':
        return {
          'title': 'پروفائل',
          'chooseName': 'اپنا نام منتخب کریں',
          'blessing': 'اللہ آپ کو برکت دے 🌿',
          'lastRead': 'آخری تلاوت',
          'savedHadith': 'پسندیدہ احادیث',
          'hadiths': 'احادیث',
          'tasbeeh': 'تسبیح کاؤنٹ',
          'tasbeehText': 'تسبیح',
          'favorite': 'پسندیدہ اذکار',
          'adhkar': 'اذکار',
          'settings': 'ترتیبات',
          'language': 'زبان',
          'dark': 'ڈارک موڈ',
          'nameTitle': 'اپنا نام منتخب کریں',
          'nameHint': 'اپنا نام لکھیں',
          'cancel': 'منسوخ',
          'save': 'محفوظ کریں',
          'surah': 'آخری سورت',
          'camera': 'کیمرہ',
          'gallery': 'گیلری',
          'choosePhoto': 'پروفائل تصویر منتخب کریں',
        };

      default:
        return {
          'title': 'الملف الشخصي',
          'chooseName': 'اختر اسمك',
          'blessing': 'بارك الله فيك 🌿',
          'lastRead': 'آخر قراءة',
          'savedHadith': 'الأحاديث المفضلة',
          'hadiths': 'أحاديث',
          'tasbeeh': 'عداد التسبيح',
          'tasbeehText': 'تسبيحة',
          'favorite': 'الأذكار المفضلة',
          'adhkar': 'أذكار',
          'settings': 'الإعدادات',
          'language': 'اللغة',
          'dark': 'الوضع الداكن',
          'nameTitle': 'اختر اسمك',
          'nameHint': 'اكتب اسمك',
          'cancel': 'إلغاء',
          'save': 'حفظ',
          'surah': 'آخر سورة',
          'camera': 'الكاميرا',
          'gallery': 'المعرض',
          'choosePhoto': 'اختر صورة للملف الشخصي',
        };
    }
  }

  // =========================
  // صورة البروفايل
  // =========================

  Future<void> _showImageOptions() async {
    final t = texts;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t['choosePhoto']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_rounded,
                    size: 30,
                  ),
                  title: Text(
                    t['camera']!,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                      sheetContext,
                      ImageSource.camera,
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.photo_library_rounded,
                    size: 30,
                  ),
                  title: Text(
                    t['gallery']!,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                      sheetContext,
                      ImageSource.gallery,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;

    await _pickImage(source);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (image == null) return;

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        'profile_image_path',
        image.path,
      );

      if (!mounted) return;

      setState(() {
        profileImagePath = image.path;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'حدث خطأ أثناء اختيار الصورة',
          ),
        ),
      );
    }
  }

  // =========================
  // الاسم
  // =========================

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
            decoration: InputDecoration(
              hintText: t['nameHint']!,
              prefixIcon:
                  const Icon(Icons.person),
              border:
                  const OutlineInputBorder(),
            ),
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
                final name =
                    controller.text.trim();

                if (name.isNotEmpty) {
                  Navigator.pop(
                    dialogContext,
                    name,
                  );
                }
              },
              child: Text(t['save']!),
            ),
          ],
        );
      },
    );

    if (newName == null ||
        newName.trim().isEmpty) {
      return;
    }

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'user_name',
      newName.trim(),
    );

    if (!mounted) return;

    setState(() {
      userName = newName.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = texts;

    final isArabic =
        widget.language == 'ar' ||
        widget.language == 'ur';

    final displayName =
        userName.isEmpty
            ? t['chooseName']!
            : userName;

    final hasImage =
        profileImagePath != null &&
        profileImagePath!.isNotEmpty &&
        File(profileImagePath!).existsSync();

    return Directionality(
      textDirection:
          isArabic
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: darkMode
            ? const Color(0xFF10251F)
            : const Color(0xFFF4EDE1),

        // ==========================================
        // لا يوجد شريط تنقل سفلي هنا
        // HomePage هو المسؤول عن الشريط الوحيد
        // ==========================================

        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadProfileData,
            child: ListView(
              padding:
                  const EdgeInsets.fromLTRB(
                18,
                20,
                18,
                25,
              ),
              children: [
                Text(
                  "I’m Muslim",
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight:
                        FontWeight.bold,
                    color: darkMode
                        ? Colors.white
                        : const Color(
                            0xFF173D32,
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // =========================
                // صورة البروفايل
                // =========================

                Center(
                  child: GestureDetector(
                    onTap: _showImageOptions,
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration:
                              BoxDecoration(
                            shape:
                                BoxShape.circle,
                            color:
                                const Color(
                              0xFFE8DDCC,
                            ),
                            border:
                                Border.all(
                              color:
                                  const Color(
                                0xFFF5F0E8,
                              ),
                              width: 6,
                            ),
                            image: hasImage
                                ? DecorationImage(
                                    image:
                                        FileImage(
                                      File(
                                        profileImagePath!,
                                      ),
                                    ),
                                    fit: BoxFit
                                        .cover,
                                  )
                                : null,
                          ),
                          child: hasImage
                              ? null
                              : const Icon(
                                  Icons.person,
                                  size: 62,
                                  color:
                                      Color(
                                    0xFF55736B,
                                  ),
                                ),
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration:
                                BoxDecoration(
                              shape:
                                  BoxShape.circle,
                              color:
                                  const Color(
                                0xFF17604B,
                              ),
                              border:
                                  Border.all(
                                color:
                                    Colors.white,
                                width: 3,
                              ),
                            ),
                            child:
                                const Icon(
                              Icons
                                  .camera_alt_rounded,
                              color:
                                  Colors.white,
                              size: 21,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                GestureDetector(
                  onTap: _chooseName,
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      Flexible(
                        child: Text(
                          displayName,
                          textAlign:
                              TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                            color: userName
                                    .isEmpty
                                ? const Color(
                                    0xFF17604B,
                                  )
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
                        size: 19,
                        color: darkMode
                            ? Colors.white70
                            : const Color(
                                0xFF55736B,
                              ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  t['blessing']!,
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: darkMode
                        ? Colors.white70
                        : const Color(
                            0xFF555555,
                          ),
                  ),
                ),

                const SizedBox(height: 28),

                _infoCard(
                  icon:
                      Icons.menu_book_rounded,
                  title:
                      t['lastRead']!,
                  value: lastSurah,
                  iconColor:
                      const Color(
                    0xFF17604B,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _smallCard(
                        icon:
                            Icons.touch_app_rounded,
                        title:
                            t['tasbeeh']!,
                        value:
                            '$tasbeehCount',
                        subtitle:
                            t['tasbeehText']!,
                        iconColor:
                            const Color(
                          0xFFB86F27,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: _smallCard(
                        icon:
                            Icons.star_rounded,
                        title:
                            t['favorite']!,
                        value:
                            '$favoriteAdhkarCount',
                        subtitle:
                            t['adhkar']!,
                        iconColor:
                            const Color(
                          0xFFE6AA28,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _smallCard(
                  icon:
                      Icons.star_rounded,
                  title:
                      t['savedHadith']!,
                  value:
                      '$favoriteHadithCount',
                  subtitle:
                      t['hadiths']!,
                  iconColor:
                      const Color(
                    0xFFE6AA28,
                  ),
                  fullWidth: true,
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  decoration:
                      BoxDecoration(
                    color: darkMode
                        ? const Color(
                            0xFF19342C,
                          )
                        : const Color(
                            0xFFFFFAF2,
                          ),
                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),
                  ),
                  child: Column(
                    children: [
                      _settingTile(
                        Icons.person,
                        t['chooseName']!,
                        onTap:
                            _chooseName,
                      ),

                      _divider(),

                      _settingTile(
                        Icons.settings,
                        t['settings']!,
                        onTap: () {},
                      ),

                      _divider(),

                      _settingTile(
                        Icons.language,
                        t['language']!,
                        onTap: () {},
                      ),

                      _divider(),

                      _settingTile(
                        Icons.dark_mode,
                        t['dark']!,
                        trailing:
                            Switch(
                          value:
                              darkMode,
                          onChanged:
                              (value) {
                            setState(() {
                              darkMode =
                                  value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // مساحة بسيطة أسفل المحتوى
                // لأن HomePage سيضع شريطه أسفل الشاشة
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: darkMode
            ? const Color(0xFF19342C)
            : const Color(0xFFFFFAF2),
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 42,
            color: iconColor,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    color: darkMode
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                    color: darkMode
                        ? Colors.white
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

  Widget _smallCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color iconColor,
    bool fullWidth = false,
  }) {
    return Container(
      width: double.infinity,
      height: fullWidth ? 120 : 145,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: darkMode
            ? const Color(0xFF19342C)
            : const Color(0xFFFFFAF2),
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 35,
            color: iconColor,
          ),

          const SizedBox(height: 7),

          Text(
            title,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: darkMode
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            value,
            style: TextStyle(
              fontSize: 21,
              fontWeight:
                  FontWeight.bold,
              color: darkMode
                  ? Colors.white
                  : Colors.black87,
            ),
          ),

          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
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
    IconData icon,
    String title, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 3,
      ),

      leading: Icon(
        icon,
        size: 28,
        color: darkMode
            ? Colors.white70
            : const Color(0xFF536761),
      ),

      title: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight:
              FontWeight.w500,
          color: darkMode
              ? Colors.white
              : Colors.black87,
        ),
      ),

      trailing: trailing ??
          const Icon(
            Icons.arrow_forward_ios,
            size: 17,
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
}
