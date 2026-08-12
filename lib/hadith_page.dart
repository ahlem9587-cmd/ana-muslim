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
          'fullHadith': 'Full Hadith',
          'save': 'Save',
          'saved': 'Saved',
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
          'fullHadith': 'Hadith complet',
          'save': 'Enregistrer',
          'saved': 'Enregistré',
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
          'fullHadith': 'Tam Hadis',
          'save': 'Kaydet',
          'saved': 'Kaydedildi',
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
          'fullHadith': 'مکمل حدیث',
          'save': 'محفوظ کریں',
          'saved': 'محفوظ',
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
          'fullHadith': 'الحديث كاملًا',
          'save': 'حفظ',
          'saved': 'محفوظ',
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

      for (final HadithItem hadith in result) {
        final String key = _normalizeArabic(hadith.text);

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

      if (line.isEmpty) continue;

      if (i == 0 &&
          (line.toLowerCase().contains('text') ||
              line.toLowerCase().contains('hadith'))) {
        continue;
      }

      final List<String> columns = _splitCsvLine(line);

      if (columns.isEmpty) continue;

      String text = '';

      for (final String column in columns) {
        final String value = column.trim();

        if (value.length > text.length) {
          text = value;
        }
      }

      if (text.length < 15) continue;

      result.add(
        HadithItem(
          text: text,
          source: source,
          number: '${i + 1}',
        ),
      );

      if (i % 300 == 0) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    return result;
  }

  // ============================================================
  // تقسيم CSV
  // ============================================================

  List<String> _splitCsvLine(String line) {
    final List<String> result = [];

    final StringBuffer buffer = StringBuffer();

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

    final StringBuffer current = StringBuffer();

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
  // تنظيف البحث
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
          RegExp(r'[^\u0600-\u06FFa-zA-Z0-9\s]'),
          '',
        )
        .toLowerCase()
        .trim();
  }

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
              fontSize: 20,
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
                    normalize: _normalizeArabic,
                  ),
      ),
    );
  }

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
              fontSize: 15,
              color: Color(0xFF173D32),
            ),
          ),
        ],
      ),
    );
  }

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
  final String Function(String) normalize;

  const _HadithList({
    required this.hadiths,
    required this.texts,
    required this.isRtl,
    required this.sourceName,
    required this.normalize,
  });

  @override
  State<_HadithList> createState() =>
      _HadithListState();
}

class _HadithListState
    extends State<_HadithList> {
  String search = '';

  Timer? _searchTimer;

  List<HadithItem>? _filteredCache;

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
      const Duration(milliseconds: 250),
      () {
        if (!mounted) return;

        setState(() {
          search = value;
          _filteredCache = null;
        });
      },
    );
  }

  List<HadithItem> _getFilteredHadiths() {
    if (_filteredCache != null) {
      return _filteredCache!;
    }

    final String query =
        widget.normalize(search);

    if (query.isEmpty) {
      _filteredCache =
          widget.hadiths;
      return _filteredCache!;
    }

    final List<HadithItem> results = [];

    for (final HadithItem hadith
        in widget.hadiths) {
      final String normalized =
          widget.normalize(
        hadith.text,
      );

      if (normalized.contains(query)) {
        results.add(hadith);
      }
    }

    _filteredCache = results;

    return results;
  }

  // ============================================================
  // اختصار الحديث
  // ============================================================

  String _shortHadith(String text) {
    final String clean = text.trim();

    if (clean.length <= 180) {
      return clean;
    }

    return '${clean.substring(0, 180).trim()}...';
  }

  // ============================================================
  // فتح الحديث كامل
  // ============================================================

  void _openFullHadith(HadithItem hadith) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HadithDetailsPage(
          hadith: hadith,
          texts: widget.texts,
          isRtl: widget.isRtl,
          sourceName: widget.sourceName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<HadithItem> filtered =
        _getFilteredHadiths();

    return Column(
      children: [
        // ======================================================
        // البحث
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
            onChanged: _onSearchChanged,
            textDirection:
                widget.isRtl
                    ? TextDirection.rtl
                    : TextDirection.ltr,
            textInputAction:
                TextInputAction.search,
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
              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
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
            ),
          ),
        ),

        // ======================================================
        // العدد
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
                fontSize: 13,
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
                      fontSize: 15,
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
                      filtered.length,
                  itemBuilder:
                      (context, index) {
                    final HadithItem hadith =
                        filtered[index];

                    return _buildHadithCard(
                      hadith,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHadithCard(
    HadithItem hadith,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),
      decoration: BoxDecoration(
        color:
            const Color(0xFFFFFAF2),
        borderRadius:
            BorderRadius.circular(22),
        border:
            Border.all(
          color:
              const Color(0xFFE7DDCE),
        ),
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(22),
        onTap: () {
          _openFullHadith(hadith);
        },
        child: Padding(
          padding:
              const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ==================================================
              // المصدر + رقم الحديث
              // ==================================================

              Row(
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 18,
                    color:
                        Color(0xFF17604B),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      widget.sourceName(
                        hadith.source,
                      ),
                      style:
                          const TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Color(0xFF17604B),
                      ),
                    ),
                  ),
                  if (hadith.number != null)
                    Text(
                      '#${hadith.number}',
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color:
                            Colors.black45,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 13),

              // ==================================================
              // المقطع المختصر
              // ==================================================

              Text(
                _shortHadith(
                  hadith.text,
                ),
                maxLines: 5,
                overflow:
                    TextOverflow.ellipsis,
                textAlign:
                    widget.isRtl
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

              const SizedBox(height: 14),

              // ==================================================
              // اضغط للقراءة
              // ==================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.texts['fullHadith']!,
                    style:
                        const TextStyle(
                      fontSize: 13,
                      fontWeight:
                          FontWeight.w700,
                      color:
                          Color(0xFF17604B),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color:
                        Color(0xFF17604B),
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
// صفحة الحديث الكامل
// ================================================================

class HadithDetailsPage extends StatefulWidget {
  final HadithItem hadith;
  final Map<String, String> texts;
  final bool isRtl;
  final String Function(String) sourceName;

  const HadithDetailsPage({
    super.key,
    required this.hadith,
    required this.texts,
    required this.isRtl,
    required this.sourceName,
  });

  @override
  State<HadithDetailsPage> createState() =>
      _HadithDetailsPageState();
}

class _HadithDetailsPageState
    extends State<HadithDetailsPage> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  String get saveKey {
    final String source =
        widget.hadith.source;

    final String number =
        widget.hadith.number ?? '';

    return 'saved_hadith_${source}_$number';
  }

  Future<void> _loadSavedState() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    final bool saved =
        prefs.getBool(saveKey) ?? false;

    if (!mounted) return;

    setState(() {
      isSaved = saved;
    });
  }

  Future<void> _toggleSaved() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    final bool newValue = !isSaved;

    await prefs.setBool(
      saveKey,
      newValue,
    );

    if (!mounted) return;

    setState(() {
      isSaved = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          widget.isRtl
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Scaffold(
        backgroundColor:
            const Color(0xFFF4EDE1),
        appBar: AppBar(
          title: Text(
            widget.texts['fullHadith']!,
            style:
                const TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 19,
            ),
          ),
          centerTitle: true,
          backgroundColor:
              const Color(0xFFF4EDE1),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: _toggleSaved,
              tooltip:
                  isSaved
                      ? widget.texts['saved']
                      : widget.texts['save'],
              icon: Icon(
                isSaved
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color:
                    isSaved
                        ? const Color(
                            0xFFE6AA28,
                          )
                        : const Color(
                            0xFF17604B,
                          ),
                size: 29,
              ),
            ),
          ],
        ),
        body: ListView(
          padding:
              const EdgeInsets.all(16),
          children: [
            Container(
              padding:
                  const EdgeInsets.all(20),
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
                      const Color(
                    0xFFE7DDCE,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // المصدر
                  // ==================================================

                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        color:
                            Color(0xFF17604B),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          widget.sourceName(
                            widget.hadith.source,
                          ),
                          style:
                              const TextStyle(
                            fontSize: 15,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Color(
                              0xFF17604B,
                            ),
                          ),
                        ),
                      ),
                      if (widget.hadith.number != null)
                        Text(
                          '#${widget.hadith.number}',
                          style:
                              const TextStyle(
                            fontSize: 12,
                            color:
                                Colors.black45,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  const Divider(),

                  const SizedBox(
                    height: 18,
                  ),

                  // ==================================================
                  // الحديث كامل
                  // ==================================================

                  Text(
                    widget.hadith.text,
                    textAlign:
                        widget.isRtl
                            ? TextAlign.right
                            : TextAlign.left,
                    style:
                        const TextStyle(
                      fontSize: 17,
                      height: 1.9,
                      color:
                          Color(0xFF172D27),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // ==================================================
                  // زر الحفظ
                  // ==================================================

                  SizedBox(
                    width: double.infinity,
                    child:
                        ElevatedButton.icon(
                      onPressed:
                          _toggleSaved,
                      icon: Icon(
                        isSaved
                            ? Icons
                                .star_rounded
                            : Icons
                                .star_border_rounded,
                      ),
                      label: Text(
                        isSaved
                            ? widget
                                .texts[
                                    'saved']!
                            : widget
                                .texts[
                                    'save']!,
                      ),
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                          0xFF17604B,
                        ),
                        foregroundColor:
                            Colors.white,
                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 13,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
