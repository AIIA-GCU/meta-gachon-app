import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScaner extends StatefulWidget {
  const QrScaner({super.key});

  @override
  State<QrScaner> createState() => _QrScanerState();
}

class _QrScanerState extends State<QrScaner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();

    result = null;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  noneButton() {
    // 이전 화면으로 돌아가는 버튼
  }

  urlButton(result_input) {
    if (result != null) {
      final url = Uri.parse(result_input.code!);
      launchUrl(url);
      setState(() {
        result = null;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (result == null)
          ? Stack(
              children: <Widget>[
                Expanded(
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                        cutOutSize: 200,
                        borderColor: Theme.of(context)
                            .bottomNavigationBarTheme
                            .selectedIconTheme!
                            .color!),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 150),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Scan QR Code",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Text(
                        "예약한 회의실의\nQR코드를 스캔해주세요!",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      onPressed: noneButton(),
                      child: Text(
                        "X",
                        style: TextStyle(
                            color: Theme.of(context)
                                .bottomNavigationBarTheme
                                .selectedIconTheme!
                                .color!),
                      )),
                ),
              ],
            )
          : FutureBuilder(
              future: launchUrl(
                Uri.parse(result!.code!),
              ),
              builder: (context, snapshot) {
                return Stack(
                  children: <Widget>[
                    Expanded(
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                        overlay: QrScannerOverlayShape(
                            cutOutSize: 200,
                            borderColor: Theme.of(context)
                                .bottomNavigationBarTheme
                                .selectedIconTheme!
                                .color!),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 150),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Scan QR Code",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 30,
                              ),
                            ),
                          ),
                          Text(
                            "예약한 회의실의\nQR코드를 스캔해주세요!",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 50),
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: (result == null)
                            ? noneButton
                            : () => urlButton(result),
                        child: (result != null)
                            ? Text(
                                "Go",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .bottomNavigationBarTheme
                                        .selectedIconTheme!
                                        .color!),
                              )
                            : Text(
                                "X",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .bottomNavigationBarTheme
                                        .selectedIconTheme!
                                        .color!),
                              ),
                      ),
                    ),
                  ],
                );
                setState(() {
                  result = null;
                });
              },
            ),
    );
  }
}
