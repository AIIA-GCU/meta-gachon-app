import 'dart:async';
import 'dart:io' show Platform;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mata_gachon/config/variable.dart';
import 'package:mata_gachon/widget/popup.dart';
import 'package:mata_gachon/widget/small_widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.takenPictrue});

  final Function(String) takenPictrue;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}
class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            if (!mounted) return;

            await widget.takenPictrue(image.path);
            Navigator.pop(context);
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key, required this.onMatchedCode});

  final VoidCallback onMatchedCode;

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}
class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  late QRViewController _qrCtr;
  late bool loading;

  @override
  void initState() {
    super.initState();
    loading = false;
  }

  @override
  void reassemble() {
    super.reassemble();
    _qrCtr.resumeCamera();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (Platform.isAndroid) {
      _qrCtr.pauseCamera();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _qrCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        /// QR scanner
        QRView(
          key: _qrKey,
          onQRViewCreated: (ctr) {
            _qrCtr = ctr;
            ctr.scannedDataStream.listen((data) async {
              await _qrCtr.pauseCamera();
              _onScannedQr(data);
            });
          },
          overlay: QrScannerOverlayShape(
              cutOutSize: ratio.width * 250,
              borderRadius: 12,
              borderLength: 0
          ),
        ),

        /// Text
        Positioned(
            top: ratio.height * 165,
            width: MediaQuery.of(context).size.width,
            child: Column(
                children: [
                  Text(
                      'Scan QR Code',
                      style: EN.title1.copyWith(
                          color: Colors.white,
                          letterSpacing: -0.32
                      )
                  ),
                  SizedBox(height: ratio.height * 20),
                  Text(
                      '예약한 회의실의\nQR코드를 스캔해주세요!',
                      textAlign: TextAlign.center,
                      style: KR.parag2.copyWith(
                          color: Colors.white,
                          letterSpacing: -0.32
                      )
                  )
                ]
            )
        ),

        /// Button
        Positioned(
            bottom: ratio.height * 44,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                      foregroundColor: MGcolor.btn_active,
                      backgroundColor: MGcolor.btn_inactive,
                      fixedSize: Size(ratio.width * 48, ratio.width * 48)
                  ),
                  icon: Icon(AppinIcon.cross)
              ),
            )
        ),

        /// lading
        if (loading)
          ProgressScreen()
      ])
    );
  }

  /// QR 스캔했을 때
  Future<void> _onScannedQr(Barcode data) async {
    /// 로딩 시작
    setState(() => loading = true);

    /// QR 검증
    late String title;
    late bool valid;
    if (data.code == BARCODE) {
      title =  "인증되었습니다!";
      valid = true;
    } else {
      title = "올바른 QR 코드가 아닙니다!";
      valid = false;
    }

    /// 팝업 표시
    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (context) => CommentPopup(
        title: title,
        onPressed: () => Navigator.pop(context)
      )
    ).then((_) async {
      debugPrint('called');
      if (valid) {
        Navigator.pop(context);
        widget.onMatchedCode();
      } else {
        await _qrCtr.resumeCamera();
        setState(() => loading = false);
      }
    });
  }
}
