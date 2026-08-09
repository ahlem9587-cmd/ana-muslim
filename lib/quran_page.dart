import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'quran_data.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  List<String> _verses = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuran();
  }

  Future<void> _loadQuran() async {
    try {
      final data = await rootBundle.loadString('assets/quran-uthmani.txt');

      final verses = data
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      if (!mounted) return;

      setState(() {
        _verses = verses;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'تعذر تحميل القرآن';
        _loading = false;
      });
    }
  }

  List<String> _getSurahVerses(int surahNumber) {
    return _verses.where((line) {
      final parts = line.split('|');

      if (parts.length < 3) return false;

      return int.tryParse(parts[0]) == surahNumber;
    }).toList();
  }

  void _openSurah(BuildContext context, int surahNumber, String surahName) {
    final verses = _getSurahVerses(surahNumber);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SurahPage(
          surahNumber: surahNumber,
          surahName: surahName,
          verses: verses,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('القرآن الكريم'),
        ),
        body: Center(
          child: Text(_error!),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surah = surahs[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${surah['number']}'),
              ),
              title: Text(
                '${surah['name']}',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${surah['englishName']} • ${surah['ayahs']} آية',
                textAlign: TextAlign.right,
              ),
              trailing: const Icon(Icons.menu_book),
              onTap: () {
                _openSurah(
                  context,
                  surah['number'] as int,
                  surah['name'] as String,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SurahPage extends StatelessWidget {
  final int surahNumber;
  final String surahName;
  final List<String> verses;

  const SurahPage({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.verses,
  });

  String _verseText(String line) {
    final parts = line.split('|');

    if (parts.length >= 3) {
      return parts[2];
    }

    return line;
  }

  String _verseNumber(String line) {
    final parts = line.split('|');

    if (parts.length >= 2) {
      return parts[1];
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          children: [
            Text(
              'سُورَةُ $surahName',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (surahNumber != 9)
              const Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  height: 2,
                ),
              ),

            const SizedBox(height: 24),

            if (verses.isEmpty)
              const Center(
                child: Text(
                  'لم يتم العثور على آيات هذه السورة.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            else
              Text.rich(
                TextSpan(
                  children: verses.map((line) {
                    final text = _verseText(line);
                    final number = _verseNumber(line);

                    return TextSpan(
                      children: [
                        TextSpan(
                          text: '$text ',
                          style: const TextStyle(
                            fontSize: 25,
                            height: 2.1,
                          ),
                        ),
                        TextSpan(
                          text: '﴿$number﴾ ',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                textAlign: TextAlign.justify,
              ),
          ],
        ),
      ),
    );
  }
}
