import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/common/Background.dart';

class QrScanner extends StatefulWidget {
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  GlobalKey qrKey = GlobalKey();
  QRViewController controller;
  String qrCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
      Background(),
      Column(
        children: <Widget>[
          SizedBox(height: 50),
          Text(
            tr("QRScanner.naslov"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: "Inter",
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: QRView(
                  key: qrKey,
                  overlay: QrScannerOverlayShape(
                    borderRadius: 10,
                    borderColor: Colors.white,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                  ),
                  onQRViewCreated: _onQRViewCreate),
            ),
          ),
          SizedBox(height: 30),
          InkWell(
              child: Container(
                width: 335,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xffffa234),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Text(
                  tr("QRScanner.unesiRucno"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {
                controller?.dispose();
                Navigator.pop(context, null);
              }),
          SizedBox(height: 30),
        ],
      ),
    ]));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onQRViewCreate(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCode = scanData.code;
      });
      controller?.dispose();
      Navigator.pop(context, qrCode);
    });
  }
}
