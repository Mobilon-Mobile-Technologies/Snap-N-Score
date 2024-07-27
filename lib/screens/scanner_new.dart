// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_scanner/main.dart';
import 'package:qr_scanner/timerWidget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timer_count_down/timer_controller.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  bool showBottomSheet = false;
  MobileScannerController? controller;
  var generatedby = '';
  var generatedTime = '';
  final studentid = supabase.auth.currentUser?.userMetadata?['user_id'];
  var submitted = false;

  int code = 0; // replace with your actual code
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.stop();
    }
    controller?.start();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AiBarcodeScanner(
        hideGalleryButton: true,
        hideSheetDragHandler: true,
        hideSheetTitle: true,
        controller: controller,
        onDetect: (BarcodeCapture capture) async {
          final String? result = capture.barcodes.first.rawValue;
          int code = result != null ? int.parse(result) : 0;
          if (await keyChecker(code)) {
            if (mounted) {
              if (result != null && !showBottomSheet) {
                showBottomSheet = true;
                showModalSheet(code);
              }
            }
          } else {
            final sm = ScaffoldMessenger.of(context);
            sm.showSnackBar(SnackBar(
              content: const Text("Invalid Qr"),
              backgroundColor: Colors.redAccent[100],
            ));
          }
        },
        onDispose: () {
          debugPrint("Barcode Scanner Destroyed");
        },
      ),
    );
  }

  Future<bool> keyChecker(int code) async {
    final result = await Supabase.instance.client
        .from('keys_table')
        .select('active')
        .eq('key_value', code);
    debugPrint("code: $code");
    debugPrint("result: $result");

    if (result[0]['active'] == 1) {
      return true;
    }
    return false;
  }

  Future getkeyDetails(int code) async {
    final keydetail = await supabase
        .from('keys_table')
        .select('*, faculty!inner(*)')
        .eq('key_value', code);
    debugPrint("Key_detail: $keydetail");
    debugPrint("testName: ${keydetail[0]['faculty']['name']}");

    generatedby = keydetail[0]['faculty']['name'];

    String timeStamp = keydetail[0]['generate_time'];
    String time = timeStamp.split('T')[1];
    time = time.split(".")[0];
    generatedTime = time;
    debugPrint("testDate: $time");
  }

  Future<Widget> showModalSheet(int code) async {
    await getkeyDetails(code);
    final CountdownController timerController = CountdownController(
      autoStart: true,
    );
    final screenSize = MediaQuery.of(context).size;
    return await showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: navigatorKey.currentContext ?? context,
      builder: (context) {
        return StatefulBuilder(
          builder: ((context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: screenSize.width * 0.05,
                left: screenSize.width * 0.05,
                right: screenSize.width * 0.05,
              ),
              child: SizedBox(
                height: screenSize.height * 0.25,
                width: Size.infinite.width,
                child: submitted
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: LottieBuilder.network(
                              "https://lottie.host/27139b65-a8d5-4d07-bb2c-58412d9d3a1b/l9vSYGpl91.json",
                              repeat: false,
                              height: screenSize.width * 0.35,
                              width: screenSize.width * 0.35,
                            ),
                          ),
                          FilledButton.tonal(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Done"))
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Mark Your attendance!",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("QR Generated By: $generatedby"),
                          Text("Date: $generatedTime"),
                          FilledButton(
                            onPressed: () async {
                              showBottomSheet = false;

                              // getting keyId with the hep of key value
                              final keyId = await supabase
                                  .from('keys_table')
                                  .select('key_id')
                                  .eq('key_value', code);
                              debugPrint("KeyId: $keyId");
                              await supabase.from('attendance_student').insert({
                                'student_id': studentid,
                                'key_id': keyId[0]['key_id']
                              });
                              setState(
                                () {
                                  submitted = true;
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: TimerWidget(controller: timerController),
                            ),
                          ),
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
