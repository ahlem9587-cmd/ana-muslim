import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

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

  final AudioPlayer adhanPlayer = AudioPlayer();

  bool loading = true;
  bool notificationsEnabled = false;
  bool locationDisabled = false;
  bool usingSavedLocation = false;
  bool isPlayingAdhan = false;

  Position? position;
  PrayerTimes? prayerTimes;

  // ============================================================
  // ثوابت الموقع والإشعارات
  // ============================================================

  static const String savedLatitudeKey = 'saved_latitude';
  static const String savedLongitudeKey = 'saved_longitude';
  static const String notificationEnabledKey =
      'prayer_notifications_enabled';

  // قناة جديدة حتى يستخدم أندرويد صوت الأذان الجديد
  static const String adhanChannelId = 'prayer_adhan_v2';

  @override
  void initState() {
    super.initState();

    adhanPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          isPlayingAdhan = false;
        });
      }
    });

    _startPrayerPage();
  }

  @override
  void dispose() {
    adhanPlayer.dispose();
    super.dispose();
  }

  bool get isRtl =>
      widget.language == 'ar' ||
      widget.language == 'ur';

  // ============================================================
  // اللغات
  // ============================================================

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
          'testAdhan': 'Test Adhan',
          'stopAdhan': 'Stop Adhan',
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
          'notificationPermission':
              'Please allow notification permission',
          'alarmPermission':
              'Please allow exact alarm permission',
          'notificationScheduled':
              'Prayer notifications scheduled',
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
          'testAdhan': 'Tester l’adhan',
          'stopAdhan': 'Arrêter l’adhan',
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
          'notificationPermission':
              'Veuillez autoriser les notifications',
          'alarmPermission':
              'Veuillez autoriser les alarmes exactes',
          'notificationScheduled':
              'Notifications de prière programmées',
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
          'testAdhan': 'Ezanı Test Et',
          'stopAdhan': 'Ezanı Durdur',
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
          'notificationPermission':
              'Lütfen bildirim iznini verin',
          'alarmPermission':
              'Lütfen kesin alarm iznini verin',
          'notificationScheduled':
              'Namaz bildirimleri planlandı',
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
          'testAdhan': 'اذان ٹیسٹ کریں',
          'stopAdhan': 'اذان بند کریں',
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
          'notificationPermission':
              'براہ کرم اطلاعات کی اجازت دیں',
          'alarmPermission':
              'براہ کرم درست الارم کی اجازت دیں',
          'notificationScheduled':
              'نماز کی اطلاعات مقرر کر دی گئی ہیں',
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
          'testAdhan': 'اختبار الأذان',
          'stopAdhan': 'إيقاف الأذان',
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
          'notificationPermission':
              'الرجاء السماح بإشعارات التطبيق',
          'alarmPermission':
              'الرجاء السماح بالتنبيهات الدقيقة',
          'notificationScheduled':
              'تم جدولة إشعارات أوقات الصلاة',
        };
    }
  }

  // ============================================================
  // بداية الصفحة
  // ============================================================

  Future<void> _startPrayerPage() async {
    try {
      await _initializeNotifications();

      // أولاً نحاول الحصول على GPS الحقيقي
      final bool gotCurrentLocation =
          await _tryGetCurrentLocation();

      // إذا لم ينجح GPS نستخدم آخر GPS محفوظ
      if (!gotCurrentLocation) {
        final bool gotSavedLocation =
            await _loadSavedLocation();

        if (!gotSavedLocation) {
          throw Exception('No saved location available');
        }

        usingSavedLocation = true;
        locationDisabled = true;
      } else {
        usingSavedLocation = false;
        locationDisabled = false;
      }

      final SharedPreferences prefs =
          await SharedPreferences.getInstance();

      final bool savedNotificationState =
          prefs.getBool(notificationEnabledKey) ??
              false;

      // إذا كان المستخدم قد فعل الإشعارات سابقاً
      // نعيد جدولة الـ30 يومًا من نفس GPS المحفوظ
      if (savedNotificationState &&
          prayerTimes != null) {
        final bool scheduled =
            await _schedulePrayerNotifications(
          showMessage: false,
        );

        notificationsEnabled = scheduled;
      }

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      debugPrint(
        'Prayer page error: $e',
      );

      if (mounted) {
        setState(() {
          loading = false;
          locationDisabled = true;
          prayerTimes = null;
        });
      }
    }
  }

  // ============================================================
  // تهيئة الإشعارات
  // ============================================================

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

    const AndroidInitializationSettings
        androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings settings =
        InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(
      settings,
    );

    final AndroidFlutterLocalNotificationsPlugin?
        androidPlugin =
        notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    final bool? permission =
        await androidPlugin
            ?.requestNotificationsPermission();

    notificationsEnabled =
        permission ?? false;

    await androidPlugin
        ?.requestExactAlarmsPermission();
  }

  // ============================================================
  // الحصول على GPS الحقيقي
  // ============================================================

  Future<bool> _tryGetCurrentLocation() async {
    final bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      debugPrint('Location service is disabled');
      return false;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission ==
        LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission ==
            LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      debugPrint('Location permission denied');
      return false;
    }

    try {
      final Position currentPosition =
          await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(
          accuracy:
              LocationAccuracy.high,
        ),
      );

      position = currentPosition;

      // حفظ GPS الحقيقي
      await _saveLocation(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      // حساب المواقيت من GPS الحقيقي
      _calculatePrayerTimes(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      debugPrint(
        'GPS saved: '
        '${currentPosition.latitude}, '
        '${currentPosition.longitude}',
      );

      return true;
    } catch (e) {
      debugPrint(
        'Location error: $e',
      );

      return false;
    }
  }

  // ============================================================
  // تحميل آخر GPS محفوظ
  // ============================================================

  Future<bool> _loadSavedLocation() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    final double? latitude =
        prefs.getDouble(savedLatitudeKey);

    final double? longitude =
        prefs.getDouble(savedLongitudeKey);

    if (latitude == null ||
        longitude == null) {
      debugPrint(
        'No saved GPS location found',
      );

      return false;
    }

    // مهم:
    // نضع الموقع المحفوظ داخل position أيضاً
    // حتى تستخدمه جدولة الإشعارات نفسها.
    position = Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );

    _calculatePrayerTimes(
      latitude,
      longitude,
    );

    debugPrint(
      'Using saved GPS: '
      '$latitude, $longitude',
    );

    return prayerTimes != null;
  }

  // ============================================================
  // حفظ GPS
  // ============================================================

  Future<void> _saveLocation(
    double latitude,
    double longitude,
  ) async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setDouble(
      savedLatitudeKey,
      latitude,
    );

    await prefs.setDouble(
      savedLongitudeKey,
      longitude,
    );
  }

  // ============================================================
  // حساب مواقيت الصلاة
  // ============================================================

  void _calculatePrayerTimes(
    double latitude,
    double longitude,
  ) {
    final Coordinates coordinates =
        Coordinates(
      latitude,
      longitude,
    );

    final CalculationParameters params =
        CalculationMethod
            .muslim_world_league
            .getParameters();

    params.madhab =
        Madhab.shafi;

    prayerTimes =
        PrayerTimes.today(
      coordinates,
      params,
    );
  }

  // ============================================================
  // تحديث الموقع
  // ============================================================

  Future<void> _refreshPrayerTimes() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    // نحاول دائماً أخذ GPS جديد
    final bool success =
        await _tryGetCurrentLocation();

    if (success) {
      final SharedPreferences prefs =
          await SharedPreferences.getInstance();

      final bool enabled =
          prefs.getBool(
                notificationEnabledKey,
              ) ??
              false;

      if (enabled) {
        await _schedulePrayerNotifications(
          showMessage: false,
        );
      }

      if (mounted) {
        setState(() {
          loading = false;
          locationDisabled = false;
          usingSavedLocation = false;
        });

        _showMessage(
          texts['updated']!,
        );
      }
    } else {
      // إذا فشل GPS نستخدم آخر موقع محفوظ
      final bool saved =
          await _loadSavedLocation();

      if (mounted) {
        setState(() {
          loading = false;
          locationDisabled = true;
          usingSavedLocation = saved;
        });
      }

      if (saved) {
        final SharedPreferences prefs =
            await SharedPreferences.getInstance();

        final bool enabled =
            prefs.getBool(
                  notificationEnabledKey,
                ) ??
                false;

        if (enabled) {
          await _schedulePrayerNotifications(
            showMessage: false,
          );
        }
      } else {
        _showMessage(
          texts['locationError']!,
        );
      }
    }
  }

  // ============================================================
  // اختبار الأذان
  // ============================================================

  Future<void> _testAdhan() async {
    try {
      if (isPlayingAdhan) {
        await adhanPlayer.stop();

        if (mounted) {
          setState(() {
            isPlayingAdhan = false;
          });
        }

        return;
      }

      await adhanPlayer.stop();

      await adhanPlayer.setReleaseMode(
        ReleaseMode.stop,
      );

      await adhanPlayer.play(
        AssetSource(
          'audio/Beautiful_adhan.ogg',
        ),
      );

      if (mounted) {
        setState(() {
          isPlayingAdhan = true;
        });
      }
    } catch (e) {
      debugPrint(
        'Adhan audio error: $e',
      );

      if (mounted) {
        setState(() {
          isPlayingAdhan = false;
        });

        _showMessage(
          'تعذر تشغيل صوت الأذان',
        );
      }
    }
  }

  // ============================================================
  // جدولة إشعارات 30 يوم
  // ============================================================

  Future<bool> _schedulePrayerNotifications({
    bool showMessage = true,
  }) async {
    if (prayerTimes == null ||
        position == null) {
      debugPrint(
        'Cannot schedule: no GPS location',
      );

      return false;
    }

    final AndroidFlutterLocalNotificationsPlugin?
        androidPlugin =
        notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    final bool? notificationPermission =
        await androidPlugin
            ?.requestNotificationsPermission();

    if (notificationPermission == false) {
      if (mounted) {
        _showMessage(
          texts['notificationPermission']!,
        );
      }

      return false;
    }

    final bool? exactAlarmPermission =
        await androidPlugin
            ?.requestExactAlarmsPermission();

    if (exactAlarmPermission == false) {
      if (mounted) {
        _showMessage(
          texts['alarmPermission']!,
        );
      }

      return false;
    }

    // حذف الجدولة القديمة
    await notifications.cancelAll();

    // ==========================================================
    // هذا هو GPS المستخدم فعلياً
    // وليس موقعاً عشوائياً.
    // ==========================================================

    final double latitude =
        position!.latitude;

    final double longitude =
        position!.longitude;

    final Coordinates coordinates =
        Coordinates(
      latitude,
      longitude,
    );

    debugPrint(
      'Scheduling prayers for GPS: '
      '$latitude, $longitude',
    );

    final CalculationParameters params =
        CalculationMethod
            .muslim_world_league
            .getParameters();

    params.madhab =
        Madhab.shafi;

    final DateTime now =
        DateTime.now();

    int notificationId = 100;

    // ==========================================================
    // 30 يوم
    // ==========================================================

    for (int day = 0; day < 30; day++) {
      final DateTime date =
          DateTime(
        now.year,
        now.month,
        now.day + day,
      );

      final PrayerTimes dayPrayerTimes =
          PrayerTimes(
        coordinates,
        DateComponents(
          date.year,
          date.month,
          date.day,
        ),
        params,
      );

      final List<_PrayerNotificationData>
          prayers = [
        _PrayerNotificationData(
          id: notificationId++,
          name: texts['fajr']!,
          time: dayPrayerTimes.fajr,
        ),
        _PrayerNotificationData(
          id: notificationId++,
          name: texts['dhuhr']!,
          time: dayPrayerTimes.dhuhr,
        ),
        _PrayerNotificationData(
          id: notificationId++,
          name: texts['asr']!,
          time: dayPrayerTimes.asr,
        ),
        _PrayerNotificationData(
          id: notificationId++,
          name: texts['maghrib']!,
          time: dayPrayerTimes.maghrib,
        ),
        _PrayerNotificationData(
          id: notificationId++,
          name: texts['isha']!,
          time: dayPrayerTimes.isha,
        ),
      ];

      for (final prayer in prayers) {
        await _scheduleOnePrayer(
          prayer,
        );
      }
    }

    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      notificationEnabledKey,
      true,
    );

    notificationsEnabled = true;

    if (mounted) {
      setState(() {});

      if (showMessage) {
        _showMessage(
          texts['notificationScheduled']!,
        );
      }
    }

    return true;
  }

  // ============================================================
  // جدولة إشعار صلاة واحد مع صوت الأذان
  // ============================================================

  Future<void> _scheduleOnePrayer(
    _PrayerNotificationData prayer,
  ) async {
    final DateTime date =
        prayer.time;

    final tz.TZDateTime scheduledDate =
        tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
    );

    final tz.TZDateTime now =
        tz.TZDateTime.now(
      tz.local,
    );

    if (scheduledDate.isBefore(now)) {
      return;
    }

    // ==========================================================
    // صوت الأذان
    //
    // يجب أن يكون الملف:
    //
    // android/app/src/main/res/raw/beautiful_adhan.ogg
    //
    // بدون حرف كبير وبدون مسافات.
    // ==========================================================

    const AndroidNotificationDetails
        androidDetails =
        AndroidNotificationDetails(
      adhanChannelId,
      'Prayer Adhan',
      channelDescription:
          'Adhan notifications for prayer times',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,

      sound:
          RawResourceAndroidNotificationSound(
        'beautiful_adhan',
      ),
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
          AndroidScheduleMode
              .exactAllowWhileIdle,
    );
  }

  // ============================================================
  // إيقاف الإشعارات
  // ============================================================

  Future<void> _disablePrayerNotifications() async {
    await notifications.cancelAll();

    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      notificationEnabledKey,
      false,
    );

    notificationsEnabled = false;

    if (mounted) {
      setState(() {});

      _showMessage(
        texts['disabled']!,
      );
    }
  }

  // ============================================================
  // رسالة
  // ============================================================

  void _showMessage(
    String message,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ============================================================
  // تنسيق الوقت
  // ============================================================

  String _formatTime(
    DateTime time,
  ) {
    final String hour =
        time.hour
            .toString()
            .padLeft(2, '0');

    final String minute =
        time.minute
            .toString()
            .padLeft(2, '0');

    return '$hour:$minute';
  }

  // ============================================================
  // الواجهة
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final Map<String, String> t =
        texts;

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
            style:
                const TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor:
              const Color(0xFFF4EDE1),
          elevation: 0,
        ),
        body: loading
            ? Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color:
                          Color(0xFF17604B),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      t['getting']!,
                      style:
                          const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                color:
                    const Color(0xFF17604B),
                onRefresh:
                    _refreshPrayerTimes,
                child: ListView(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  children: [
                    if (usingSavedLocation)
                      _buildSavedLocationMessage(),

                    _buildPrayerTimesCard(),

                    const SizedBox(
                      height: 14,
                    ),

                    _buildAdhanTestCard(),

                    const SizedBox(
                      height: 14,
                    ),

                    _sectionCard(
                      Icons
                          .water_drop_rounded,
                      t['wudu']!,
                      t['soon']!,
                      const Color(
                        0xFF287A9E,
                      ),
                    ),

                    _sectionCard(
                      Icons
                          .mosque_rounded,
                      t['fard']!,
                      t['soon']!,
                      const Color(
                        0xFF17604B,
                      ),
                    ),

                    _sectionCard(
                      Icons.star_rounded,
                      t['sunnah']!,
                      t['soon']!,
                      const Color(
                        0xFFE6AA28,
                      ),
                    ),

                    _sectionCard(
                      Icons
                          .menu_book_rounded,
                      t['how']!,
                      t['soon']!,
                      const Color(
                        0xFF17604B,
                      ),
                    ),

                    _sectionCard(
                      Icons
                          .info_outline_rounded,
                      t['rules']!,
                      t['soon']!,
                      const Color(
                        0xFF17604B,
                      ),
                    ),

                    _buildNotificationCard(),
                  ],
                ),
              ),
      ),
    );
  }

  // ============================================================
  // بطاقة اختبار الأذان
  // ============================================================

  Widget _buildAdhanTestCard() {
    final Map<String, String> t =
        texts;

    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFFFFAF2),
        borderRadius:
            BorderRadius.circular(22),
        border:
            Border.all(
          color:
              const Color(0xFFE7DDCE),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFF17604B,
              ).withOpacity(0.10),
              shape:
                  BoxShape.circle,
            ),
            child: const Icon(
              Icons
                  .volume_up_rounded,
              color:
                  Color(0xFF17604B),
              size: 27,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          Expanded(
            child: Text(
              isPlayingAdhan
                  ? t['stopAdhan']!
                  : t['testAdhan']!,
              style:
                  const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
                color:
                    Color(0xFF173D32),
              ),
            ),
          ),

          ElevatedButton(
            onPressed:
                _testAdhan,
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(
                0xFF17604B,
              ),
              foregroundColor:
                  Colors.white,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
            child: Icon(
              isPlayingAdhan
                  ? Icons.stop_rounded
                  : Icons
                      .play_arrow_rounded,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // الموقع المحفوظ
  // ============================================================

  Widget _buildSavedLocationMessage() {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),
      padding:
          const EdgeInsets.all(16),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFFFFAF2),
        borderRadius:
            BorderRadius.circular(18),
        border:
            Border.all(
          color:
              const Color(0xFFE7DDCE),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons
                .location_on_rounded,
            color:
                Color(0xFF17604B),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              texts[
                  'savedLocation']!,
              style:
                  const TextStyle(
                color:
                    Color(0xFF173D32),
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // بطاقة مواقيت الصلاة
  // ============================================================

  Widget _buildPrayerTimesCard() {
    final Map<String, String> t =
        texts;

    if (prayerTimes == null) {
      return Container(
        padding:
            const EdgeInsets.all(20),
        decoration:
            BoxDecoration(
          color:
              const Color(0xFFFFFAF2),
          borderRadius:
              BorderRadius.circular(22),
          border:
              Border.all(
            color:
                const Color(0xFFE7DDCE),
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons
                  .location_off_rounded,
              size: 42,
              color:
                  Color(0xFF17604B),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              t['locationError']!,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
                color:
                    Color(0xFF173D32),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              onPressed:
                  _refreshPrayerTimes,
              icon:
                  const Icon(
                Icons
                    .location_on_rounded,
              ),
              label:
                  Text(
                t['refresh']!,
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFF17604B,
                ),
                foregroundColor:
                    Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFF17604B),
        borderRadius:
            BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            t['times']!,
            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
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
      padding:
          const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          Text(
            _formatTime(time),
            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // بطاقة الإشعارات
  // ============================================================

  Widget _buildNotificationCard() {
    final Map<String, String> t =
        texts;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFFFFAF2),
        borderRadius:
            BorderRadius.circular(22),
        border:
            Border.all(
          color:
              const Color(0xFFE7DDCE),
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
          decoration:
              BoxDecoration(
            color:
                const Color(
              0xFF17604B,
            ).withOpacity(0.10),
            shape:
                BoxShape.circle,
          ),
          child: const Icon(
            Icons
                .notifications_active_rounded,
            color:
                Color(0xFF17604B),
            size: 27,
          ),
        ),
        title: Text(
          t['adhan']!,
          style:
              const TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight.bold,
            color:
                Color(0xFF173D32),
          ),
        ),
        subtitle: Padding(
          padding:
              const EdgeInsets.only(
            top: 5,
          ),
          child: Text(
            notificationsEnabled
                ? t['enabled']!
                : t['disabled']!,
            style:
                const TextStyle(
              color:
                  Colors.black54,
            ),
          ),
        ),
        trailing:
            Switch(
          value:
              notificationsEnabled,
          activeColor:
              const Color(
            0xFF17604B,
          ),
          onChanged:
              (bool value) async {
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

  // ============================================================
  // البطاقات الأخرى
  // ============================================================

  Widget _sectionCard(
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFFFFAF2),
        borderRadius:
            BorderRadius.circular(22),
        border:
            Border.all(
          color:
              const Color(0xFFE7DDCE),
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
          decoration:
              BoxDecoration(
            color:
                iconColor
                    .withOpacity(0.10),
            shape:
                BoxShape.circle,
          ),
          child: Icon(
            icon,
            color:
                iconColor,
            size: 27,
          ),
        ),
        title: Text(
          title,
          style:
              const TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight.bold,
            color:
                Color(0xFF173D32),
          ),
        ),
        subtitle: Padding(
          padding:
              const EdgeInsets.only(
            top: 5,
          ),
          child: Text(
            subtitle,
            style:
                const TextStyle(
              color:
                  Colors.black54,
            ),
          ),
        ),
        trailing:
            const Icon(
          Icons
              .arrow_forward_ios_rounded,
          size: 17,
          color:
              Colors.black45,
        ),
        onTap: () {
          _showMessage(
            subtitle,
          );
        },
      ),
    );
  }
}

// ================================================================
// بيانات إشعار الصلاة
// ================================================================

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
