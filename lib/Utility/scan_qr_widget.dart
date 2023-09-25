import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

late String _label;
late Function(String result) _resultCallback;

///
/// AppBarcodeScannerWidget
class AppBarcodeScannerWidget extends StatefulWidget {
  final bool openManual;

  ///
  ///
  AppBarcodeScannerWidget.defaultStyle({
    super.key,
    Function(String result)? resultCallback,
    this.openManual = false,
    String label = '',
  }) {
    _resultCallback = resultCallback ?? (String result) {};
    _label = label;
  }

  @override
  State<AppBarcodeScannerWidget> createState() => _AppBarcodeState();
}

class _AppBarcodeState extends State<AppBarcodeScannerWidget> {
  bool _isGranted = false;

  bool _useCameraScan = true;

  bool _openManual = false;

  String _inputValue = "";

  @override
  void initState() {
    super.initState();

    _openManual = widget.openManual;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TargetPlatform platform = Theme.of(context).platform;
      if (!kIsWeb) {
        if (platform == TargetPlatform.android ||
            platform == TargetPlatform.iOS) {
          _requestMobilePermission();
        } else {
          setState(() {
            _isGranted = true;
          });
        }
      } else {
        setState(() {
          _isGranted = true;
        });
      }
    });
  }

  void _requestMobilePermission() async {
    bool isGrated = false;
    if (await Permission.camera.status.isGranted) {
      isGrated = true;
    } else {
      if (await Permission.camera.request().isGranted) {
        isGrated = true;
      }
    }
    setState(() {
      _isGranted = isGrated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _isGranted
              ? _useCameraScan
                  ? _BarcodeScannerWidget()
                  : _BarcodeInputWidget.defaultStyle(
                      changes: (String value) {
                        _inputValue = value;
                      },
                    )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset("assets/permission.png",
                          width: MediaQuery.of(context).size.width * 40 / 100),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Please grant permission to the camera\nto proceed on your QR scan",
                        style: TextStyle(fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 70 / 100,
                        child: OutlinedButton(
                          onPressed: () {
                            AppSettings.openAppSettings();
                            Navigator.pop(context);
                          },
                          child: const Text("Request Permission"),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        _openManual
            ? _useCameraScan
                ? OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _useCameraScan = false;
                      });
                    },
                    child: Text("手动输入$_label"),
                  )
                : Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _useCameraScan = true;
                          });
                        },
                        child: Text("扫描$_label"),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          _resultCallback(_inputValue);
                        },
                        child: const Text("确定"),
                      ),
                    ],
                  )
            : Container(),
      ],
    );
  }
}

class _BarcodeInputWidget extends StatefulWidget {
  late final ValueChanged<String> changes;

  _BarcodeInputWidget.defaultStyle({
    required ValueChanged<String> changes,
  }) {
    changes = changes;
  }

  @override
  State<StatefulWidget> createState() {
    return _BarcodeInputState();
  }
}

class _BarcodeInputState extends State<_BarcodeInputWidget> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(8)),
        Row(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(8)),
            Text(
              "$_label：",
            ),
            Expanded(
              child: TextFormField(
                controller: _controller,
                onChanged: widget.changes,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
          ],
        ),
        const Padding(padding: EdgeInsets.all(8)),
      ],
    );
  }
}

///ScannerWidget
class _BarcodeScannerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppBarcodeScannerWidgetState();
  }
}

class _AppBarcodeScannerWidgetState extends State<_BarcodeScannerWidget> {
  late ScannerController _scannerController;

  @override
  void initState() {
    super.initState();

    _scannerController = ScannerController(scannerResult: (result) {
      _resultCallback(result);
    }, scannerViewCreated: () {
      TargetPlatform platform = Theme.of(context).platform;
      if (TargetPlatform.iOS == platform) {
        Future.delayed(const Duration(seconds: 2), () {
          _scannerController.startCamera();
          _scannerController.startCameraPreview();
        });
      } else {
        _scannerController.startCamera();
        _scannerController.startCameraPreview();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scannerController.stopCameraPreview();
    _scannerController.stopCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _getScanWidgetByPlatform(),
        ),
      ],
    );
  }

  Widget _getScanWidgetByPlatform() {
    return PlatformAiBarcodeScannerWidget(
      platformScannerController: _scannerController,
    );
  }
}
