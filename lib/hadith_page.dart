import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HadithPage extends StatefulWidget {
  final String language;

  const HadithPage({
    super.key,
    required this.language,
  });

  @override
  State<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {
  bool isLoading = true;
  String? errorMessage;

  List<HadithItem> hadiths = [];

  @override
  void initState() {
    super.initState();
    _loadHadiths();
  }

  bool get isRtl =>
      widget.language == 'ar' || widget.language == 'ur';

  Map<String, String> get texts {
    switch (widget.language) {
      case 'en':
        return {
          'title': 'Hadith',
          'bukhari': 'Sahih al-Bukhari',
          'muslim': 'Sahih Muslim',
          'both': 'Bukhari & Muslim',
          'search': 'Search hadith...',
          'loading': 'Loading hadiths...',
          'error': 'Could not load hadiths',
          'empty': 'No hadiths found',
          'count': 'Hadiths',
          'saved': 'Saved',
          'save': 'Save',
          'fullHadith': 'Full Hadith',
        };

      case 'fr':
        return {
          'title': 'Hadith',
          'bukhari': 'Sahih Al-Bukhari',
          'muslim': 'Sahih Muslim',
          'both': 'Al-Bukhari et Muslim',
          'search': 'Rechercher un hadith...',
          'loading': 'Chargement des hadiths...',
          'error': 'Impossible de charger les hadiths',
          'empty': 'Aucun hadith trouvé',
          'count': 'Hadiths',
          'saved': 'Enregistré',
          'save': 'Enregistrer',
          'fullHadith': 'Hadith complet',
        };

      case 'tr':
        return {
          'title': 'Hadis',
          'bukhari': 'Sahih Buhari',
          'muslim': 'Sahih Müslim',
          'both': 'Buhari ve Müslim',
          'search': 'Hadis ara...',
          'loading': 'Hadisler yükleniyor...',
          'error': 'Hadisler yüklenemedi',
          'empty': 'Hadis bulunamadı',
          'count': 'Hadis',
          'saved': 'Kaydedildi',
          'save': 'Kaydet',
          'fullHadith': 'Tam Hadis',
        };

      case 'ur':
        return {
          'title': 'احادیث',
          'bukhari': 'صحیح بخاری',
          'muslim': 'صحیح مسلم',
          'both': 'بخاری و مسلم',
          'search': 'حدیث تلاش کریں...',
          'loading': 'احادیث لوڈ ہو رہی ہیں...',
          'error': 'احادیث لوڈ نہیں ہو سکیں',
          'empty': 'کوئی حدیث نہیں ملی',
          'count': 'احادیث',
          'saved': 'محفوظ',
          'save': 'محفوظ کریں',
          'fullHadith': 'مکمل حدیث',
        };

      default:
        return {
          'title': 'الأحاديث',
          'bukhari': 'صحيح البخاري',
          'muslim': 'صحيح مسلم',
          'both': 'البخاري ومسلم',
          'search': 'ابحث في الأحاديث...',
          'loading': 'جاري تحميل الأحاديث...',
          'error': 'تعذر تحميل الأحاديث',
          'empty': 'لم يتم العثور على أحاديث',
          'count': 'حديث',
          'saved': 'محفوظ',
          'save': 'حفظ',
          'fullHadith': 'الحديث كاملًا',
        };
    }
  }

  // ============================================================
  // تحميل الأحاديث
  // ============================================================

  Future<void> _loadHadiths() async {
    try {
      final List<HadithItem> result = [];

      // ----------------------------------------------------------
      // البخاري
      // ----------------------------------------------------------

      try {
        final String bukhariText = await rootBundle.loadString(
          'assets/sahih_al-bukhari_ahadith.utf8.csv',
        );

        final List<HadithItem> bukhari =
            await _parseCsvAsync(
          bukhariText,
          'bukhari',
        );

        result.addAll(bukhari);
      } catch (e) {
        debugPrint('Bukhari loading error: $e');
      }

      // ----------------------------------------------------------
      // مسلم
      // ----------------------------------------------------------

      try {
        final String muslimText = await rootBundle.loadString(
          'assets/sahih_muslim_ahadith.utf8.txt',
        );

        final List<HadithItem> muslim =
            await _parseTextFileAsync(
          muslimText,
          'muslim',
        );

        result.addAll(muslim);
      } catch (e) {
        debugPrint('Muslim loading error: $e');
      }

      // ----------------------------------------------------------
      // حذف التكرار
      // ----------------------------------------------------------

      final Map<String, HadithItem> unique = {};

      for (final hadith in result) {
        final String key =
            _normalizeArabic(hadith.text);

        if (key.isEmpty) {
          continue;
        }

        if (!unique.containsKey(key)) {
          unique[key] = hadith;
        } else {
          final HadithItem old = unique[key]!;

          if (old.source != hadith.source) {
            unique[key] = old.copyWith(
              source: 'both',
            );
          }
        }
      }

      final List<HadithItem> finalHadiths =
          unique.values.toList();

      // ----------------------------------------------------------
      // تحميل المحفوظات
      // ----------------------------------------------------------

      final SharedPreferences prefs =
          await SharedPreferences.getInstance();

      final Set<String> saved =
          (prefs.getStringList('saved_hadiths') ?? [])
              .toSet();

      for (int i = 0; i < finalHadiths.length; i++) {
        final HadithItem item = finalHadiths[i];

        final String id = item.id;

        finalHadiths[i] = item.copyWith(
          isSaved: saved.contains(id),
        );
      }

      if (!mounted) return;

      setState(() {
        hadiths = finalHadiths;
        isLoading = false;

        if (finalHadiths.isEmpty) {
          errorMessage = texts['error'];
        }
      });
    } catch (e) {
      debugPrint('Hadith loading error: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // ============================================================
  // قراءة CSV
  // ============================================================

  Future<List<HadithItem>> _parseCsvAsync(
    String content,
    String source,
  ) async {
    final List<HadithItem> result = [];

    final List<String> lines =
        const LineSplitter().convert(content);

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i].trim();

      if (line.isEmpty) {
        continue;
      }

      if (i == 0 &&
          (line.toLowerCase().contains('text') ||
              line.toLowerCase().contains('hadith'))) {
        continue;
      }

      final List<String> columns =
          _splitCsvLine(line);

      if (columns.isEmpty) {
        continue;
      }

      String text = '';

      for (final String column in columns) {
        final String value = column.trim();

        if (value.length > text.length) {
          text = value;
        }
      }

      if (text.length < 15) {
        continue;
      }

      result.add(
        HadithItem(
          text: text,
          source: source,
          number: '${i + 1}',
        ),
      );

      if (i % 500 == 0) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    return result;
  }

  // ============================================================
  // تقسيم CSV
  // ============================================================

  List<String> _splitCsvLine(
    String line,
  ) {
    final List<String> result = [];

    final StringBuffer buffer =
        StringBuffer();

    bool insideQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final String char = line[i];

      if (char == '"') {
        if (insideQuotes &&
            i + 1 < line.length &&
            line[i + 1] == '"') {
          buffer.write('"');
          i++;
        } else {
          insideQuotes = !insideQuotes;
        }

        continue;
      }

      if (char == ',' && !insideQuotes) {
        result.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    result.add(buffer.toString());

    return result;
  }

  // ============================================================
  // قراءة مسلم
  // ============================================================

  Future<List<HadithItem>> _parseTextFileAsync(
    String content,
    String source,
  ) async {
    final List<HadithItem> result = [];

    final List<String> lines =
        const LineSplitter().convert(content);

    final StringBuffer current =
        StringBuffer();

    int number = 0;
    int processedLines = 0;

    for (final String rawLine in lines) {
      final String line = rawLine.trim();

      if (line.isEmpty) {
        if (current.toString().trim().length >= 15) {
          number++;

          result.add(
            HadithItem(
              text: current.toString().trim(),
              source: source,
              number: '$number',
            ),
          );
        }

        current.clear();
      } else {
        if (current.isNotEmpty) {
          current.write(' ');
        }

        current.write(line);
      }

      processedLines++;

      if (processedLines % 500 == 0) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    if (current.toString().trim().length >= 15) {
      number++;

      result.add(
        HadithItem(
          text: current.toString().trim(),
          source: source,
          number: '$number',
        ),
      );
    }

    return result;
  }

  // ============================================================
  // تنظيف النص
  // ============================================================

  String _normalizeArabic(String text) {
    return text
        .replaceAll(
          RegExp(r'[\u064B-\u065F\u0670]'),
          '',
        )
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll('ـ', '')
        .replaceAll(
          RegExp(
            r'[^\u0600-\u06FFa-zA-Z0-9]',
          ),
          '',
        )
        .toLowerCase()
        .trim();
  }

  // ============================================================
  // اسم المصدر
  // ============================================================

  String _sourceName(String source) {
    final Map<String, String> t = texts;

    if (source == 'bukhari') {
      return t['bukhari']!;
    }

    if (source == 'muslim') {
      return t['muslim']!;
    }

    return t['both']!;
  }

  // ============================================================
  // حفظ / إلغاء حفظ
  // ============================================================

  Future<void> _toggleSave(HadithItem hadith) async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    final List<String> saved =
        prefs.getStringList('saved_hadiths') ?? [];

    final Set<String> savedSet =
        saved.toSet();

    final bool newValue =
        !savedSet.contains(hadith.id);

    if (newValue) {
      savedSet.add(hadith.id);
    } else {
      savedSet.remove(hadith.id);
    }

    await prefs.setStringList(
      'saved_hadiths',
      savedSet.toList(),
    );

    if (!mounted) return;

    setState(() {
      final int index =
          hadiths.indexWhere(
        (item) => item.id == hadith.id,
      );

      if (index != -1) {
        hadiths[index] =
            hadiths[index].copyWith(
          isSaved: newValue,
        );
      }
    });
  }

  // ============================================================
  // فتح الحديث كامل
  // ============================================================

  void _openFullHadith(HadithItem hadith) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Directionality(
          textDirection:
              isRtl
                  ? TextDirection.rtl
                  : TextDirection.ltr,
          child: DraggableScrollableSheet(
            initialChildSize: 0.72,
            minChildSize: 0.45,
            maxChildSize: 0.94,
            expand: false,
            builder: (
              context,
              scrollController,
            ) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF4EDE1),
                  borderRadius:
                      BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(
                        20,
                        16,
                        12,
                        10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              texts['fullHadith']!,
                              style:
                                  const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    Color(0xFF173D32),
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              _toggleSave(hadith);
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              hadith.isSaved
                                  ? Icons.star_rounded
                                  : Icons
                                      .star_border_rounded,
                              color:
                                  const Color(
                                0xFFE6AA28,
                              ),
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        controller:
                            scrollController,
                        padding:
                            const EdgeInsets.fromLTRB(
                          20,
                          8,
                          20,
                          30,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(
                            20,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFFFFAF2,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              22,
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
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                hadith.text,
                                textAlign:
                                    isRtl
                                        ? TextAlign.right
                                        : TextAlign.left,
                                style:
                                    const TextStyle(
                                  fontSize: 18,
                                  height: 1.85,
                                  color:
                                      Color(
                                    0xFF172D27,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              const Divider(),

                              const SizedBox(
                                height: 10,
                              ),

                              Row(
                                children: [
                                  const Icon(
                                    Icons
                                        .menu_book_rounded,
                                    size: 18,
                                    color:
                                        Color(
                                      0xFF17604B,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 7,
                                  ),

                                  Expanded(
                                    child: Text(
                                      _sourceName(
                                        hadith.source,
                                      ),
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        color:
                                            Color(
                                          0xFF17604B,
                                        ),
                                      ),
                                    ),
                                  ),

                                  if (hadith.number !=
                                      null)
                                    Text(
                                      '#${hadith.number}',
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.black45,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ============================================================
  // الواجهة الرئيسية
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final Map<String, String> t = texts;

    return Directionality(
      textDirection:
          isRtl
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
        ),
        body: isLoading
            ? _buildLoading()
            : errorMessage != null &&
                    hadiths.isEmpty
                ? _buildError()
                : _HadithList(
                    hadiths: hadiths,
                    texts: t,
                    isRtl: isRtl,
                    sourceName: _sourceName,
                    onOpenHadith:
                        _openFullHadith,
                    onToggleSave:
                        _toggleSave,
                  ),
      ),
    );
  }

  // ============================================================
  // تحميل
  // ============================================================

  Widget _buildLoading() {
    final Map<String, String> t = texts;

    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF17604B),
          ),
          const SizedBox(height: 16),
          Text(
            t['loading']!,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF173D32),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // خطأ
  // ============================================================

  Widget _buildError() {
    final Map<String, String> t = texts;

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu_book_rounded,
              size: 60,
              color: Color(0xFF17604B),
            ),
            const SizedBox(height: 16),
            Text(
              t['error']!,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
                color:
                    Color(0xFF173D32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// قائمة الأحاديث + البحث
// ================================================================

class _HadithList extends StatefulWidget {
  final List<HadithItem> hadiths;
  final Map<String, String> texts;
  final bool isRtl;
  final String Function(String) sourceName;

  final void Function(HadithItem)
      onOpenHadith;

  final Future<void> Function(HadithItem)
      onToggleSave;

  const _HadithList({
    required this.hadiths,
    required this.texts,
    required this.isRtl,
    required this.sourceName,
    required this.onOpenHadith,
    required this.onToggleSave,
  });

  @override
  State<_HadithList> createState() =>
      _HadithListState();
}

class _HadithListState
    extends State<_HadithList> {
  String search = '';

  Timer? _searchTimer;

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

  // ============================================================
  // البحث بدون تعليق
  // ============================================================

  void _onSearchChanged(String value) {
    _searchTimer?.cancel();

    _searchTimer = Timer(
      const Duration(milliseconds: 180),
      () {
        if (!mounted) return;

        setState(() {
          search = value;
        });
      },
    );
  }

  // ============================================================
  // الواجهة
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final String query =
        search.trim().toLowerCase();

    final List<HadithItem> filtered;

    if (query.isEmpty) {
      filtered = widget.hadiths;
    } else {
      filtered =
          widget.hadiths.where((hadith) {
        return hadith.searchText
            .contains(query);
      }).toList();
    }

    return Column(
      children: [
        // ========================================================
        // البحث
        // ========================================================

        Padding(
          padding:
              const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            8,
          ),
          child: TextField(
            onChanged:
                _onSearchChanged,
            textDirection:
                widget.isRtl
                    ? TextDirection.rtl
                    : TextDirection.ltr,
            decoration:
                InputDecoration(
              hintText:
                  widget.texts['search'],

              prefixIcon:
                  const Icon(
                Icons.search_rounded,
                color:
                    Color(0xFF17604B),
              ),

              filled: true,

              fillColor:
                  const Color(0xFFFFFAF2),

              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
                borderSide:
                    BorderSide.none,
              ),
            ),
          ),
        ),

        // ========================================================
        // العدد
        // ========================================================

        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 6,
          ),
          child: Align(
            alignment:
                widget.isRtl
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            child: Text(
              '${filtered.length} ${widget.texts['count']}',
              style:
                  const TextStyle(
                color:
                    Colors.black54,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ),

        // ========================================================
        // القائمة
        // ========================================================

        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    widget.texts['empty']!,
                    style:
                        const TextStyle(
                      color:
                          Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  itemCount:
                      filtered.length,
                  itemBuilder:
                      (context, index) {
                    final HadithItem hadith =
                        filtered[index];

                    return _HadithCard(
                      hadith: hadith,
                      isRtl:
                          widget.isRtl,
                      sourceName:
                          widget.sourceName(
                        hadith.source,
                      ),
                      onTap: () {
                        widget
                            .onOpenHadith(
                          hadith,
                        );
                      },
                      onSave: () {
                        widget
                            .onToggleSave(
                          hadith,
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ================================================================
// بطاقة الحديث المختصرة
// ================================================================

class _HadithCard extends StatelessWidget {
  final HadithItem hadith;
  final bool isRtl;
  final String sourceName;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const _HadithCard({
    required this.hadith,
    required this.isRtl,
    required this.sourceName,
    required this.onTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFFFFAF2),
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border:
            Border.all(
          color:
              const Color(0xFFE7DDCE),
        ),
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.all(
            18,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ==================================================
              // العنوان العلوي
              // ==================================================

              Row(
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 18,
                    color:
                        Color(0xFF17604B),
                  ),

                  const SizedBox(
                    width: 7,
                  ),

                  Expanded(
                    child: Text(
                      sourceName,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Color(0xFF17604B),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: onSave,
                    padding:
                        EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    icon: Icon(
                      hadith.isSaved
                          ? Icons
                              .star_rounded
                          : Icons
                              .star_border_rounded,
                      color:
                          const Color(
                        0xFFE6AA28,
                      ),
                      size: 28,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              // ==================================================
              // جزء مختصر من الحديث
              // ==================================================

              Text(
                hadith.preview,
                maxLines: 4,
                overflow:
                    TextOverflow.ellipsis,
                textAlign:
                    isRtl
                        ? TextAlign.right
                        : TextAlign.left,
                style:
                    const TextStyle(
                  fontSize: 16,
                  height: 1.75,
                  color:
                      Color(0xFF172D27),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              // ==================================================
              // اقرأ المزيد
              // ==================================================

              Row(
                children: [
                  Expanded(
                    child: Text(
                      '#${hadith.number ?? ''}',
                      style:
                          const TextStyle(
                        color:
                            Colors.black38,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons
                        .arrow_forward_ios_rounded,
                    size: 14,
                    color:
                        Colors.black38,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// نموذج الحديث
// ================================================================

class HadithItem {
  final String text;
  final String source;
  final String? number;
  final bool isSaved;

  late final String id;

  late final String searchText;

  HadithItem({
    required this.text,
    required this.source,
    this.number,
    this.isSaved = false,
  }) {
    id = _createId(
      text,
      source,
      number,
    );

    searchText =
        '$text $source $number'
            .toLowerCase();
  }

  // ============================================================
  // النص المختصر
  // ============================================================

  String get preview {
    final String clean =
        text.replaceAll(
      RegExp(r'\s+'),
      ' ',
    ).trim();

    // ما نخلي البطاقة ضخمة
    if (clean.length <= 220) {
      return clean;
    }

    return '${clean.substring(0, 220).trim()}...';
  }

  // ============================================================
  // إنشاء معرف ثابت
  // ============================================================

  static String _createId(
    String text,
    String source,
    String? number,
  ) {
    final String raw =
        '$source|$number|$text';

    return base64Url
        .encode(
          utf8.encode(raw),
        )
        .replaceAll(
          '=',
          '',
        );
  }

  // ============================================================
  // نسخ
  // ============================================================

  HadithItem copyWith({
    String? text,
    String? source,
    String? number,
    bool? isSaved,
  }) {
    return HadithItem(
      text:
          text ?? this.text,
      source:
          source ?? this.source,
      number:
          number ?? this.number,
      isSaved:
          isSaved ?? this.isSaved,
    );
  }
}
