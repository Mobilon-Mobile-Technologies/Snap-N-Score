import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key});

  @override
  State<StatefulWidget> createState() {
    return _QRViewExampleState();
  }
}

class _QRViewExampleState extends State<QRViewExample> {
  bool actionTaken=false;
  bool showBottomSheet = false;
  bool? _checkboxValue = false;
  Barcode? result;
  QRViewController? controller;
  int lastScanned=0;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  //rk
  String? url;

  void _onQRViewCreated(QRViewController controller) {
    final studentid = supabase.auth.currentUser?.userMetadata?['user_id'];
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      int code = result!.code != null ? int.parse(result!.code!) : 0;
      

      if (await keyChecker(code)) {
        if (mounted) {
          if (result != null && !showBottomSheet) {
            showBottomSheet = true;
            // Show bottom sheet

            showModalBottomSheet(
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: ((context, setState) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 180,
                        width: Size.infinite.width,
                        child: Column(
                          children: [
                            const Text(
                              "Present ?",
                              style: TextStyle(fontSize: 25),
                            ),
                            Text(result!.code.toString()),
                            Checkbox(
                              value: _checkboxValue,
                              onChanged: (value) {
                                setState(() {
                                  _checkboxValue = value ?? false;
                                });
                              },
                            ),
                            // hardcodded
                            const SizedBox(
                              height: 27,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilledButton.tonal(
                                  onPressed: () async {
                                    showBottomSheet = false;
                                    Navigator.pop(context);
                                    if (_checkboxValue == true) {
                                      // getting keyId with the hep of key value
                                      final keyId = await supabase
                                          .from('keys_table')
                                          .select('key_id')
                                          .eq('key_value', code);
                                      print("KeyId: $keyId");
                                      await supabase
                                          .from('attendance_student')
                                          .insert({
                                        'student_id': studentid,
                                        'key_id': keyId[0]['key_id']
                                      });
                                    }
                                  },
                                  child: const Text("Submit"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                );
              },
            );
          }
        }
      }
      else{
        if(actionTaken==false){
          final sm=ScaffoldMessenger.of(context);
          sm.showSnackBar(SnackBar(content: Text("Invalid Qr"),backgroundColor: Colors.redAccent[100],));
          setState(() {
            actionTaken=true;
          });
        }
      }
    });
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        Center(
          child: Positioned(
            child: LottieBuilder.network(
              "https://lottie.host/ba4ec548-12cd-4d8c-a3c0-39d6f72b0b27/a9zrVvr615.json",
              width: 200,
              height: 200,
            ),
          ),
        ),
      ],
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

Future<bool> keyChecker(int code) async {
  final result =
      await Supabase.instance.client.from('keys_table').
      select('active').eq('key_value', code);
  print("code: $code");
  print("result: $result");

  if (result[0]['active'] == 1) {
    return true;
  }
  return false;
}
