import 'package:flutter/material.dart';

class PrayerPage extends StatelessWidget {
  final String language;

  const PrayerPage({
    super.key,
    required this.language,
  });

  bool get isRtl =>
      language == 'ar' || language == 'ur';

  Map<String, String> get texts {
    switch (language) {
      case 'en':
        return {
          'title': 'Prayer',
          'times': 'Prayer Times',
          'wudu': 'Wudu',
          'fard': 'Obligatory Prayers',
          'sunnah': 'Sunnah Prayers',
          'how': 'How to Pray',
          'rules': 'Prayer Rules',
          'adhan': 'Adhan Settings',
          'location': 'Location',
          'soon': 'Will be available soon',
        };

      case 'fr':
        return {
          'title': 'Prière',
          'times': 'Heures de prière',
          'wudu': 'Ablutions',
          'fard': 'Prières obligatoires',
          'sunnah': 'Prières surérogatoires',
          'how': 'Comment prier',
          'rules': 'Règles de la prière',
          'adhan': 'Paramètres de l’adhan',
          'location': 'Localisation',
          'soon': 'Disponible prochainement',
        };

      case 'tr':
        return {
          'title': 'Namaz',
          'times': 'Namaz Vakitleri',
          'wudu': 'Abdest',
          'fard': 'Farz Namazlar',
          'sunnah': 'Sünnet Namazlar',
          'how': 'Namaz Nasıl Kılınır',
          'rules': 'Namaz Hükümleri',
          'adhan': 'Ezan Ayarları',
          'location': 'Konum',
          'soon': 'Yakında kullanılabilir',
        };

      case 'ur':
        return {
          'title': 'نماز',
          'times': 'نماز کے اوقات',
          'wudu': 'وضو',
          'fard': 'فرض نمازیں',
          'sunnah': 'سنت نمازیں',
          'how': 'نماز کا طریقہ',
          'rules': 'نماز کے احکام',
          'adhan': 'اذان کی ترتیبات',
          'location': 'مقام',
          'soon': 'جلد دستیاب ہوگا',
        };

      default:
        return {
          'title': 'الصلاة',
          'times': 'أوقات الصلاة',
          'wudu': 'الوضوء',
          'fard': 'الصلوات المفروضة',
          'sunnah': 'السنن',
          'how': 'كيفية الصلاة',
          'rules': 'أحكام الصلاة',
          'adhan': 'إعدادات الأذان',
          'location': 'الموقع',
          'soon': 'ستتوفر قريبًا',
        };
    }
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
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionCard(
              context,
              Icons.access_time_rounded,
              t['times']!,
              t['location']!,
              const Color(0xFF17604B),
            ),

            _sectionCard(
              context,
              Icons.water_drop_rounded,
              t['wudu']!,
              t['soon']!,
              const Color(0xFF287A9E),
            ),

            _sectionCard(
              context,
              Icons.mosque_rounded,
              t['fard']!,
              t['soon']!,
              const Color(0xFF17604B),
            ),

            _sectionCard(
              context,
              Icons.star_rounded,
              t['sunnah']!,
              t['soon']!,
              const Color(0xFFE6AA28),
            ),

            _sectionCard(
              context,
              Icons.menu_book_rounded,
              t['how']!,
              t['soon']!,
              const Color(0xFF17604B),
            ),

            _sectionCard(
              context,
              Icons.info_outline_rounded,
              t['rules']!,
              t['soon']!,
              const Color(0xFF17604B),
            ),

            _sectionCard(
              context,
              Icons.notifications_active_rounded,
              t['adhan']!,
              t['soon']!,
              const Color(0xFF17604B),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE7DDCE),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 27,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF173D32),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 17,
          color: Colors.black45,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                subtitle,
              ),
            ),
          );
        },
      ),
    );
  }
}
