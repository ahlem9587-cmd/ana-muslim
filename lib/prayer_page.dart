import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';

class PrayerPage extends StatefulWidget {
  final String language;

  const PrayerPage({
    super.key,
    required this.language,
  });

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  bool isLoading = true;
  String? errorMessage;

  Position? position;
  PrayerTimes? prayerTimes;

  bool get isRtl =>
      widget.language == 'ar' || widget.language == 'ur';

  Map<String, String> get texts {
    switch (widget.language) {
      case 'en':
        return {
          'title': 'Prayer',
          'times': 'Prayer Times',
          'fajr': 'Fajr',
          'sunrise': 'Sunrise',
          'dhuhr': 'Dhuhr',
          'asr': 'Asr',
          'maghrib': 'Maghrib',
          'isha': 'Isha',
          'wudu': 'Wudu',
          'fard': 'Obligatory Prayers',
          'sunnah': 'Sunnah Prayers',
          'how': 'How to Pray',
          'rules': 'Prayer Rules',
          'adhan': 'Adhan Settings',
          'location': 'Location',
          'refresh': 'Update Location',
          'loading': 'Getting your location...',
          'locationOff': 'Location service is disabled.',
          'permissionDenied': 'Location permission was denied.',
          'permissionDeniedForever':
              'Location permission was permanently denied.',
          'error': 'Could not get prayer times.',
          'soon': 'Coming soon',
        };

      case 'fr':
        return {
          'title': 'Prière',
          'times': 'Heures de prière',
          'fajr': 'Fajr',
          'sunrise': 'Lever du soleil',
          'dhuhr': 'Dhuhr',
          'asr': 'Asr',
          'maghrib': 'Maghrib',
          'isha': 'Isha',
          'wudu': 'Ablutions',
          'fard': 'Prières obligatoires',
          'sunnah': 'Prières surérogatoires',
          'how': 'Comment prier',
          'rules': 'Règles de la prière',
          'adhan': 'Paramètres de l’adhan',
          'location': 'Localisation',
          'refresh': 'Mettre à jour',
          'loading': 'Obtention de votre position...',
          'locationOff': 'Le service de localisation est désactivé.',
          'permissionDenied':
              'La permission de localisation a été refusée.',
          'permissionDeniedForever':
              'La permission de localisation a été refusée définitivement.',
          'error': 'Impossible de calculer les heures de prière.',
          'soon': 'Bientôt disponible',
        };

      case 'tr':
        return {
          'title': 'Namaz',
          'times': 'Namaz Vakitleri',
          'fajr': 'Sabah',
          'sunrise': 'Güneş',
          'dhuhr': 'Öğle',
          'asr': 'İkindi',
          'maghrib': 'Akşam',
          'isha': 'Yatsı',
          'wudu': 'Abdest',
          'fard': 'Farz Namazlar',
          'sunnah': 'Sünnet Namazlar',
          'how': 'Namaz Nasıl Kılınır',
          'rules': 'Namaz Hükümleri',
          'adhan': 'Ezan Ayarları',
          'location': 'Konum',
          'refresh': 'Konumu Güncelle',
          'loading': 'Konumunuz alınıyor...',
          'locationOff': 'Konum hizmeti kapalı.',
          'permissionDenied': 'Konum izni reddedildi.',
          'permissionDeniedForever':
              'Konum izni kalıcı olarak reddedildi.',
          'error': 'Namaz vakitleri hesaplanamadı.',
          'soon': 'Yakında kullanılabilir',
        };

      case 'ur':
        return {
          'title': 'نماز',
          'times': 'نماز کے اوقات',
          'fajr': 'فجر',
          'sunrise': 'طلوع آفتاب',
          'dhuhr': 'ظہر',
          'asr': 'عصر',
          'maghrib': 'مغرب',
          'isha': 'عشاء',
          'wudu': 'وضو',
          'fard': 'فرض نمازیں',
          'sunnah': 'سنت نمازیں',
          'how': 'نماز کا طریقہ',
          'rules': 'نماز کے احکام',
          'adhan': 'اذان کی ترتیبات',
          'location': 'مقام',
          'refresh': 'مقام اپ ڈیٹ کریں',
          'loading': 'آپ کا مقام حاصل کیا جا رہا ہے...',
          'locationOff': 'مقام کی سروس بند ہے۔',
          'permissionDenied': 'مقام کی اجازت مسترد کر دی گئی۔',
          'permissionDeniedForever':
              'مقام کی اجازت مستقل طور پر مسترد کر دی گئی۔',
          'error': 'نماز کے اوقات حاصل نہیں ہو سکے۔',
          'soon': 'جلد دستیاب ہوگا',
        };

      default:
        return {
          'title': 'الصلاة',
          'times': 'أوقات الصلاة',
          'fajr': 'الفجر',
          'sunrise': 'الشروق',
          'dhuhr': 'الظهر',
          'asr': 'العصر',
          'maghrib': 'المغرب',
          'isha': 'العشاء',
          'wudu': 'الوضوء',
          'fard': 'الصلوات المفروضة',
          'sunnah': 'السنن',
          'how': 'كيفية الصلاة',
          'rules': 'أحكام الصلاة',
          'adhan': 'إعدادات الأذان',
          'location': 'الموقع',
          'refresh': 'تحديث الموقع',
          'loading': 'جاري تحديد موقعك...',
          'locationOff': 'خدمة الموقع متوقفة.',
          'permissionDenied': 'تم رفض إذن الموقع.',
          'permissionDeniedForever':
              'تم رفض إذن الموقع بشكل دائم.',
          'error': 'تعذر حساب أوقات الصلاة.',
          'soon': 'ستتوفر قريبًا',
        };
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception(texts['locationOff']);
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception(texts['permissionDenied']);
      }

      if (permission ==
          LocationPermission.deniedForever) {
        throw Exception(
          texts['permissionDeniedForever'],
        );
      }

      final currentPosition =
          await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      final coordinates = Coordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      final date = DateComponents.from(
        DateTime.now(),
      );

      final params =
          CalculationMethod.muslim_world_league.getParameters();

      params.madhab = Madhab.shafi;

      final calculatedTimes = PrayerTimes(
        coordinates,
        date,
        params,
      );

      if (!mounted) return;

      setState(() {
        position = currentPosition;
        prayerTimes = calculatedTimes;
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

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;

    final formattedHour =
        hour.toString().padLeft(2, '0');

    final formattedMinute =
        minute.toString().padLeft(2, '0');

    return '$formattedHour:$formattedMinute';
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
          actions: [
            IconButton(
              onPressed: _loadPrayerTimes,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              tooltip: t['refresh'],
            ),
          ],
        ),
        body: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(t['loading']!),
                  ],
                ),
              )
            : errorMessage != null
                ? _errorView()
                : _prayerContent(),
      ),
    );
  }

  Widget _errorView() {
    final t = texts;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off_rounded,
              size: 70,
              color: Color(0xFF17604B),
            ),
            const SizedBox(height: 20),
            Text(
              t['error']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage ?? '',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadPrayerTimes,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: Text(t['refresh']!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _prayerContent() {
    final t = texts;
    final times = prayerTimes!;

    return RefreshIndicator(
      onRefresh: _loadPrayerTimes,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _locationCard(),

          const SizedBox(height: 16),

          Text(
            t['times']!,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF173D32),
            ),
          ),

          const SizedBox(height: 12),

          _prayerCard(
            icon: Icons.nightlight_round,
            title: t['fajr']!,
            time: times.fajr,
            color: const Color(0xFF17604B),
          ),

          _prayerCard(
            icon: Icons.wb_twilight_rounded,
            title: t['sunrise']!,
            time: times.sunrise,
            color: const Color(0xFFE6AA28),
          ),

          _prayerCard(
            icon: Icons.wb_sunny_rounded,
            title: t['dhuhr']!,
            time: times.dhuhr,
            color: const Color(0xFFE69A28),
          ),

          _prayerCard(
            icon: Icons.sunny_snowing,
            title: t['asr']!,
            time: times.asr,
            color: const Color(0xFF287A9E),
          ),

          _prayerCard(
            icon: Icons.wb_twilight,
            title: t['maghrib']!,
            time: times.maghrib,
            color: const Color(0xFF8A5A9E),
          ),

          _prayerCard(
            icon: Icons.nights_stay_rounded,
            title: t['isha']!,
            time: times.isha,
            color: const Color(0xFF34495E),
          ),

          const SizedBox(height: 10),

          _sectionCard(
            Icons.water_drop_rounded,
            t['wudu']!,
            t['soon']!,
            const Color(0xFF287A9E),
          ),

          _sectionCard(
            Icons.mosque_rounded,
            t['fard']!,
            t['soon']!,
            const Color(0xFF17604B),
          ),

          _sectionCard(
            Icons.star_rounded,
            t['sunnah']!,
            t['soon']!,
            const Color(0xFFE6AA28),
          ),

          _sectionCard(
            Icons.menu_book_rounded,
            t['how']!,
            t['soon']!,
            const Color(0xFF17604B),
          ),

          _sectionCard(
            Icons.info_outline_rounded,
            t['rules']!,
            t['soon']!,
            const Color(0xFF17604B),
          ),

          _sectionCard(
            Icons.notifications_active_rounded,
            t['adhan']!,
            t['soon']!,
            const Color(0xFF17604B),
          ),
        ],
      ),
    );
  }

  Widget _locationCard() {
    final t = texts;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF17604B),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  t['location']!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${position!.latitude.toStringAsFixed(4)}, '
                  '${position!.longitude.toStringAsFixed(4)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _prayerCard({
    required IconData icon,
    required String title,
    required DateTime time,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE7DDCE),
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 7,
        ),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 25,
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
        trailing: Text(
          _formatTime(time),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _sectionCard(
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
        contentPadding:
            const EdgeInsets.symmetric(
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
        onTap: () {},
      ),
    );
  }
}
