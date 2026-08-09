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
          'title': 'Recitation Majlis',
          'choose': 'Choose how you want to record',
          'video': 'Voice & Video',
          'videoSub': 'Record your recitation with camera and sound',
          'audio': 'Voice Only',
          'audioSub': 'Record your recitation without camera',
          'share': 'Share your recitation with others',
        };

      case 'fr':
        return {
          'title': 'Majlis de récitation',
          'choose': 'Choisissez comment enregistrer',
          'video': 'Audio et vidéo',
          'videoSub': 'Enregistrez avec la caméra et le son',
          'audio': 'Audio seulement',
          'audioSub': 'Enregistrez sans caméra',
          'share': 'Partagez votre récitation avec les autres',
        };

      case 'tr':
        return {
          'title': 'Tilavet Meclisi',
          'choose': 'Nasıl kayıt yapmak istediğinizi seçin',
          'video': 'Ses ve Görüntü',
          'videoSub': 'Kamera ve ses ile tilavet kaydedin',
          'audio': 'Sadece Ses',
          'audioSub': 'Kamerasız tilavet kaydedin',
          'share': 'Tilavetinizi başkalarıyla paylaşın',
        };

      case 'ur':
        return {
          'title': 'تلاوت کی مجلس',
          'choose': 'منتخب کریں کہ کیسے ریکارڈ کرنا ہے',
          'video': 'آواز اور ویڈیو',
          'videoSub': 'کیمرے اور آواز کے ساتھ تلاوت ریکارڈ کریں',
          'audio': 'صرف آواز',
          'audioSub': 'کیمرے کے بغیر تلاوت ریکارڈ کریں',
          'share': 'اپنی تلاوت دوسروں کے ساتھ شیئر کریں',
        };

      default:
        return {
          'title': 'مجلس التلاوة',
          'choose': 'اختر طريقة تسجيل تلاوتك',
          'video': 'صوت وصورة',
          'videoSub': 'سجّل تلاوتك بالكاميرا والصوت',
          'audio': 'صوت فقط',
          'audioSub': 'سجّل تلاوتك بدون كاميرا',
          'share': 'شارك تلاوتك مع الآخرين',
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
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              const Icon(
                Icons.menu_book,
                size: 70,
              ),

              const SizedBox(height: 20),

              Text(
                t['choose']!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // صوت وصورة
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(
                    Icons.videocam,
                    size: 40,
                  ),
                  title: Text(
                    t['video']!,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    t['videoSub']!,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${t['video']} - ${t['share']}',
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

              // صوت فقط
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(
                    Icons.mic,
                    size: 40,
                  ),
                  title: Text(
                    t['audio']!,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    t['audioSub']!,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${t['audio']} - ${t['share']}',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
