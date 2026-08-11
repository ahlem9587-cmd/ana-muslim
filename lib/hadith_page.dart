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
        };
    }
  }

  Future<void> _loadHadiths() async {
    try {
      final List<HadithItem> result = [];

      // =========================
      // صحيح البخاري
      // =========================

      try {
        final bukhariText = await rootBundle.loadString(
          'assets/sahih_al_bukhari_ahadith.utf8.csv',
        );

        result.addAll(
          _parseCsv(
            bukhariText,
            'bukhari',
          ),
        );
      } catch (_) {
        // نكمل حتى لو تعذر تحميل الملف
      }

      // =========================
      // صحيح مسلم
      // =========================

      try {
        final muslimText = await rootBundle.loadString(
          'assets/sahih_muslim_ahadith.utf8.txt',
        );

        result.addAll(
          _parseTextFile(
            muslimText,
            'muslim',
          ),
        );
      } catch (_) {
        // نكمل حتى لو تعذر تحميل الملف
      }

      // إزالة التكرار
      final unique = <String, HadithItem>{};

      for (final hadith in result) {
        final key = _normalizeArabic(hadith.text);

        if (key.isEmpty) continue;

        if (!unique.containsKey(key)) {
          unique[key] = hadith;
        } else {
          final old = unique[key]!;

          // إذا وجد الحديث في البخاري ومسلم
          if (old.source != hadith.source) {
            unique[key] = old.copyWith(
              source: 'both',
            );
          }
        }
      }

      if (!mounted) return;

      setState(() {
        hadiths = unique.values.toList();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // =========================
  // قراءة CSV
  // =========================

  List<HadithItem> _parseCsv(
    String content,
    String source,
  ) {
    final result = <HadithItem>[];

    final lines = const LineSplitter().convert(content);

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (line.isEmpty) continue;

      final columns = _splitCsvLine(line);

      if (columns.isEmpty) continue;

      String text = '';

      // نحاول اختيار أطول عمود لأنه غالبًا نص الحديث
      for (final column in columns) {
        final value = column.trim();

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
    }

    return result;
  }

  List<String> _splitCsvLine(String line) {
    final result = <String>[];
    final buffer = StringBuffer();

    bool insideQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        insideQuotes = !insideQuotes;
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

  // =========================
  // قراءة TXT
  // =========================

  List<HadithItem> _parseTextFile(
    String content,
    String source,
  ) {
    final result = <HadithItem>[];

    final lines = const LineSplitter().convert(content);

    StringBuffer current = StringBuffer();
    int number = 0;

    for (final rawLine in lines) {
      final line = rawLine.trim();

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

        current = StringBuffer();
        continue;
      }

      if (current.isNotEmpty) {
        current.write(' ');
      }

      current.write(line);
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

  // =========================
  // تنظيف النص لإزالة التكرار
  // =========================

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
        .replaceAll(RegExp(r'[^\u0600-\u06FFa-zA-Z0-9]'), '')
        .toLowerCase()
        .trim();
  }

  String _sourceName(String source) {
    final t = texts;

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
    final t = texts;

    return Directionality(
      textDirection:
          isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4EDE1),
        appBar: AppBar(
          title: Text(
            t['title']!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFF4EDE1),
          elevation: 0,
        ),
        body: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(t['loading']!),
                  ],
                ),
              )
            : errorMessage != null
                ? Center(
                    child: Text(
                      '${t['error']}\n$errorMessage',
                      textAlign: TextAlign.center,
                    ),
                  )
                : _HadithList(
                    hadiths: hadiths,
                    texts: t,
                    isRtl: isRtl,
                    sourceName: _sourceName,
                  ),
      ),
    );
  }
}

// ======================================================
// قائمة الأحاديث
// ======================================================

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
  State<_HadithList> createState() => _HadithListState();
}

class _HadithListState extends State<_HadithList> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.hadiths.where((hadith) {
      if (search.trim().isEmpty) return true;

      return hadith.text.toLowerCase().contains(
            search.toLowerCase(),
          );
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
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
            decoration: InputDecoration(
              hintText: widget.texts['search'],
              prefixIcon: const Icon(
                Icons.search_rounded,
              ),
              filled: true,
              fillColor: const Color(0xFFFFFAF2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 6,
          ),
          child: Align(
            alignment: widget.isRtl
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(
              '${filtered.length}',
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ),

        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    widget.texts['empty']!,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final hadith = filtered[index];

                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 14,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFAF2),
                        borderRadius:
                            BorderRadius.circular(22),
                        border: Border.all(
                          color: const Color(0xFFE7DDCE),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            hadith.text,
                            textAlign: widget.isRtl
                                ? TextAlign.right
                                : TextAlign.left,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.8,
                              color: Color(0xFF172D27),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.menu_book_rounded,
                                size: 18,
                                color: Color(0xFF17604B),
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: Text(
                                  widget.sourceName(
                                    hadith.source,
                                  ),
                                  style: const TextStyle(
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
                                  style: const TextStyle(
                                    color: Colors.black45,
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

// ======================================================
// نموذج الحديث
// ======================================================

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
