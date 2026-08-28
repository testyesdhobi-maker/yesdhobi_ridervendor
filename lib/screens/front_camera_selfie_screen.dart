import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:yesdhobi_ridervendor/theme.dart';
import 'package:yesdhobi_ridervendor/screens/selfie_confirmation_screen.dart';

class FrontCameraSelfieScreen extends StatefulWidget {
  const FrontCameraSelfieScreen({super.key});

  @override
  State<FrontCameraSelfieScreen> createState() =>
      _FrontCameraSelfieScreenState();
}

class _FrontCameraSelfieScreenState extends State<FrontCameraSelfieScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitializing = true;
  bool _isCapturing = false;
  String? _errorMessage;
  bool _isPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeFrontCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeFrontCamera();
    }
  }

  Future<void> _initializeFrontCamera() async {
    setState(() {
      _isInitializing = true;
      _errorMessage = null;
      _isPermissionDenied = false;
    });

    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _isInitializing = false;
          _errorMessage = 'No camera found on this device.';
        });
        return;
      }

      // Requirement: Select the FRONT camera ONLY
      final frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.jpeg,
      );

      _controller = controller;

      await controller.initialize();

      if (!mounted) return;
      setState(() {
        _isInitializing = false;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        if (e.code == 'CameraAccessDenied' ||
            e.code == 'CameraAccessDeniedWithoutPrompt' ||
            e.code == 'CameraAccessRestricted') {
          _isPermissionDenied = true;
          _errorMessage =
              'Camera permission was denied. Please allow camera access in Settings to take a selfie.';
        } else {
          _errorMessage =
              'Camera initialization failed: ${e.description ?? e.code}';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        _errorMessage = 'An unexpected error occurred: $e';
      });
    }
  }

  Future<void> _capturePhoto() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }

    try {
      setState(() {
        _isCapturing = true;
      });

      final XFile photo = await controller.takePicture();

      if (!mounted) return;

      // Navigate to Selfie Confirmation Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SelfieConfirmationScreen(imagePath: photo.path),
        ),
      );
    } on CameraException catch (e) {
      if (!mounted) return;
      setState(() {
        _isCapturing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to take photo: ${e.description ?? e.code}'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isCapturing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Preview or Fallback/Error state
            if (_isInitializing)
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Opening front camera...',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              )
            else if (_errorMessage != null)
              _buildErrorView()
            else if (_controller != null && _controller!.value.isInitialized)
              _buildCameraPreview()
            else
              _buildErrorView(),

            // Top Header: Back Button & Title
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.face_rounded,
                            color: Color(0xFF60A5FA), size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Front Camera',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48), // Balancing spacer
                ],
              ),
            ),

            // Bottom Controls Bar (Shutter Button)
            if (_controller != null &&
                _controller!.value.isInitialized &&
                _errorMessage == null)
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Position your face inside the frame',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _isCapturing ? null : _capturePhoto,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: _isCapturing
                            ? const SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    final controller = _controller!;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera Preview
        Center(
          child: CameraPreview(controller),
        ),

        // Oval Face Guide Cutout Overlay
        CustomPaint(
          painter: FaceFramingOverlayPainter(),
        ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.no_photography_rounded,
                color: Color(0xFFEF4444),
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isPermissionDenied ? 'Camera Access Required' : 'Camera Unavailable',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage ?? 'Unable to start the front camera.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _initializeFrontCamera,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter that draws a dark dimmed backdrop with an oval face cutout in the middle
class FaceFramingOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.45)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final ovalWidth = size.width * 0.72;
    final ovalHeight = size.height * 0.48;
    final center = Offset(size.width / 2, size.height * 0.42);
    final ovalRect = Rect.fromCenter(
      center: center,
      width: ovalWidth,
      height: ovalHeight,
    );

    // Create a path covering the full screen and subtract the oval
    final fullScreenPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final ovalPath = Path()..addOval(ovalRect);

    final combinedPath = Path.combine(
      PathOperation.difference,
      fullScreenPath,
      ovalPath,
    );

    canvas.drawPath(combinedPath, backgroundPaint);
    canvas.drawOval(ovalRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
