import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

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
  bool locationDisabled = false;
  bool usingSavedLocation = false;

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
          'getting': 'Getting your location...',
          'enabled': 'Prayer notifications are enabled',
          'disabled': 'Prayer notifications are disabled',
          'locationError':
              'Please enable location to reset prayer times',
          'savedLocation':
              'Using your last saved location',
          'updated':
              'Prayer times have been updated',
          'soon': 'Will be available soon',
          'refresh': 'Refresh Location',
          'fajr': 'Fajr',
          'dhuhr': 'Dhuhr',
          'asr': 'Asr',
          'maghrib': 'Maghrib',
          'isha': 'Isha',
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
          'getting': 'Obtention de votre position...',
          'enabled':
              'Les notifications de prière sont activées',
          'disabled':
              'Les notifications de prière sont désactivées',
          'locationError':
              'Veuillez activer la localisation pour réinitialiser les heures de prière',
          'savedLocation':
              'Utilisation de votre dernière position enregistrée',
          'updated':
              'Les heures de prière ont été mises à jour',
          'soon': 'Disponible prochainement',
          'refresh': 'Actualiser la localisation',
          'fajr': 'Fajr',
          'dhuhr': 'Dhohr',
          'asr': 'Asr',
          'maghrib': 'Maghrib',
          'isha': 'Isha',
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
          'getting': 'Konumunuz alınıyor...',
          'enabled': 'Namaz bildirimleri açık',
          'disabled': 'Namaz bildirimleri kapalı',
          'locationError':
              'Namaz vakitlerini yenilemek için lütfen konumu açın',
          'savedLocation':
              'Son kaydedilen konumunuz kullanılıyor',
          'updated': 'Namaz vakitleri güncellendi',
          'soon': 'Yakında kullanılabilir',
          'refresh': 'Konumu Yenile',
          'fajr': 'Sabah',
          'dhuhr': 'Öğle',
          'asr': 'İkindi',
          'maghrib': 'Akşam',
          'isha': 'Yatsı',
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
          'getting': 'آپ کا مقام حاصل کیا جا رہا ہے...',
          'enabled': 'نماز کی اطلاعات فعال ہیں',
          'disabled': 'نماز کی اطلاعات غیر فعال ہیں',
          'locationError':
              'نماز کے اوقات دوبارہ ترتیب دینے کے لیے مقام فعال کریں',
          'savedLocation':
              'آپ کا آخری محفوظ مقام استعمال کیا جا رہا ہے',
          'updated': 'نماز کے اوقات اپ ڈیٹ ہوگئے',
          'soon': 'جلد دستیاب ہوگا',
          'refresh': 'مقام تازہ کریں',
          'fajr': 'فجر',
          'dhuhr': 'ظہر',
          'asr': 'عصر',
          'maghrib': 'مغرب',
          'isha': 'عشاء',
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
          'getting': 'جارٍ الحصول على موقعك...',
          'enabled': 'إشعارات أوقات الصلاة مفعلة',
          'disabled': 'إشعارات أوقات الصلاة غير مفعلة',
          'locationError':
              'الرجاء تفعيل الموقع لإعادة ضبط مواقيت الصلاة',
          'savedLocation':
              'يتم استخدام آخر موقع محفوظ لديك',
          'updated': 'تم تحديث أوقات الصلاة',
          'soon': 'ستتوفر قريبًا',
          'refresh': 'تحديث الموقع',
          'fajr': 'الفجر',
          'dhuhr': 'الظهر',
          'asr': 'العصر',
          'maghrib': 'المغرب',
          'isha': 'العشاء',
        };
    }
  }

  Future<void> _startPrayerPage() async {
    try {
      await _initializeNotifications();

      final bool gotCurrentLocation =
          await _tryGetCurrentLocation();

      if (!gotCurrentLocation) {
        final bool gotSavedLocation =
            await _loadSavedLocation();

        if (!gotSavedLocation) {
          throw Exception('No location available');
        }

        usingSavedLocation = true;
        locationDisabled = true;
      } else {
        usingSavedLocation = false;
        locationDisabled = false;
      }

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          loading = false;
          locationDisabled = true;
          prayerTimes = null;
        });
      }
    }
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();

    try {
      final timezoneInfo =
          await FlutterTimezone.getLocalTimezone();

      final String timezoneName =
          timezoneInfo.identifier;

      try {
        tz.setLocalLocation(
          tz.getLocation(timezoneName),
        );
      } catch (_) {
        tz.setLocalLocation(
          tz.getLocation('UTC'),
        );
      }
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

  Future<bool> _tryGetCurrentLocation() async {
    final bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
    } catch (_) {
      return false;
    }

    await _saveLocation(
      position!.latitude,
      position!.longitude,
    );

    _calculatePrayerTimes(
      position!.latitude,
      position!.longitude,
    );

    return true;
  }

  Future<bool> _loadSavedLocation() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    final double? latitude =
        prefs.getDouble('saved_latitude');

    final double? longitude =
        prefs.getDouble('saved_longitude');

    if (latitude == null || longitude == null) {
      return false;
    }

    _calculatePrayerTimes(
      latitude,
      longitude,
    );

    return prayerTimes != null;
  }

  Future<void> _saveLocation(
    double latitude,
    double longitude,
  ) async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setDouble(
      'saved_latitude',
      latitude,
    );

    await prefs.setDouble(
      'saved_longitude',
      longitude,
    );
  }

  void _calculatePrayerTimes(
    double latitude,
    double longitude,
  ) {
    final coordinates =
        Coordinates(latitude, longitude);

    final params =
        CalculationMethod.muslim_world_league
            .getParameters();

    params.madhab = Madhab.shafi;

    prayerTimes = PrayerTimes.today(
      coordinates,
      params,
    );
  }

  Future<void> _refreshPrayerTimes() async {
    setState(() {
      loading = true;
    });

    final bool success =
        await _tryGetCurrentLocation();

    if (mounted) {
      setState(() {
        loading = false;
        locationDisabled = !success;
        usingSavedLocation = false;
      });

      if (success) {
        _showMessage(texts['updated']!);
      } else {
        final bool saved =
            await _loadSavedLocation();

        if (mounted) {
          setState(() {
            usingSavedLocation = saved;
          });

          if (!saved) {
            _showMessage(
              texts['locationError']!,
            );
          }
        }
      }
    }
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
    final DateTime date = prayer.time;

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
    );

    if (scheduledDate.isBefore(
      tz.TZDateTime.now(tz.local),
    )) {
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
      prayer.id,
      prayer.name,
      prayer.name,
      scheduledDate,
      details,
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
    final String hour =
        time.hour.toString().padLeft(2, '0');

    final String minute =
        time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
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
            : RefreshIndicator(
                color: const Color(0xFF17604B),
                onRefresh: _refreshPrayerTimes,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (usingSavedLocation)
                      _buildSavedLocationMessage(),

                    _buildPrayerTimesCard(),

                    const SizedBox(height: 14),

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

                    _buildNotificationCard(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSavedLocationMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE7DDCE),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_rounded,
            color: Color(0xFF17604B),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texts['savedLocation']!,
              style: const TextStyle(
                color: Color(0xFF173D32),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
          border: Border.all(
            color: const Color(0xFFE7DDCE),
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.location_off_rounded,
              size: 42,
              color: Color(0xFF17604B),
            ),
            const SizedBox(height: 12),
            Text(
              t['locationError']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173D32),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _refreshPrayerTimes,
              icon: const Icon(
                Icons.location_on_rounded,
              ),
              label: Text(
                t['refresh']!,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF17604B),
                foregroundColor: Colors.white,
              ),
            ),
          ],
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
