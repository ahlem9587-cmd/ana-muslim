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
    final isRtl = language == 'ar' || language == 'ur';

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body: FutureBuilder<List<List<String>>>(
          future: _loadQuran(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'حدث خطأ أثناء تحميل القرآن:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final quran = snapshot.data ?? [];

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: quranSurahs.length,
              itemBuilder: (context, index) {
                final surah = quranSurahs[index];

                final verses =
                    index < quran.length ? quran[index] : <String>[];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      child: Text('${surah.number}'),
                    ),
                    title: Text(
                      surah.nameAr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      surah.nameEn,
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Text(
                      '${surah.verses} آية',
                      style: const TextStyle(fontSize: 13),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurahPage(
                            surah: surah,
                            verses: verses,
                            language: language,
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

  Future<List<List<String>>> _loadQuran() async {
    final text = await rootBundle.loadString(
      'assets/quran-uthmani.txt',
    );

    final lines = text.split('\n');

    final List<List<String>> result = List.generate(
      114,
      (_) => <String>[],
    );

    for (final line in lines) {
      final cleanLine = line.trim();

      if (cleanLine.isEmpty) {
        continue;
      }

      final parts = cleanLine.split('|');

      if (parts.length < 3) {
        continue;
      }

      final surahNumber = int.tryParse(parts[0].trim());
      final verseNumber = int.tryParse(parts[1].trim());
      final verseText = parts.sublist(2).join('|').trim();

      if (surahNumber == null ||
          verseNumber == null ||
          surahNumber < 1 ||
          surahNumber > 114 ||
          verseText.isEmpty) {
        continue;
      }

      result[surahNumber - 1].add(verseText);
    }

    return result;
  }
}

class SurahPage extends StatelessWidget {
  final QuranSurah surah;
  final List<String> verses;
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
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(surah.nameAr),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 40),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 12,
              ),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    surah.nameAr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    surah.nameEn,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${surah.verses} آية',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            if (surah.number != 9)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                child: Text(
                  basmala,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Text.rich(
                TextSpan(
                  children: List.generate(
                    verses.length,
                    (index) {
                      return TextSpan(
                        children: [
                          TextSpan(
                            text: verses[index],
                            style: const TextStyle(
                              fontSize: 24,
                              height: 2.1,
                            ),
                          ),
                          TextSpan(
                            text: ' ۝${index + 1} ',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
