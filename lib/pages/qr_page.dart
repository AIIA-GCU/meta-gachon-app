import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:mata_gachon/config/app/_export.dart';
import '../widgets/popup_widgets.dart';
import '../widgets/small_widgets.dart';

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
            cutOutSize: ratio.width * 250, borderRadius: 12, borderLength: 0),
      ),

      /// Text
      Positioned(
          top: ratio.height * 165,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Text('Scan QR Code',
                style: EN.title1
                    .copyWith(color: Colors.white, letterSpacing: -0.32)),
            SizedBox(height: ratio.height * 20),
            Text('예약한 회의실의\nQR코드를 스캔해주세요!',
                textAlign: TextAlign.center,
                style: KR.parag2
                    .copyWith(color: Colors.white, letterSpacing: -0.32))
          ])),

      /// Button
      Positioned(
          bottom: ratio.height * 44,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                    foregroundColor: MGColor.brandPrimary,
                    backgroundColor: MGColor.brandTertiary,
                    fixedSize: Size(ratio.width * 48, ratio.width * 48)),
                icon: const Icon(MGIcon.cross)),
          )),

      /// lading
      if (loading) const ProgressScreen()
    ]));
  }

  /// QR 스캔했을 때
  Future<void> _onScannedQr(Barcode data) async {
    /// 로딩 시작
    setState(() => loading = true);

    /// QR 검증
    late String title;
    late bool valid;
    if (data.code == barcode) {
      title = "인증되었습니다!";
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
            onPressed: () => Navigator.pop(context))).then((_) async {
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
