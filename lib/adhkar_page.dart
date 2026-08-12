import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdhkarPage extends StatefulWidget {
  final String language;

  const AdhkarPage({
    super.key,
    required this.language,
  });

  @override
  State<AdhkarPage> createState() => _AdhkarPageState();
}

class _AdhkarPageState extends State<AdhkarPage> {
  Map<String, dynamic> adhkarData = {};

  Set<String> favorites = {};

  bool isLoading = true;

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // =========================
  // تحميل الأذكار والمفضلة
  // =========================

  Future<void> _loadData() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/hisn_almuslim.json',
      );

      final decoded = json.decode(jsonString);

      final prefs =
          await SharedPreferences.getInstance();

      final savedFavorites =
          prefs.getStringList(
                'favorite_adhkar',
              ) ??
              [];

      if (!mounted) return;

      setState(() {
        if (decoded is Map) {
          adhkarData =
              Map<String, dynamic>.from(decoded);
        }

        favorites = savedFavorites.toSet();

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تعذر تحميل الأذكار: $e',
          ),
        ),
      );
    }
  }

  // =========================
  // حفظ / إزالة المفضلة
  // =========================

  Future<void> _toggleFavorite(
    String id,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    setState(() {
      if (favorites.contains(id)) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }
    });

    await prefs.setStringList(
      'favorite_adhkar',
      favorites.toList(),
    );
  }

  // =========================
  // النصوص
  // =========================

  Map<String, String> get texts {
    switch (widget.language) {
      case 'en':
        return {
          'title': 'Adhkar',
          'favorites': 'Favorites',
          'noData': 'No adhkar available',
          'noFavorites':
              'You have no favorite adhkar yet',
          'back': 'Back',
          'search': 'Search adhkar...',
          'noSearch':
              'No adhkar found',
        };

      case 'fr':
        return {
          'title': 'Adhkar',
          'favorites': 'Favoris',
          'noData':
              'Aucun adhkar disponible',
          'noFavorites':
              'Vous n’avez pas encore de favoris',
          'back': 'Retour',
          'search':
              'Rechercher un adhkar...',
          'noSearch':
              'Aucun adhkar trouvé',
        };

      case 'tr':
        return {
          'title': 'Zikirler',
          'favorites': 'Favoriler',
          'noData':
              'Zikir bulunamadı',
          'noFavorites':
              'Henüz favori zikriniz yok',
          'back': 'Geri',
          'search':
              'Zikirlerde ara...',
          'noSearch':
              'Zikir bulunamadı',
        };

      case 'ur':
        return {
          'title': 'اذکار',
          'favorites': 'پسندیدہ',
          'noData':
              'کوئی اذکار موجود نہیں',
          'noFavorites':
              'ابھی کوئی پسندیدہ ذکر نہیں',
          'back': 'واپس',
          'search':
              'اذکار تلاش کریں...',
          'noSearch':
              'کوئی ذکر نہیں ملا',
        };

      case 'id':
        return {
          'title': 'Dzikir',
          'favorites': 'Favorit',
          'noData':
              'Tidak ada dzikir',
          'noFavorites':
              'Belum ada dzikir favorit',
          'back': 'Kembali',
          'search':
              'Cari dzikir...',
          'noSearch':
              'Dzikir tidak ditemukan',
        };

      case 'ms':
        return {
          'title': 'Zikir',
          'favorites': 'Kegemaran',
          'noData':
              'Tiada zikir tersedia',
          'noFavorites':
              'Belum ada zikir kegemaran',
          'back': 'Kembali',
          'search':
              'Cari zikir...',
          'noSearch':
              'Zikir tidak ditemui',
        };

      default:
        return {
          'title': 'الأذكار',
          'favorites': 'المفضلة',
          'noData': 'لا توجد أذكار',
          'noFavorites':
              'لا توجد أذكار مفضلة حتى الآن',
          'back': 'رجوع',
          'search':
              'ابحث في الأذكار...',
          'noSearch':
              'لم يتم العثور على ذكر',
        };
    }
  }

  // =========================
  // اتجاه اللغة
  // =========================

  bool get isRtl {
    return widget.language == 'ar' ||
        widget.language == 'ur';
  }

  // =========================
  // استخراج النص من JSON
  // =========================

  List<String> _extractTexts(
    dynamic value,
  ) {
    if (value is List) {
      return value
          .where(
            (item) => item is String,
          )
          .map(
            (item) => item.toString(),
          )
          .toList();
    }

    if (value is String) {
      return [value];
    }

    if (value is Map) {
      final result = <String>[];

      for (final entry in value.entries) {
        result.addAll(
          _extractTexts(entry.value),
        );
      }

      return result;
    }

    return [];
  }

  // =========================
  // استخراج المرجع
  // =========================

  List<String> _extractFootnotes(
    dynamic value,
  ) {
    if (value is Map &&
        value['footnote'] is List) {
      return (value['footnote'] as List)
          .map(
            (item) => item.toString(),
          )
          .toList();
    }

    return [];
  }

  // =========================
  // تنظيف البحث
  // =========================

  String _normalizeSearch(String text) {
    return text
        .toLowerCase()
        .replaceAll(
          RegExp(r'\s+'),
          ' ',
        )
        .trim();
  }

  // =========================
  // هل القسم يطابق البحث؟
  // =========================

  bool _matchesSearch(
    String title,
    dynamic value,
  ) {
    final query =
        _normalizeSearch(searchQuery);

    if (query.isEmpty) {
      return true;
    }

    final normalizedTitle =
        _normalizeSearch(title);

    if (normalizedTitle.contains(query)) {
      return true;
    }

    final textsList =
        _extractTexts(value);

    for (final text in textsList) {
      if (_normalizeSearch(text)
          .contains(query)) {
        return true;
      }
    }

    return false;
  }

  // =========================
  // صفحة الأقسام
  // =========================

  @override
  Widget build(BuildContext context) {
    final t = texts;

    return Directionality(
      textDirection: isRtl
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor:
            const Color(0xFFF4EDE1),
        appBar: AppBar(
          title: Text(
            t['title']!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor:
              const Color(0xFFF4EDE1),
          elevation: 0,
          actions: [
            IconButton(
              tooltip: t['favorites'],
              icon: const Icon(
                Icons.star_rounded,
              ),
              onPressed:
                  _openFavorites,
            ),
          ],
        ),
        body: isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(
                  color: Color(0xFF17604B),
                ),
              )
            : adhkarData.isEmpty
                ? Center(
                    child: Text(
                      t['noData']!,
                    ),
                  )
                : _buildBody(),
      ),
    );
  }

  // =========================
  // الصفحة + البحث
  // =========================

  Widget _buildBody() {
    final t = texts;

    final entries =
        adhkarData.entries.where(
      (entry) {
        return _matchesSearch(
          entry.key.toString(),
          entry.value,
        );
      },
    ).toList();

    return Column(
      children: [
        // =========================
        // خانة البحث
        // =========================

        Padding(
          padding:
              const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            8,
          ),
          child: TextField(
            textDirection: isRtl
                ? TextDirection.rtl
                : TextDirection.ltr,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration:
                InputDecoration(
              hintText:
                  t['search'],

              prefixIcon:
                  const Icon(
                Icons.search_rounded,
                color:
                    Color(0xFF17604B),
              ),

              suffixIcon:
                  searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              searchQuery =
                                  '';
                            });
                          },
                          icon:
                              const Icon(
                            Icons
                                .clear_rounded,
                          ),
                        )
                      : null,

              filled: true,

              fillColor:
                  const Color(
                0xFFFFFAF2,
              ),

              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
                borderSide:
                    BorderSide.none,
              ),

              contentPadding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),

        // =========================
        // عدد النتائج
        // =========================

        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 5,
          ),
          child: Align(
            alignment: isRtl
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(
              '${entries.length}',
              style:
                  const TextStyle(
                fontSize: 12,
                color:
                    Colors.black45,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ),

        // =========================
        // النتائج
        // =========================

        Expanded(
          child: entries.isEmpty
              ? Center(
                  child: Text(
                    t['noSearch']!,
                    style:
                        const TextStyle(
                      fontSize: 16,
                      color:
                          Colors.black54,
                    ),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  itemCount:
                      entries.length,
                  itemBuilder:
                      (context, index) {
                    final entry =
                        entries[index];

                    return _buildCategoryCard(
                      entry,
                    );
                  },
                ),
        ),
      ],
    );
  }

  // =========================
  // بطاقة القسم
  // =========================

  Widget _buildCategoryCard(
    MapEntry<String, dynamic> entry,
  ) {
    final title =
        entry.key.toString();

    final textsList =
        _extractTexts(
      entry.value,
    );

    final originalIndex =
        adhkarData.keys
            .toList()
            .indexOf(entry.key);

    final favoriteId =
        'category_$originalIndex';

    final isFavorite =
        favorites.contains(
      favoriteId,
    );

    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      elevation: 0,
      color:
          const Color(0xFFFFFAF2),
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        side: const BorderSide(
          color:
              Color(0xFFE7DDCE),
        ),
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        onTap: () {
          _openCategory(
            title,
            entry.value,
          );
        },
        child: Padding(
          padding:
              const EdgeInsets.all(
            18,
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration:
                    const BoxDecoration(
                  shape:
                      BoxShape.circle,
                  color:
                      Color(0xFFE5F0EB),
                ),
                child:
                    const Icon(
                  Icons
                      .auto_awesome_rounded,
                  color:
                      Color(0xFF17604B),
                  size: 27,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight
                                .bold,
                        color:
                            Color(
                          0xFF173D32,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      '${textsList.length} ${isRtl ? 'ذكر' : 'items'}',
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color:
                            Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {
                  _toggleFavorite(
                    favoriteId,
                  );
                },
                icon: Icon(
                  isFavorite
                      ? Icons
                          .star_rounded
                      : Icons
                          .star_border_rounded,
                  color: isFavorite
                      ? const Color(
                          0xFFE6AA28,
                        )
                      : Colors.grey,
                  size: 29,
                ),
              ),

              const Icon(
                Icons
                    .arrow_forward_ios_rounded,
                size: 15,
                color:
                    Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // فتح القسم
  // =========================

  void _openCategory(
    String title,
    dynamic value,
  ) {
    final textsList =
        _extractTexts(value);

    final footnotes =
        _extractFootnotes(value);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AdhkarDetailsPage(
          language:
              widget.language,
          title: title,
          adhkar: textsList,
          footnotes: footnotes,
          favorites: favorites,
          onFavorite: _toggleFavorite,
        ),
      ),
    );
  }

  // =========================
  // صفحة المفضلة
  // =========================

  void _openFavorites() {
    final favoriteEntries =
        <MapEntry<String, dynamic>>[];

    final entries =
        adhkarData.entries.toList();

    for (int i = 0;
        i < entries.length;
        i++) {
      final id =
          'category_$i';

      if (favorites.contains(id)) {
        favoriteEntries.add(
          entries[i],
        );
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          const Color(0xFFF4EDE1),
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (_) {
        final t = texts;

        return Directionality(
          textDirection: isRtl
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: SizedBox(
            height:
                MediaQuery.of(context)
                        .size
                        .height *
                    0.75,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color:
                            Color(0xFFE6AA28),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        t['favorites']!,
                        style:
                            const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child:
                      favoriteEntries
                              .isEmpty
                          ? Center(
                              child: Text(
                                t[
                                    'noFavorites']!,
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets
                                      .all(
                                16,
                              ),
                              itemCount:
                                  favoriteEntries
                                      .length,
                              itemBuilder:
                                  (
                                context,
                                index,
                              ) {
                                final entry =
                                    favoriteEntries[
                                        index];

                                return Card(
                                  color:
                                      const Color(
                                    0xFFFFFAF2,
                                  ),
                                  child:
                                      ListTile(
                                    title:
                                        Text(
                                      entry.key,
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                    trailing:
                                        const Icon(
                                      Icons
                                          .star_rounded,
                                      color:
                                          Color(
                                        0xFFE6AA28,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ======================================================
// صفحة تفاصيل الأذكار
// ======================================================

class AdhkarDetailsPage
    extends StatefulWidget {
  final String language;
  final String title;
  final List<String> adhkar;
  final List<String> footnotes;
  final Set<String> favorites;
  final Future<void> Function(String)
      onFavorite;

  const AdhkarDetailsPage({
    super.key,
    required this.language,
    required this.title,
    required this.adhkar,
    required this.footnotes,
    required this.favorites,
    required this.onFavorite,
  });

  @override
  State<AdhkarDetailsPage>
      createState() =>
          _AdhkarDetailsPageState();
}

class _AdhkarDetailsPageState
    extends State<
        AdhkarDetailsPage> {
  Set<String> localFavorites = {};

  @override
  void initState() {
    super.initState();

    localFavorites =
        Set<String>.from(
      widget.favorites,
    );
  }

  bool get isRtl {
    return widget.language == 'ar' ||
        widget.language == 'ur';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isRtl
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor:
            const Color(0xFFF4EDE1),
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor:
              const Color(0xFFF4EDE1),
          elevation: 0,
        ),
        body: widget.adhkar.isEmpty
            ? const Center(
                child: Text(
                  'لا يوجد نص',
                ),
              )
            : ListView.builder(
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                itemCount:
                    widget.adhkar.length,
                itemBuilder:
                    (
                  context,
                  index,
                ) {
                  final id =
                      '${widget.title}_$index';

                  final isFavorite =
                      localFavorites
                          .contains(id);

                  return Container(
                    margin:
                        const EdgeInsets
                            .only(
                      bottom: 16,
                    ),
                    padding:
                        const EdgeInsets
                            .all(20),
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFFFFAF2,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        24,
                      ),
                      border:
                          Border.all(
                        color:
                            const Color(
                          0xFFE7DDCE,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Expanded(
                              child: Text(
                                widget
                                    .adhkar[
                                        index],
                                textAlign:
                                    isRtl
                                        ? TextAlign
                                            .right
                                        : TextAlign
                                            .left,
                                style:
                                    const TextStyle(
                                  fontSize:
                                      19,
                                  height:
                                      1.9,
                                  color:
                                      Color(
                                    0xFF172D27,
                                  ),
                                ),
                              ),
                            ),

                            IconButton(
                              onPressed:
                                  () async {
                                await widget
                                    .onFavorite(
                                  id,
                                );

                                if (!mounted) {
                                  return;
                                }

                                setState(
                                  () {
                                    if (localFavorites
                                        .contains(
                                      id,
                                    )) {
                                      localFavorites
                                          .remove(
                                        id,
                                      );
                                    } else {
                                      localFavorites
                                          .add(
                                        id,
                                      );
                                    }
                                  },
                                );
                              },
                              icon:
                                  Icon(
                                isFavorite
                                    ? Icons
                                        .star_rounded
                                    : Icons
                                        .star_border_rounded,
                                color:
                                    isFavorite
                                        ? const Color(
                                            0xFFE6AA28,
                                          )
                                        : Colors
                                            .grey,
                                size:
                                    30,
                              ),
                            ),
                          ],
                        ),

                        if (widget
                            .footnotes
                            .isNotEmpty) ...[
                          const SizedBox(
                            height: 16,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          ...widget
                              .footnotes
                              .map(
                            (
                              note,
                            ) =>
                                Padding(
                              padding:
                                  const EdgeInsets
                                      .only(
                                bottom: 6,
                              ),
                              child:
                                  Text(
                                note,
                                style:
                                    const TextStyle(
                                  fontSize:
                                      13,
                                  color:
                                      Colors
                                          .black54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
