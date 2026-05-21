import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ARViewerSeri extends StatefulWidget {
  const ARViewerSeri({super.key});

  @override
  State<ARViewerSeri> createState() => _ARViewerSeriState();
}

class _ARViewerSeriState extends State<ARViewerSeri>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _cameraReady = false;
  bool _loading = true;
  String? _errorMessage;

  static const String _modelPath = 'assets/models/electric_circuit.glb';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final permission = await Permission.camera.request();
      if (!mounted) return;

      if (!permission.isGranted) {
        setState(() {
          _loading = false;
          _errorMessage =
              'Izin kamera ditolak. Aktifkan izin kamera di pengaturan.';
        });
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _loading = false;
          _errorMessage = 'Tidak ada kamera yang tersedia.';
        });
        return;
      }

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _cameraReady = true;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = 'Gagal membuka kamera: $e';
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final controller = _cameraController;
    if (controller == null) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      await controller.dispose();
      if (!mounted) return;
      setState(() {
        _cameraController = null;
        _cameraReady = false;
      });
    } else if (state == AppLifecycleState.resumed) {
      await _initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('AR GLB View'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    if (!_cameraReady || _cameraController == null) {
      return const Center(
        child: Text('Kamera belum siap', style: TextStyle(color: Colors.white)),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_cameraController!),

        Positioned.fill(
          child: IgnorePointer(
            ignoring: false,
            child: ModelViewer(
              src: _modelPath,
              alt: 'Model AR',
              ar: false,
              autoRotate: true,
              cameraControls: true,
              disableZoom: false,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),

        Positioned(
          left: 16,
          right: 16,
          bottom: 20,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Model GLB ditampilkan di atas kamera. Ini overlay 3D cepat, belum marker tracking.',
              style: TextStyle(color: Colors.white, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }
}
