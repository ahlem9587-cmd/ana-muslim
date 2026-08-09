import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const AnaMuslimApp());
}

class AnaMuslimApp extends StatelessWidget {
  const AnaMuslimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'أنا مسلم | I’m Muslim',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const LanguagePage(),
    );
  }
}

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  static const languages = [
    ('العربية', 'ar'),
    ('English', 'en'),
    ('Français', 'fr'),
    ('Türkçe', 'tr'),
    ('اردو', 'ur'),
    ('Bahasa Indonesia', 'id'),
    ('Bahasa Melayu', 'ms'),
  ];

  void goHome(BuildContext context, String language) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(language: language),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
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
                  style: TextStyle(fontSize: 20),
                ),

                const SizedBox(height: 30),

                ...languages.map(
                  (language) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          goHome(context, language.$2);
                        },
                        child: Text(
                          language.$1,
                          style: const TextStyle(fontSize: 18),
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
    );
  }
}
