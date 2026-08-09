import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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
  List<List<String>> surahs = [];
  bool loading = true;

  final List<String> surahNames = [
    'الفاتحة',
    'البقرة',
    'آل عمران',
    'النساء',
    'المائدة',
    'الأنعام',
    'الأعراف',
    'الأنفال',
    'التوبة',
    'يونس',
    'هود',
    'يوسف',
    'الرعد',
    'إبراهيم',
    'الحجر',
    'النحل',
    'الإسراء',
    'الكهف',
    'مريم',
    'طه',
    'الأنبياء',
    'الحج',
    'المؤمنون',
    'النور',
    'الفرقان',
    'الشعراء',
    'النمل',
    'القصص',
    'العنكبوت',
    'الروم',
    'لقمان',
    'السجدة',
    'الأحزاب',
    'سبأ',
    'فاطر',
    'يس',
    'الصافات',
    'ص',
    'الزمر',
    'غافر',
    'فصلت',
    'الشورى',
    'الزخرف',
    'الدخان',
    'الجاثية',
    'الأحقاف',
    'محمد',
    'الفتح',
    'الحجرات',
    'ق',
    'الذاريات',
    'الطور',
    'النجم',
    'القمر',
    'الرحمن',
    'الواقعة',
    'الحديد',
    'المجادلة',
    'الحشر',
    'الممتحنة',
    'الصف',
    'الجمعة',
    'المنافقون',
    'التغابن',
    'الطلاق',
    'التحريم',
    'الملك',
    'القلم',
    'الحاقة',
    'المعارج',
    'نوح',
    'الجن',
    'المزمل',
    'المدثر',
    'القيامة',
    'الإنسان',
    'المرسلات',
    'النبأ',
    'النازعات',
    'عبس',
    'التكوير',
    'الانفطار',
    'المطففين',
    'الانشقاق',
    'البروج',
    'الطارق',
    'الأعلى',
    'الغاشية',
    'الفجر',
    'البلد',
    'الشمس',
    'الليل',
    'الضحى',
    'الشرح',
    'التين',
    'العلق',
    'القدر',
    'البينة',
    'الزلزلة',
    'العاديات',
    'القارعة',
    'التكاثر',
    'العصر',
    'الهمزة',
    'الفيل',
    'قريش',
    'الماعون',
    'الكوثر',
    'الكافرون',
    'النصر',
    'المسد',
    'الإخلاص',
    'الفلق',
    'الناس',
  ];

  @override
  void initState() {
    super.initState();
    loadQuran();
  }

  Future<void> loadQuran() async {
    final content = await rootBundle.loadString(
      'assets/quran-uthmani.txt',
    );

    final lines = content
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    final grouped = List.generate(
      114,
      (_) => <String>[],
    );

    for (final line in lines) {
      final parts = line.split('|');

      if (parts.length >= 3) {
        final surahNumber = int.tryParse(parts[0]);

        if (surahNumber != null &&
            surahNumber >= 1 &&
            surahNumber <= 114) {
          grouped[surahNumber - 1].add(
            '${parts[1]}|${parts.sublist(2).join('|')}',
          );
        }
      }
    }

    setState(() {
      surahs = grouped;
      loading = false;
    });
  }

  Map<String, String> get texts {
    switch (widget.language) {
      case 'en':
        return {
          'title': 'Holy Quran',
          'surah': 'Surah',
          'verses': 'verses',
        };

      case 'fr':
        return {
          'title': 'Coran',
          'surah': 'Sourate',
          'verses': 'versets',
        };

      case 'tr':
        return {
          'title': 'Kur’an-ı Kerim',
          'surah': 'Sure',
          'verses': 'ayet',
        };

      case 'id':
        return {
          'title': 'Al-Qur’an',
          'surah': 'Surah',
          'verses': 'ayat',
        };

      case 'ur':
        return {
          'title': 'قرآن مجید',
          'surah': 'سورۃ',
          'verses': 'آیات',
        };

      case 'ms':
        return {
          'title': 'Al-Quran',
          'surah': 'Surah',
          'verses': 'ayat',
        };

      default:
        return {
          'title': 'القرآن الكريم',
          'surah': 'سورة',
          'verses': 'آية',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = texts;

    final isRtl =
        widget.language == 'ar' ||
        widget.language == 'ur';

    return Directionality(
      textDirection:
          isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t['title']!),
          centerTitle: true,
        ),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: 114,
                itemBuilder: (context, index) {
                  final verses = surahs[index];

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        child: Text(
                          '${index + 1}',
                        ),
                      ),
                      title: Text(
                        surahNames[index],
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${t['surah']} ${index + 1} • '
                        '${verses.length} ${t['verses']}',
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SurahPage(
                              number: index + 1,
                              name: surahNames[index],
                              verses: verses,
                              language: widget.language,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class SurahPage extends StatelessWidget {
  final int number;
  final String name;
  final List<String> verses;
  final String language;

  const SurahPage({
    super.key,
    required this.number,
    required this.name,
    required this.verses,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl =
        language == 'ar' ||
        language == 'ur';

    return Directionality(
      textDirection:
          isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '$name',
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 24,
          ),
          child: ListView(
            children: [
              Text(
                'سُورَةُ $name',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              if (number != 9)
                const Text(
                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    height: 2,
                  ),
                ),

              const SizedBox(height: 20),

              ...verses.map(
                (verse) {
                  final parts = verse.split('|');

                  final verseNumber =
                      parts.isNotEmpty
                          ? parts[0]
                          : '';

                  final text =
                      parts.length >= 2
                          ? parts.sublist(1).join('|')
                          : verse;

                  return Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 18,
                    ),
                    child: Text(
                      '$text ﴿$verseNumber﴾',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 25,
                        height: 2.1,
                        fontFamily: 'serif',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
