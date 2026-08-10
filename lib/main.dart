import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

void main() {
  runApp(const AnaMuslimApp());
}

class AnaMuslimApp extends StatefulWidget {
  const AnaMuslimApp({super.key});

  @override
  State<AnaMuslimApp> createState() => _AnaMuslimAppState();
}

class _AnaMuslimAppState extends State<AnaMuslimApp> {
  String? savedLanguage;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      savedLanguage = prefs.getString('selected_language');
      loading = false;
    });
  }

  Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('selected_language', language);

    setState(() {
      savedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'أنا مسلم | I’m Muslim',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.green,
        ),
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'أنا مسلم | I’m Muslim',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: savedLanguage == null
          ? LanguagePage(
              onLanguageSelected: saveLanguage,
            )
          : HomePage(
              language: savedLanguage!,
            ),
    );
  }
}

class LanguagePage extends StatelessWidget {
  final Future<void> Function(String language) onLanguageSelected;

  const LanguagePage({
    super.key,
    required this.onLanguageSelected,
  });

  static const languages = [
    ('العربية', 'ar'),
    ('English', 'en'),
    ('Français', 'fr'),
    ('Türkçe', 'tr'),
    ('اردو', 'ur'),
    ('Bahasa Indonesia', 'id'),
    ('Bahasa Melayu', 'ms'),
  ];

  Future<void> selectLanguage(
    BuildContext context,
    String language,
  ) async {
    await onLanguageSelected(language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mosque,
                    size: 80,
                    color: Colors.green,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'أنا مسلم | I’m Muslim',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'اختر لغتك',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 30),

                  ...languages.map(
                    (language) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            selectLanguage(
                              context,
                              language.$2,
                            );
                          },
                          child: Text(
                            language.$1,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
