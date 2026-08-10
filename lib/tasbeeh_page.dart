import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbeehPage extends StatefulWidget {
  final String language;

  const TasbeehPage({
    super.key,
    required this.language,
  });

  @override
  State<TasbeehPage> createState() => _TasbeehPageState();
}

class _TasbeehPageState extends State<TasbeehPage> {
  int count = 0;

  Map<String, String> get texts {
    switch (widget.language) {
      case 'en':
        return {
          'title': 'Tasbeeh',
          'count': 'Count',
          'reset': 'Reset',
          'tap': 'Tap to count',
        };

      case 'fr':
        return {
          'title': 'Tasbih',
          'count': 'Compteur',
          'reset': 'Réinitialiser',
          'tap': 'Appuyez pour compter',
        };

      case 'tr':
        return {
          'title': 'Tesbih',
          'count': 'Sayaç',
          'reset': 'Sıfırla',
          'tap': 'Saymak için dokun',
        };

      case 'ur':
        return {
          'title': 'تسبیح',
          'count': 'گنتی',
          'reset': 'دوبارہ شروع',
          'tap': 'گننے کے لیے دبائیں',
        };

      default:
        return {
          'title': 'المسبحة',
          'count': 'العدد',
          'reset': 'إعادة التعيين',
          'tap': 'اضغط للتسبيح',
        };
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCount();
  }

  Future<void> _loadCount() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      count = prefs.getInt('tasbeeh_count') ?? 0;
    });
  }

  Future<void> _increment() async {
    setState(() {
      count++;
    });

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      'tasbeeh_count',
      count,
    );
  }

  Future<void> _reset() async {
    setState(() {
      count = 0;
    });

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      'tasbeeh_count',
      0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = texts;

    final isArabic =
        widget.language == 'ar' ||
        widget.language == 'ur';

    return Directionality(
      textDirection:
          isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t['title']!),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  t['count']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 35),

                GestureDetector(
                  onTap: _increment,
                  child: Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 15,
                          offset: Offset(0, 6),
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        t['tap']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(
                    Icons.refresh_rounded,
                  ),
                  label: Text(
                    t['reset']!,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
