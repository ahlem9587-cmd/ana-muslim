import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

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
        };

      case 'fr':
        return {
          'title': 'Majlis de récitation',
          'choose': 'Choisissez comment enregistrer',
          'video': 'Audio et vidéo',
          'videoSub': 'Enregistrez avec la caméra et le son',
          'audio': 'Audio seulement',
          'audioSub': 'Enregistrez sans caméra',
        };

      case 'tr':
        return {
          'title': 'Tilavet Meclisi',
          'choose': 'Nasıl kayıt yapmak istediğinizi seçin',
          'video': 'Ses ve Görüntü',
          'videoSub': 'Kamera ve ses ile tilavet kaydedin',
          'audio': 'Sadece Ses',
          'audioSub': 'Kamerasız tilavet kaydedin',
        };

      case 'ur':
        return {
          'title': 'تلاوت کی مجلس',
          'choose': 'منتخب کریں کہ کیسے ریکارڈ کرنا ہے',
          'video': 'آواز اور ویڈیو',
          'videoSub': 'کیمرے اور آواز کے ساتھ تلاوت ریکارڈ کریں',
          'audio': 'صرف آواز',
          'audioSub': 'کیمرے کے بغیر تلاوت ریکارڈ کریں',
        };

      default:
        return {
          'title': 'مجلس التلاوة',
          'choose': 'اختر طريقة تسجيل تلاوتك',
          'video': 'صوت وصورة',
          'videoSub': 'سجّل تلاوتك بالكاميرا والصوت',
          'audio': 'صوت فقط',
          'audioSub': 'سجّل تلاوتك بدون كاميرا',
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
                  subtitle: Text(t['videoSub']!),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoRecordingPage(
                          language: language,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

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
                  subtitle: Text(t['audioSub']!),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AudioRecordingPage(
                          language: language,
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

class VideoRecordingPage extends StatefulWidget {
  final String language;

  const VideoRecordingPage({
    super.key,
    required this.language,
  });

  @override
  State<VideoRecordingPage> createState() =>
      _VideoRecordingPageState();
}

class _VideoRecordingPageState
    extends State<VideoRecordingPage> {
  CameraController? controller;
  bool ready = false;
  bool recording = false;

  @override
  void initState() {
    super.initState();
    startCamera();
  }

  Future<void> startCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) return;

      controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: true,
      );

      await controller!.initialize();

      if (mounted) {
        setState(() {
          ready = true;
        });
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<void> toggleRecording() async {
    if (controller == null || !ready) return;

    if (recording) {
      await controller!.stopVideoRecording();

      if (mounted) {
        setState(() {
          recording = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إيقاف التسجيل بنجاح 🎥'),
          ),
        );
      }
    } else {
      await controller!.startVideoRecording();

      if (mounted) {
        setState(() {
          recording = true;
        });
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل التلاوة'),
        centerTitle: true,
      ),
      body: !ready
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                SizedBox.expand(
                  child: CameraPreview(controller!),
                ),
                Positioned(
                  bottom: 35,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: toggleRecording,
                      backgroundColor:
                          recording ? Colors.red : Colors.white,
                      child: Icon(
                        recording
                            ? Icons.stop
                            : Icons.videocam,
                        color: recording
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class AudioRecordingPage extends StatefulWidget {
  final String language;

  const AudioRecordingPage({
    super.key,
    required this.language,
  });

  @override
  State<AudioRecordingPage> createState() =>
      _AudioRecordingPageState();
}

class _AudioRecordingPageState
    extends State<AudioRecordingPage> {
  final AudioRecorder recorder = AudioRecorder();

  bool recording = false;

  Future<void> toggleRecording() async {
    if (recording) {
      await recorder.stop();

      if (mounted) {
        setState(() {
          recording = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إيقاف التسجيل بنجاح 🎙️'),
          ),
        );
      }
    } else {
      final hasPermission = await recorder.hasPermission();

      if (!hasPermission) return;

      await recorder.start(
        const RecordConfig(),
        path: 'recitation.m4a',
      );

      if (mounted) {
        setState(() {
          recording = true;
        });
      }
    }
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل صوتي'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              recording ? Icons.mic : Icons.mic_none,
              size: 100,
            ),
            const SizedBox(height: 30),
            Text(
              recording
                  ? 'جاري تسجيل تلاوتك...'
                  : 'جاهز لتسجيل تلاوتك',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            FloatingActionButton(
              onPressed: toggleRecording,
              child: Icon(
                recording ? Icons.stop : Icons.mic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
