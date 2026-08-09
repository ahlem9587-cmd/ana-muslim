import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class RecitationsPage extends StatefulWidget {
  const RecitationsPage({super.key});

  @override
  State<RecitationsPage> createState() => _RecitationsPageState();
}

class _RecitationsPageState extends State<RecitationsPage> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];

  bool _isReady = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _startCamera();
  }

  Future<void> _startCamera() async {
    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        return;
      }

      final camera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: true,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isReady = true;
        });
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<void> _toggleRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return;
    }

    if (_isRecording) {
      final video = await _cameraController!.stopVideoRecording();

      if (mounted) {
        setState(() {
          _isRecording = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ التلاوة بنجاح 🎙️'),
          ),
        );
      }

      debugPrint('Recorded video: ${video.path}');
    } else {
      await _cameraController!.startVideoRecording();

      if (mounted) {
        setState(() {
          _isRecording = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مجلس التلاوة'),
        centerTitle: true,
      ),
      body: !_isReady
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                SizedBox.expand(
                  child: CameraPreview(_cameraController!),
                ),

                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'اعرض تلاوتك على المسلمين 📖',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 35,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: _toggleRecording,
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isRecording
                              ? Colors.red
                              : Colors.white,
                          border: Border.all(
                            color: Colors.white,
                            width: 5,
                          ),
                        ),
                        child: Icon(
                          _isRecording
                              ? Icons.stop
                              : Icons.mic,
                          size: 38,
                          color: _isRecording
                              ? Colors.white
                              : Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
