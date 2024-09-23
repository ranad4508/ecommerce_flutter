import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_app/Model/constant.dart';

 Color purple = appColor;

class TimerFrame extends StatelessWidget {
  final String description;
  final Widget timer;
  final bool inverted;

  const TimerFrame({
    required this.description,
    required this.timer,
    this.inverted = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        vertical: inverted ? 30 : 40,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: inverted ? CupertinoColors.white : purple,
        border: Border.all(
          width: 2,
          color: inverted ? purple : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Text(
            description,
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 0,
              color: inverted ? purple : CupertinoColors.white,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          timer,
        ],
      ),
    );
  }
}