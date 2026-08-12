import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quran_data.dart';

class QuranPage extends StatefulWidget {
  final String language;

  const QuranPage({
    super.key,
    required this.language,
  });

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  bool isLoading = true;

  List<List<QuranVerse>> quran = [];

  String search = '';

  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    _loadQuran();
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

  String get title {
    switch (widget.language) {
      case 'en':
        return 'Holy Quran';
      case 'fr':
        return 'Coran';
      case 'tr':
        return 'Kur’an-ı Kerim';
      case 'ur':
        return 'قرآن مجید';
      default:
        return 'القرآن الكريم';
    }
  }

  bool get isRtl {
    return widget.language == 'ar' ||
        widget.language == 'ur';
  }

  // ============================================================
  // تحميل القرآن
  // ============================================================

  Future<void> _loadQuran() async {
    try {
      final String text =
          await rootBundle.loadString(
        'assets/quran-uthmani.txt',
      );

      final List<String> lines =
          text.split('\n');

      final List<List<QuranVerse>> result =
          List.generate(
        114,
        (_) => <QuranVerse>[],
      );

      for (final line in lines) {
        final String cleanLine =
            line.trim();

        if (cleanLine.isEmpty) {
          continue;
        }

        final List<String> parts =
            cleanLine.split('|');

        if (parts.length < 3) {
          continue;
        }

        final int? surahNumber =
            int.tryParse(
          parts[0].trim(),
        );

        final int? verseNumber =
            int.tryParse(
          parts[1].trim(),
        );

        final String verseText =
            parts
                .sublist(2)
                .join('|')
                .trim();

        if (surahNumber == null ||
            verseNumber == null ||
            surahNumber < 1 ||
            surahNumber > 114 ||
            verseNumber < 1 ||
            verseText.isEmpty) {
          continue;
        }

        result[surahNumber - 1].add(
          QuranVerse(
            number: verseNumber,
            text: verseText,
          ),
        );
      }

      if (!mounted) return;

      setState(() {
        quran = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء تحميل القرآن:\n$e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // البحث
  // ============================================================

  void _onSearchChanged(String value) {
    _searchTimer?.cancel();

    _searchTimer = Timer(
      const Duration(milliseconds: 180),
      () {
        if (!mounted) return;

        setState(() {
          search = value.trim();
        });
      },
    );
  }

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
        .toLowerCase()
        .trim();
  }

  bool _matchesSearch(
    QuranSurah surah,
    List<QuranVerse> verses,
  ) {
    if (search.isEmpty) {
      return true;
    }

    final String query =
        _normalizeArabic(search);

    final String surahName =
        _normalizeArabic(
      '${surah.nameAr} ${surah.nameEn}',
    );

    if (surahName.contains(query)) {
      return true;
    }

    for (final verse in verses) {
      if (_normalizeArabic(
        verse.text,
      ).contains(query)) {
        return true;
      }
    }

    return false;
  }

  // ============================================================
  // السور المطابقة
  // ============================================================

  List<int> get filteredSurahIndexes {
    final List<int> result = [];

    for (int i = 0;
        i < quranSurahs.length;
        i++) {
      final QuranSurah surah =
          quranSurahs[i];

      final List<QuranVerse> verses =
          i < quran.length
              ? quran[i]
              : <QuranVerse>[];

      if (_matchesSearch(
        surah,
        verses,
      )) {
        result.add(i);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final bool rtl = isRtl;

    return Directionality(
      textDirection:
          rtl
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Scaffold(
        backgroundColor:
            const Color(0xFFF4EDE1),
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor:
              const Color(0xFFF4EDE1),
          elevation: 0,
        ),
        body: isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(
                  color:
                      Color(0xFF17604B),
                ),
              )
            : _buildBody(),
      ),
    );
  }

  // ============================================================
  // الصفحة الرئيسية
  // ============================================================

  Widget _buildBody() {
    final List<int> indexes =
        filteredSurahIndexes;

    return Column(
      children: [
        // ========================================================
        // خانة البحث
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
                isRtl
                    ? TextDirection.rtl
                    : TextDirection.ltr,
            decoration:
                InputDecoration(
              hintText:
                  widget.language == 'en'
                      ? 'Search Quran...'
                      : widget.language == 'fr'
                          ? 'Rechercher dans le Coran...'
                          : widget.language == 'tr'
                              ? 'Kur’an’da ara...'
                              : widget.language == 'ur'
                                  ? 'قرآن میں تلاش کریں...'
                                  : 'ابحث في القرآن...',

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

              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),

        // ========================================================
        // عدد النتائج
        // ========================================================

        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 6,
          ),
          child: Align(
            alignment:
                isRtl
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            child: Text(
              '${indexes.length} ${widget.language == 'en' ? 'Surahs' : 'سورة'}',
              style:
                  const TextStyle(
                fontSize: 13,
                fontWeight:
                    FontWeight.w600,
                color:
                    Colors.black54,
              ),
            ),
          ),
        ),

        // ========================================================
        // السور
        // ========================================================

        Expanded(
          child: indexes.isEmpty
              ? Center(
                  child: Text(
                    widget.language == 'en'
                        ? 'No results found'
                        : widget.language == 'fr'
                            ? 'Aucun résultat'
                            : widget.language == 'tr'
                                ? 'Sonuç bulunamadı'
                                : widget.language == 'ur'
                                    ? 'کوئی نتیجہ نہیں ملا'
                                    : 'لم يتم العثور على نتائج',
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
                    12,
                  ),
                  itemCount:
                      indexes.length,
                  itemBuilder:
                      (
                    context,
                    listIndex,
                  ) {
                    final int index =
                        indexes[listIndex];

                    final QuranSurah surah =
                        quranSurahs[index];

                    final List<QuranVerse>
                        verses =
                        index < quran.length
                            ? quran[index]
                            : <QuranVerse>[];

                    return Card(
                      margin:
                          const EdgeInsets
                              .only(
                        bottom: 10,
                      ),
                      color:
                          const Color(
                        0xFFFFFAF2,
                      ),
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          18,
                        ),
                        side:
                            const BorderSide(
                          color:
                              Color(
                            0xFFE7DDCE,
                          ),
                        ),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        leading:
                            CircleAvatar(
                          backgroundColor:
                              const Color(
                            0xFF17604B,
                          ),
                          child:
                              Text(
                            '${surah.number}',
                            style:
                                const TextStyle(
                              color:
                                  Colors
                                      .white,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),

                        title:
                            Text(
                          surah.nameAr,
                          style:
                              const TextStyle(
                            fontSize: 19,
                            fontWeight:
                                FontWeight
                                    .bold,
                            color:
                                Color(
                              0xFF173D32,
                            ),
                          ),
                        ),

                        subtitle:
                            Padding(
                          padding:
                              const EdgeInsets
                                  .only(
                            top: 3,
                          ),
                          child:
                              Text(
                            surah.nameEn,
                            style:
                                const TextStyle(
                              fontSize: 13,
                              color:
                                  Colors
                                      .black54,
                            ),
                          ),
                        ),

                        trailing:
                            Text(
                          '${surah.verses} آية',
                          style:
                              const TextStyle(
                            fontSize: 12,
                            color:
                                Colors
                                    .black54,
                          ),
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (
                                context,
                              ) =>
                                      SurahPage(
                                surah:
                                    surah,
                                verses:
                                    verses,
                                language:
                                    widget
                                        .language,
                              ),
                            ),
                          );
                        },
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
// نموذج الآية
// ================================================================

class QuranVerse {
  final int number;
  final String text;

  const QuranVerse({
    required this.number,
    required this.text,
  });
}

// ================================================================
// صفحة السورة
// ================================================================

class SurahPage extends StatelessWidget {
  final QuranSurah surah;
  final List<QuranVerse> verses;
  final String language;

  const SurahPage({
    super.key,
    required this.surah,
    required this.verses,
    required this.language,
  });

  String get basmala {
    return 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Directionality(
      textDirection:
          TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            const Color(0xFFF4EDE1),
        appBar: AppBar(
          title: Text(
            surah.nameAr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor:
              const Color(0xFFF4EDE1),
          elevation: 0,
        ),
        body: ListView(
          padding:
              const EdgeInsets.fromLTRB(
            18,
            18,
            18,
            40,
          ),
          children: [
            // ==================================================
            // معلومات السورة
            // ==================================================

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 12,
              ),
              margin:
                  const EdgeInsets.only(
                bottom: 16,
              ),
              decoration:
                  BoxDecoration(
                color:
                    const Color(0xFFFFFAF2),
                borderRadius:
                    BorderRadius.circular(
                  18,
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
                children: [
                  Text(
                    surah.nameAr,
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      fontSize: 27,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Color(0xFF173D32),
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    surah.nameEn,
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      fontSize: 13,
                      color:
                          Colors.black54,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    '${surah.verses} آية',
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

            // ==================================================
            // البسملة
            // ==================================================

            if (surah.number != 9)
              Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 16,
                ),
                child: Text(
                  basmala,
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        Color(0xFF173D32),
                  ),
                ),
              ),

            // ==================================================
            // نص السورة
            //
            // الخط قريب من خط الأحاديث.
            // جميع الآيات متتابعة.
            // ==================================================

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              decoration:
                  BoxDecoration(
                color:
                    const Color(0xFFFFFAF2),
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
                border:
                    Border.all(
                  color:
                      const Color(
                    0xFFE7DDCE,
                  ),
                ),
              ),
              child: Text.rich(
                TextSpan(
                  children:
                      _buildVerseSpans(),
                ),
                textAlign:
                    TextAlign.justify,
                textDirection:
                    TextDirection.rtl,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // بناء الآيات
  //
  // الخط 16 قريب من خط الأحاديث.
  // الآيات لا تنزل كل آية في سطر.
  // ==============================================================

  List<InlineSpan> _buildVerseSpans() {
    final List<InlineSpan> spans =
        [];

    for (final verse in verses) {
      spans.add(
        TextSpan(
          text:
              '${verse.text} ',
          style:
              const TextStyle(
            fontSize: 16,
            height: 1.8,
            color:
                Color(0xFF172D27),
            fontWeight:
                FontWeight.w400,
          ),
        ),
      );

      spans.add(
        TextSpan(
          text:
              '﴿${verse.number}﴾ ',
          style:
              const TextStyle(
            fontSize: 13,
            height: 1.8,
            fontWeight:
                FontWeight.bold,
            color:
                Color(0xFF17604B),
          ),
        ),
      );
    }

    return spans;
  }
}
