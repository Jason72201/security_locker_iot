import 'package:flutter/material.dart';
import 'package:security_locker_iot/Utility/scan_qr_widget.dart';
import 'package:security_locker_iot/homapage.dart';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<ScanQRPage> createState() => _ScanQRPage();
}

class _ScanQRPage extends State<ScanQRPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Scan QR To Continue"),
                content: const Text(
                    'You will need to scan your locker QR Code to continue on proceeding this app'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text("Scan Locker QR"),
      // ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: AppBarcodeScannerWidget.defaultStyle(
              resultCallback: (String result) {
                if (result.contains("yGCZLiD8yD4XAGR0mjSO7")) {
                  if (mounted) {
                    setState(() {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                        (Route<dynamic> route) => false,
                      );
                    });
                  }
                } else {
                  // GeneralUtils.showToast(
                  //     "Please scan the correct warranty card's QR code..");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
