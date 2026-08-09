import 'package:flutter/material.dart';

void main() {
  runApp(const AnaMuslimApp());
}

class AnaMuslimApp extends StatelessWidget {
  const AnaMuslimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'أنا مسلم | I Am Muslim',
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
                const SizedBox(height: 18),
                const Text(
                  'أنا مسلم',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'I Am Muslim',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 35),
                const Text(
                  'اختر اللغة / Choose language',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 18),

                ...languages.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  HomePage(language: item.$2),
                            ),
                          );
                        },
                        child: Text(item.$1),
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

class HomePage extends StatefulWidget {
  final String language;

  const HomePage({
    super.key,
    required this.language,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  String get title =>
      widget.language == 'en' ? 'I Am Muslim' : 'أنا مسلم';

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeContent(language: widget.language),
      SearchPage(language: widget.language),
      const AiPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          setState(() {
            index = value;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: widget.language == 'en'
                ? 'Home'
                : 'الرئيسية',
          ),
          NavigationDestination(
            icon: const Icon(Icons.search),
            label: widget.language == 'en'
                ? 'Search'
                : 'بحث',
          ),
          NavigationDestination(
            icon: const Icon(Icons.smart_toy_outlined),
            selectedIcon: const Icon(Icons.smart_toy),
            label: widget.language == 'en'
                ? 'AI'
                : 'ذكاء',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String language;

  const HomeContent({
    super.key,
    required this.language,
  });

  bool get en => language == 'en';

  @override
  Widget build(BuildContext context) {
    final cards = [
      (
        en ? 'Quran' : 'القرآن الكريم',
        Icons.menu_book,
        const QuranPage(),
      ),
      (
        en ? 'Hadith' : 'الأحاديث',
        Icons.auto_stories,
        const HadithPage(),
      ),
      (
        en ? 'Sunnah' : 'السنة',
        Icons.star_outline,
        const SunnahPage(),
      ),
      (
        en ? 'Search' : 'البحث',
        Icons.search,
        null,
      ),
      (
        en ? 'Islamic AI Assistant' : 'المساعد الإسلامي',
        Icons.smart_toy,
        const AiPage(),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(
                  Icons.mosque,
                  size: 55,
                  color: Colors.green,
                ),
                const SizedBox(height: 10),
                Text(
                  en
                      ? 'Welcome to I Am Muslim'
                      : 'مرحبًا بك في أنا مسلم',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        ...cards.map(
          (card) => Card(
            child: ListTile(
              leading: Icon(
                card.$2,
                color: Colors.green,
                size: 30,
              ),
              title: Text(
                card.$1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                if (card.$3 != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => card.$3!,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleListPage(
      title: 'القرآن الكريم',
      items: [
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
      ],
    );
  }
}

class HadithPage extends StatelessWidget {
  const HadithPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleListPage(
      title: 'الأحاديث',
      items: [
        'إنما الأعمال بالنيات',
        'من كان يؤمن بالله واليوم الآخر فليقل خيرًا أو ليصمت',
        'لا يؤمن أحدكم حتى يحب لأخيه ما يحب لنفسه',
        'المسلم من سلم المسلمون من لسانه ويده',
      ],
    );
  }
}

class SunnahPage extends StatelessWidget {
  const SunnahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleListPage(
      title: 'السنة',
      items: [
        'أذكار الصباح',
        'أذكار المساء',
        'آداب الطعام',
        'آداب النوم',
        'السنن اليومية',
      ],
    );
  }
}

class SimpleListPage extends StatelessWidget {
  final String title;
  final List<String> items;

  const SimpleListPage({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: 8),
        itemBuilder: (_, i) => Card(
          child: ListTile(
            leading: const Icon(
              Icons.book,
              color: Colors.green,
            ),
            title: Text(items[i]),
          ),
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  final String language;

  const SearchPage({
    super.key,
    required this.language,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();

  final data = const [
    'الفاتحة',
    'البقرة',
    'آل عمران',
    'إنما الأعمال بالنيات',
    'أذكار الصباح',
    'أذكار المساء',
  ];

  @override
  Widget build(BuildContext context) {
    final query = controller.text.trim();

    final results = query.isEmpty
        ? data
        : data.where((x) => x.contains(query)).toList();

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: widget.language == 'en'
                  ? 'Search Quran, Hadith...'
                  : 'ابحث في القرآن والأحاديث...',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, i) => Card(
                child: ListTile(
                  title: Text(results[i]),
                  leading: const Icon(Icons.search),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AiPage extends StatelessWidget {
  const AiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعد الإسلامي'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.smart_toy,
              size: 70,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'المساعد الإسلامي',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'اسأل عن موضوع ديني، وسنضيف الذكاء الاصطناعي في الخطوة القادمة.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'اكتب سؤالك...',
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
