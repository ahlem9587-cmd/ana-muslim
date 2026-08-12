import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quran_data.dart';

class QuranPage extends StatelessWidget {
  final String language;

  const QuranPage({
    super.key,
    required this.language,
  });

  String get title {
    switch (language) {
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

  @override
  Widget build(BuildContext context) {
    final bool isRtl =
        language == 'ar' || language == 'ur';

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
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor:
              const Color(0xFFF4EDE1),
          elevation: 0,
        ),
        body: FutureBuilder<
            List<List<QuranVerse>>>(
          future: _loadQuran(),
          builder: (
            context,
            snapshot,
          ) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child:
                    CircularProgressIndicator(
                  color:
                      Color(0xFF17604B),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding:
                      const EdgeInsets.all(20),
                  child: Text(
                    'حدث خطأ أثناء تحميل القرآن:\n${snapshot.error}',
                    textAlign:
                        TextAlign.center,
                  ),
                ),
              );
            }

            final quran =
                snapshot.data ?? [];

            return ListView.builder(
              padding:
                  const EdgeInsets.all(12),
              itemCount:
                  quranSurahs.length,
              itemBuilder:
                  (context, index) {
                final surah =
                    quranSurahs[index];

                final verses =
                    index < quran.length
                        ? quran[index]
                        : <QuranVerse>[];

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 10,
                  ),
                  color:
                      const Color(0xFFFFFAF2),
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                    side: const BorderSide(
                      color:
                          Color(0xFFE7DDCE),
                    ),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),

                    leading:
                        CircleAvatar(
                      backgroundColor:
                          const Color(
                        0xFF17604B,
                      ),
                      child: Text(
                        '${surah.number}',
                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    title: Text(
                      surah.nameAr,
                      style:
                          const TextStyle(
                        fontSize: 19,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Color(0xFF173D32),
                      ),
                    ),

                    subtitle: Padding(
                      padding:
                          const EdgeInsets.only(
                        top: 3,
                      ),
                      child: Text(
                        surah.nameEn,
                        style:
                            const TextStyle(
                          fontSize: 13,
                          color:
                              Colors.black54,
                        ),
                      ),
                    ),

                    trailing: Text(
                      '${surah.verses} آية',
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color:
                            Colors.black54,
                      ),
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  SurahPage(
                            surah: surah,
                            verses: verses,
                            language:
                                language,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<List<QuranVerse>>>
      _loadQuran() async {
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

    return result;
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
            //
            // تظهر مرة واحدة فقط في بداية السورة.
            //
            // التوبة لا تحتوي على بسملة.
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
                    fontSize: 18,
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
            // جميع الآيات متتابعة في نفس النص.
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
  // الآيات لا تنزل سطرًا جديدًا.
  // كل آية بعدها رقمها ثم تكمل الآية التالية.
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
            fontSize: 18,
            height: 1.9,
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
            fontSize: 14,
            height: 1.9,
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
