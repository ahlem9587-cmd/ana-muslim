import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  bool isLoading = true;
  bool notificationsEnabled = false;

  String? errorMessage;
  String locationText = '';

  List<PrayerItem> prayerTimes = [];

  bool get isRtl =>
      widget.language == 'ar' ||
      widget.language == 'ur';

  Map<String, String> get texts {
    switch (widget.language) {
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
          'loading': 'Calculating prayer times...',
          'locationRequired': 'Location permission is required',
          'locationDisabled': 'Please enable location services',
          'notificationDenied': 'Notification permission was not granted',
          'scheduled': 'Prayer notifications have been scheduled',
          'fajr': 'Fajr',
          'dhuhr': 'Dhuhr',
          'asr': 'Asr',
          'maghrib': 'Maghrib',
          'isha': 'Isha',
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
          'loading': 'Calcul des heures de prière...',
          'locationRequired':
              'La permission de localisation est requise',
          'locationDisabled':
              'Veuillez activer les services de localisation',
          'notificationDenied':
              'La permission de notification n’a pas été accordée',
          'scheduled':
              'Les notifications de prière ont été programmées',
          'fajr': 'Fajr',
          'dhuhr': 'Dhuhr',
          'asr': 'Asr',
          'maghrib': 'Maghrib',
          'isha': 'Isha',
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
          'loading': 'Namaz vakitleri hesaplanıyor...',
          'locationRequired': 'Konum izni gerekli',
          'locationDisabled': 'Lütfen konum hizmetlerini açın',
          'notificationDenied':
              'Bildirim izni verilmedi',
          'scheduled':
              'Namaz bildirimleri planlandı',
          'fajr': 'Sabah',
          'dhuhr': 'Öğle',
          'asr': 'İkindi',
          'maghrib': 'Akşam',
          'isha': 'Yatsı',
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
          'loading': 'نماز کے اوقات معلوم کیے جا رہے ہیں...',
          'locationRequired':
              'مقام کی اجازت ضروری ہے',
          'locationDisabled':
              'براہ کرم مقام کی سروس آن کریں',
          'notificationDenied':
              'نوٹیفکیشن کی اجازت نہیں دی گئی',
          'scheduled':
              'نماز کی اطلاعات مقرر کر دی گئی ہیں',
          'fajr': 'فجر',
          'dhuhr': 'ظہر',
          'asr': 'عصر',
          'maghrib': 'مغرب',
          'isha': 'عشاء',
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
          'loading': 'جاري حساب أوقات الصلاة...',
          'locationRequired': 'يجب السماح بالوصول إلى الموقع',
          'locationDisabled': 'يرجى تشغيل خدمة الموقع',
          'notificationDenied': 'لم يتم السماح بالإشعارات',
          'scheduled': 'تم جدولة إشعارات الصلاة',
          'fajr': 'الفجر',
          'dhuhr': 'الظهر',
          'asr': 'العصر',
          'maghrib': 'المغرب',
          'isha': 'العشاء',
          'soon': 'ستتوفر قريبًا',
        };
    }
  }

  @override
  void initState() {
    super.initState();
    _startPrayerSystem();
  }

  Future<void> _startPrayerSystem() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      await _initializeNotifications();

      final position = await _getLocation();

      await _calculatePrayerTimes(position);

      await _schedulePrayerNotifications(position);

      if (!mounted) return;

      setState(() {
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

  // ======================================================
  // الإشعارات
  // ======================================================

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();

    final timezoneInfo =
        await FlutterTimezone.getLocalTimezone();

    final location =
        tz.getLocation(timezoneInfo.name);

    tz.setLocalLocation(location);

    const androidSettings =
        AndroidInitializationSettings('ic_launcher');

    const initializationSettings =
        InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(
      initializationSettings,
    );

    final android =
        notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (android != null) {
      final permission =
          await android.requestNotificationsPermission();

      await android.requestExactAlarmsPermission();

      notificationsEnabled = permission ?? false;
    }

    const channel = AndroidNotificationChannel(
      'prayer_times',
      'Prayer Times',
      description:
          'Notifications for the five daily prayers',
      importance: Importance.max,
      playSound: true,
    );

    await notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // ======================================================
  // الحصول على الموقع
  // ======================================================

  Future<Position> _getLocation() async {
    final serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception(
        texts['locationDisabled'],
      );
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      throw Exception(
        texts['locationRequired'],
      );
    }

    final position =
        await Geolocator.getCurrentPosition(
      locationSettings:
          const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );

    locationText =
        '${position.latitude.toStringAsFixed(4)}, '
        '${position.longitude.toStringAsFixed(4)}';

    return position;
  }

  // ======================================================
  // حساب أوقات الصلاة
  // ======================================================

  Future<void> _calculatePrayerTimes(
    Position position,
  ) async {
    final coordinates = Coordinates(
      position.latitude,
      position.longitude,
    );

    final params =
        CalculationMethod.muslim_world_league.getParameters();

    params.madhab = Madhab.shafi;

    final now = DateTime.now();

    final date = DateComponents(
      now.year,
      now.month,
      now.day,
    );

    final times = PrayerTimes(
      coordinates,
      date,
      params,
    );

    final result = <PrayerItem>[
      PrayerItem(
        name: texts['fajr']!,
        time: times.fajr,
        icon: Icons.wb_twilight_rounded,
      ),
      PrayerItem(
        name: texts['dhuhr']!,
        time: times.dhuhr,
        icon: Icons.wb_sunny_rounded,
      ),
      PrayerItem(
        name: texts['asr']!,
        time: times.asr,
        icon: Icons.sunny_snowing,
      ),
      PrayerItem(
        name: texts['maghrib']!,
        time: times.maghrib,
        icon: Icons.wb_twilight_rounded,
      ),
      PrayerItem(
        name: texts['isha']!,
        time: times.isha,
        icon: Icons.nights_stay_rounded,
      ),
    ];

    if (!mounted) return;

    setState(() {
      prayerTimes = result;
    });
  }

  // ======================================================
  // جدولة إشعارات الصلاة
  // ======================================================

  Future<void> _schedulePrayerNotifications(
    Position position,
  ) async {
    if (!notificationsEnabled) {
      return;
    }

    await notifications.cancelAll();

    final coordinates = Coordinates(
      position.latitude,
      position.longitude,
    );

    final params =
        CalculationMethod.muslim_world_league.getParameters();

    params.madhab = Madhab.shafi;

    final location = tz.local;

    int notificationId = 100;

    for (int day = 0; day < 7; day++) {
      final date = DateTime.now().add(
        Duration(days: day),
      );

      final dateOnly = DateComponents(
        date.year,
        date.month,
        date.day,
      );

      final times = PrayerTimes(
        coordinates,
        dateOnly,
        params,
      );

      final prayers = <_PrayerNotification>[
        _PrayerNotification(
          name: texts['fajr']!,
          time: times.fajr,
        ),
        _PrayerNotification(
          name: texts['dhuhr']!,
          time: times.dhuhr,
        ),
        _PrayerNotification(
          name: texts['asr']!,
          time: times.asr,
        ),
        _PrayerNotification(
          name: texts['maghrib']!,
          time: times.maghrib,
        ),
        _PrayerNotification(
          name: texts['isha']!,
          time: times.isha,
        ),
      ];

      for (final prayer in prayers) {
        final localPrayerTime =
            tz.TZDateTime.from(
          prayer.time,
          location,
        );

        final scheduledTime = tz.TZDateTime(
          location,
          date.year,
          date.month,
          date.day,
          localPrayerTime.hour,
          localPrayerTime.minute,
        );

        if (scheduledTime.isBefore(
          tz.TZDateTime.now(location),
        )) {
          continue;
        }

        await notifications.zonedSchedule(
          notificationId++,
          title: prayer.name,
          body: '${prayer.name} - ${texts['times']}',
          scheduledDate: scheduledTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'prayer_times',
              'Prayer Times',
              channelDescription:
                  'Notifications for prayer times',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
            ),
          ),
          androidScheduleMode:
              AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    }
  }

  // ======================================================
  // تنسيق الوقت
  // ======================================================

  String _formatTime(DateTime time) {
    int hour = time.hour;
    final minute =
        time.minute.toString().padLeft(2, '0');

    final period =
        hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;

    if (hour == 0) {
      hour = 12;
    }

    return '$hour:$minute $period';
  }

  // ======================================================
  // الصفحة
  // ======================================================

  @override
  Widget build(BuildContext context) {
    final t = texts;

    return Directionality(
      textDirection:
          isRtl
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Scaffold(
        backgroundColor:
            const Color(0xFFF4EDE1),
        appBar: AppBar(
          title: Text(
            t['title']!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor:
              const Color(0xFFF4EDE1),
          elevation: 0,
        ),
        body: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Color(0xFF17604B),
                    ),
                    const SizedBox(height: 16),
                    Text(t['loading']!),
                  ],
                ),
              )
            : errorMessage != null
                ? _errorView()
                : _content(),
      ),
    );
  }

  Widget _content() {
    final t = texts;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _locationCard(),

        const SizedBox(height: 14),

        Text(
          t['times']!,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF173D32),
          ),
        ),

        const SizedBox(height: 12),

        ...prayerTimes.map(
          (prayer) => _prayerCard(prayer),
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
          t['scheduled']!,
          const Color(0xFF17604B),
        ),
      ],
    );
  }

  Widget _locationCard() {
    final t = texts;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE7DDCE),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(
                0xFF17604B,
              ).withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF17604B),
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  t['location']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xFF173D32),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  locationText,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _prayerCard(
    PrayerItem prayer,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF2),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE7DDCE),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(
                0xFF17604B,
              ).withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              prayer.icon,
              color:
                  const Color(0xFF17604B),
              size: 26,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              prayer.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173D32),
              ),
            ),
          ),

          Text(
            _formatTime(prayer.time),
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF17604B),
            ),
          ),
        ],
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
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF2),
        borderRadius:
            BorderRadius.circular(22),
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
            color:
                iconColor.withOpacity(0.10),
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
          padding:
              const EdgeInsets.only(top: 5),
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

            const SizedBox(height: 18),

            Text(
              errorMessage ??
                  t['locationRequired']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _startPrayerSystem,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: Text(
                widget.language == 'ar'
                    ? 'إعادة المحاولة'
                    : 'Try again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// نموذج الصلاة
// ======================================================

class PrayerItem {
  final String name;
  final DateTime time;
  final IconData icon;

  const PrayerItem({
    required this.name,
    required this.time,
    required this.icon,
  });
}

// ======================================================
// بيانات الإشعار
// ======================================================

class _PrayerNotification {
  final String name;
  final DateTime time;

  const _PrayerNotification({
    required this.name,
    required this.time,
  });
}
