import 'package:flutter/material.dart';

class RecitationsPage extends StatelessWidget {
  final String language;

  const RecitationsPage({
    super.key,
    required this.language,
  });

  Map<String, String> get texts {
    switch (language) {
      case 'en':
        return {
          'title': 'Recitations',
          'record': 'Record your recitation',
          'choose': 'Choose a Surah',
          'easy': 'Easy verses',
          'listen': 'Listen to recitations',
          'noRecitations': 'No recitations yet',
        };

      case 'fr':
        return {
          'title': 'Récitations',
          'record': 'Enregistrer votre récitation',
          'choose': 'Choisir une sourate',
          'easy': 'Versets faciles',
          'listen': 'Écouter les récitations',
          'noRecitations': 'Aucune récitation pour le moment',
        };

      case 'tr':
        return {
          'title': 'Tilavetler',
          'record': 'Tilavetini kaydet',
          'choose': 'Sure seç',
          'easy': 'Kolay ayetler',
          'listen': 'Tilavetleri dinle',
          'noRecitations': 'Henüz tilavet yok',
        };

      default:
        return {
          'title': 'مجلس التلاوة',
          'record': 'سجّل تلاوتك',
          'choose': 'اختر سورة',
          'easy': 'آيات سهلة',
          'listen': 'استمع إلى التلاوات',
          'noRecitations': 'لا توجد تلاوات بعد',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = texts;
    final isArabic = language == 'ar' || language == 'ur';

    return Directionality(
      textDirection:
          isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t['title']!),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer,
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.menu_book,
                    size: 60,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    t['record']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.videocam),
                    label: Text(t['record']!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.menu_book),
              title: Text(t['choose']!),
              trailing:
                  const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: Text(t['easy']!),
              trailing:
                  const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),

            const SizedBox(height: 15),

            Text(
              t['listen']!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(t['noRecitations']!),
                subtitle: const Text('🎧'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
