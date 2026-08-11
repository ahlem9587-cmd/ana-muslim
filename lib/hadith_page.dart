import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        };
    }
  }

  // ============================================================
  // تحميل الأحاديث
  // ============================================================

  Future<void> _loadHadiths() async {
    try {
      final List<HadithItem> result = [];

      // ========================================================
      // صحيح البخاري
      // ========================================================

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
        debugPrint(
          'Bukhari loading error: $e',
        );
      }

      // ========================================================
      // صحيح مسلم
      // ========================================================

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
        debugPrint(
          'Muslim loading error: $e',
        );
      }

      // ========================================================
      // حذف التكرار
      // ========================================================

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

          // الحديث موجود في المصدرين
          if (old.source != hadith.source) {
            unique[key] = old.copyWith(
              source: 'both',
            );
          }
        }
      }

      final List<HadithItem> finalHadiths =
          unique.values.toList();

      if (!mounted) return;

      setState(() {
        hadiths = finalHadiths;
        isLoading = false;

        if (finalHadiths.isEmpty) {
          errorMessage = texts['error'];
        }
      });
    } catch (e) {
      debugPrint(
        'Hadith loading error: $e',
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // ============================================================
  // قراءة CSV بشكل غير متزامن
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

      // نتجنب أول سطر إذا كان عنوان الأعمدة
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

      // اختيار أطول عمود باعتباره نص الحديث
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

      // إعطاء Flutter فرصة لتحديث الواجهة
      // حتى لا تبدو الصفحة معلقة
      if (i % 300 == 0) {
        await Future<void>.delayed(
          Duration.zero,
        );
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
        // إذا كان هناك "" داخل النص
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
        result.add(
          buffer.toString(),
        );

        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    result.add(
      buffer.toString(),
    );

    return result;
  }

  // ============================================================
  // قراءة صحيح مسلم
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

      if (processedLines % 300 == 0) {
        await Future<void>.delayed(
          Duration.zero,
        );
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
  // تنظيف النص للمقارنة وإزالة التكرار
  // ============================================================

  String _normalizeArabic(
    String text,
  ) {
    return text
        // التشكيل
        .replaceAll(
          RegExp(r'[\u064B-\u065F\u0670]'),
          '',
        )

        // الهمزات
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا')

        // الياء والألف المقصورة
        .replaceAll('ى', 'ي')

        // التاء المربوطة
        .replaceAll('ة', 'ه')

        // التطويل
        .replaceAll('ـ', '')

        // حذف علامات الوقف والترقيم
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

  String _sourceName(
    String source,
  ) {
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
  // الواجهة
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
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
                  ),
      ),
    );
  }

  // ============================================================
  // شاشة التحميل
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
  // شاشة الخطأ
  // ============================================================

  Widget _buildError() {
    final Map<String, String> t = texts;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173D32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// قائمة الأحاديث
// ================================================================

class _HadithList extends StatefulWidget {
  final List<HadithItem> hadiths;
  final Map<String, String> texts;
  final bool isRtl;
  final String Function(String) sourceName;

  const _HadithList({
    required this.hadiths,
    required this.texts,
    required this.isRtl,
    required this.sourceName,
  });

  @override
  State<_HadithList> createState() =>
      _HadithListState();
}

class _HadithListState
    extends State<_HadithList> {
  String search = '';

  @override
  Widget build(
    BuildContext context,
  ) {
    final String query =
        search.trim().toLowerCase();

    final List<HadithItem> filtered =
        widget.hadiths.where((hadith) {
      if (query.isEmpty) {
        return true;
      }

      return hadith.text
          .toLowerCase()
          .contains(query);
    }).toList();

    return Column(
      children: [
        // ======================================================
        // خانة البحث
        // ======================================================

        Padding(
          padding:
              const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            8,
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                search = value;
              });
            },
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

        // ======================================================
        // عدد الأحاديث
        // ======================================================

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

        // ======================================================
        // القائمة
        // ======================================================

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

                    return Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 14,
                      ),
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
                            CrossAxisAlignment
                                .start,
                        children: [
                          // ================================
                          // نص الحديث
                          // ================================

                          Text(
                            hadith.text,
                            textAlign:
                                widget.isRtl
                                    ? TextAlign
                                        .right
                                    : TextAlign
                                        .left,
                            style:
                                const TextStyle(
                              fontSize: 18,
                              height: 1.8,
                              color:
                                  Color(
                                0xFF172D27,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          const Divider(),

                          const SizedBox(
                            height: 8,
                          ),

                          // ================================
                          // المصدر والرقم
                          // ================================

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
                                  widget
                                      .sourceName(
                                    hadith
                                        .source,
                                  ),
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    color:
                                        Color(
                                      0xFF17604B,
                                    ),
                                  ),
                                ),
                              ),

                              if (hadith
                                      .number !=
                                  null)
                                Text(
                                  '#${hadith.number}',
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors
                                            .black45,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
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

  const HadithItem({
    required this.text,
    required this.source,
    this.number,
  });

  HadithItem copyWith({
    String? text,
    String? source,
    String? number,
  }) {
    return HadithItem(
      text: text ?? this.text,
      source: source ?? this.source,
      number: number ?? this.number,
    );
  }
}
