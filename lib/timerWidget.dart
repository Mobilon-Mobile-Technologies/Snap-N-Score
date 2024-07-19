import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key, required this.controller});
  final CountdownController controller;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  var border = Colors.teal.shade50;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Submit Attendance"),
        Transform.scale(
          scale: 0.95,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: border, width: 5),
            ),
            child: Countdown(
              controller: widget.controller,
              seconds: 20,
              build: (BuildContext context, double time) {
                return Text(
                  time.toInt().toString(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.white),
                );
                
              },
              onFinished: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }
}
