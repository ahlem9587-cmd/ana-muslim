import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
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

  bool loading = true;
  bool notificationsEnabled = false;

  Position? position;
  PrayerTimes? prayerTimes;

  @override
  void initState() {
    super.initState();
    _startPrayerPage();
  }

  bool get isRtl =>
      widget.language == 'ar' || widget.language == 'ur';

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
          'adhan': 'Prayer Notifications',
          'location': 'Location',
          'getting': 'Getting your location...',
          'enabled': 'Prayer notifications are enabled',
          'disabled': 'Prayer notifications are disabled',
          'enable': 'Enable Notifications',
          'disable': 'Disable Notifications',
          'permission': 'Notification permission is required',
          'locationError': 'Unable to get your location',
          'soon': 'Will be available soon',
          'fajr': 'Fajr',
          'dhuhr': 'Dhuhr',
          'asr': 'Asr',
          'maghrib': 'Maghrib',
          'isha': 'Isha',
          'updated': 'Prayer times updated',
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
          'adhan': 'Notifications de prière',
          'location': 'Localisation',
          'getting': 'Obtention de votre position...',
          'enabled': 'Les notifications de prière sont activées',
          'disabled': 'Les notifications de prière sont désactivées',
          'enable': 'Activer les notifications',
          'disable': 'Désactiver les notifications',
          'permission': 'La permission de notification est requise',
          'locationError': 'Impossible d’obtenir votre position',
          'soon': 'Disponible prochainement',
          'fajr': 'Fajr',
          'dhuhr': 'Dhohr',
          'asr': 'Asr',
          'maghrib': 'Maghrib',
          'isha': 'Isha',
          'updated': 'Heures de prière mises à jour',
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
          'adhan': 'Namaz Bildirimleri',
          'location': 'Konum',
          'getting': 'Konumunuz alınıyor...',
          'enabled': 'Namaz bildirimleri açık',
          'disabled': 'Namaz bildirimleri kapalı',
          'enable': 'Bildirimleri Aç',
          'disable': 'Bildirimleri Kapat',
          'permission': 'Bildirim izni gerekiyor',
          'locationError': 'Konum alınamadı',
          'soon': 'Yakında kullanılabilir',
          'fajr': 'Sabah',
          'dhuhr': 'Öğle',
          'asr': 'İkindi',
          'maghrib': 'Akşam',
          'isha': 'Yatsı',
          'updated': 'Namaz vakitleri güncellendi',
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
          'adhan': 'نماز کی اطلاعات',
          'location': 'مقام',
          'getting': 'آپ کا مقام حاصل کیا جا رہا ہے...',
          'enabled': 'نماز کی اطلاعات فعال ہیں',
          'disabled': 'نماز کی اطلاعات غیر فعال ہیں',
          'enable': 'اطلاعات فعال کریں',
          'disable': 'اطلاعات بند کریں',
          'permission': 'اطلاعات کی اجازت ضروری ہے',
          'locationError': 'مقام حاصل نہیں کیا جا سکا',
          'soon': 'جلد دستیاب ہوگا',
          'fajr': 'فجر',
          'dhuhr': 'ظہر',
          'asr': 'عصر',
          'maghrib': 'مغرب',
          'isha': 'عشاء',
          'updated': 'نماز کے اوقات اپ ڈیٹ ہوگئے',
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
          'adhan': 'إشعارات أوقات الصلاة',
          'location': 'الموقع',
          'getting': 'جارٍ الحصول على موقعك...',
          'enabled': 'إشعارات أوقات الصلاة مفعلة',
          'disabled': 'إشعارات أوقات الصلاة غير مفعلة',
          'enable': 'تفعيل الإشعارات',
          'disable': 'إيقاف الإشعارات',
          'permission': 'يجب السماح بالإشعارات',
          'locationError': 'تعذر الحصول على موقعك',
          'soon': 'ستتوفر قريبًا',
          'fajr': 'الفجر',
          'dhuhr': 'الظهر',
          'asr': 'العصر',
          'maghrib': 'المغرب',
          'isha': 'العشاء',
          'updated': 'تم تحديث أوقات الصلاة',
        };
    }
  }

  Future<void> _startPrayerPage() async {
    try {
      await _initializeNotifications();
      await _getLocationAndPrayerTimes();

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();

    final timezoneInfo =
        await FlutterTimezone.getLocalTimezone();

    final String timezoneName = timezoneInfo.name;

    try {
      tz.setLocalLocation(
        tz.getLocation(timezoneName),
      );
    } catch (_) {
      tz.setLocalLocation(
        tz.getLocation('UTC'),
      );
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(settings);

    final AndroidFlutterLocalNotificationsPlugin?
        androidPlugin =
        notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? permission =
        await androidPlugin?.requestNotificationsPermission();

    notificationsEnabled = permission ?? true;

    await androidPlugin?.requestExactAlarmsPermission();
  }

  Future<void> _getLocationAndPrayerTimes() async {
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location service disabled');
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }

    position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );

    final coordinates = Coordinates(
      position!.latitude,
      position!.longitude,
    );

    final params =
        CalculationMethod.muslim_world_league.getParameters();

    params.madhab = Madhab.shafi;

    prayerTimes = PrayerTimes.today(
      coordinates,
      params,
    );
  }

  Future<void> _schedulePrayerNotifications() async {
    if (prayerTimes == null) {
      return;
    }

    await notifications.cancelAll();

    final List<_PrayerNotificationData> prayers = [
      _PrayerNotificationData(
        id: 1,
        name: texts['fajr']!,
        time: prayerTimes!.fajr,
      ),
      _PrayerNotificationData(
        id: 2,
        name: texts['dhuhr']!,
        time: prayerTimes!.dhuhr,
      ),
      _PrayerNotificationData(
        id: 3,
        name: texts['asr']!,
        time: prayerTimes!.asr,
      ),
      _PrayerNotificationData(
        id: 4,
        name: texts['maghrib']!,
        time: prayerTimes!.maghrib,
      ),
      _PrayerNotificationData(
        id: 5,
        name: texts['isha']!,
        time: prayerTimes!.isha,
      ),
    ];

    for (final prayer in prayers) {
      await _scheduleOnePrayer(prayer);
    }

    notificationsEnabled = true;

    if (mounted) {
      setState(() {});
      _showMessage(texts['enabled']!);
    }
  }

  Future<void> _scheduleOnePrayer(
    _PrayerNotificationData prayer,
  ) async {
    DateTime date = prayer.time;

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
    );

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledDate = scheduledDate.add(
        const Duration(days: 1),
      );
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'prayer_times',
      'Prayer Times',
      channelDescription:
          'Notifications for Islamic prayer times',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details =
        NotificationDetails(
      android: androidDetails,
    );

    await notifications.zonedSchedule(
      id: prayer.id,
      title: prayer.name,
      body: prayer.name,
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
          DateTimeComponents.time,
    );
  }

  Future<void> _disablePrayerNotifications() async {
    await notifications.cancelAll();

    notificationsEnabled = false;

    if (mounted) {
      setState(() {});
      _showMessage(texts['disabled']!);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final int hour = time.hour;
    final int minute = time.minute;

    final String hourText =
        hour.toString().padLeft(2, '0');

    final String minuteText =
        minute.toString().padLeft(2, '0');

    return '$hourText:$minuteText';
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
        body: loading
            ? Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Color(0xFF17604B),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t['getting']!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildPrayerTimesCard(),

                  const SizedBox(height: 14),

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

                  _buildNotificationCard(),
                ],
              ),
      ),
    );
  }

  Widget _buildPrayerTimesCard() {
    final t = texts;

    if (prayerTimes == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAF2),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          t['locationError']!,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF17604B),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            t['times']!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _prayerTimeRow(
            t['fajr']!,
            prayerTimes!.fajr,
          ),
          _prayerTimeRow(
            t['dhuhr']!,
            prayerTimes!.dhuhr,
          ),
          _prayerTimeRow(
            t['asr']!,
            prayerTimes!.asr,
          ),
          _prayerTimeRow(
            t['maghrib']!,
            prayerTimes!.maghrib,
          ),
          _prayerTimeRow(
            t['isha']!,
            prayerTimes!.isha,
          ),
        ],
      ),
    );
  }

  Widget _prayerTimeRow(
    String name,
    DateTime time,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _formatTime(time),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard() {
    final t = texts;

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
            color: const Color(0xFF17604B)
                .withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications_active_rounded,
            color: Color(0xFF17604B),
            size: 27,
          ),
        ),
        title: Text(
          t['adhan']!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF173D32),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            notificationsEnabled
                ? t['enabled']!
                : t['disabled']!,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
        trailing: Switch(
          value: notificationsEnabled,
          activeColor: const Color(0xFF17604B),
          onChanged: (value) async {
            if (value) {
              await _schedulePrayerNotifications();
            } else {
              await _disablePrayerNotifications();
            }
          },
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
        onTap: () {
          _showMessage(subtitle);
        },
      ),
    );
  }
}

class _PrayerNotificationData {
  final int id;
  final String name;
  final DateTime time;

  const _PrayerNotificationData({
    required this.id,
    required this.name,
    required this.time,
  });
}
