import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class TimerBasic extends StatefulWidget {
  final CountDownTimerFormat format;
  final bool inverted;

  const TimerBasic({
    required this.format,
    this.inverted = false,
    super.key,
  });

  @override
  State<TimerBasic> createState() => _TimerBasicState();
}

class _TimerBasicState extends State<TimerBasic> {
  String flashSales = '';

  getFlashSalesTime() {
    FirebaseFirestore.instance
        .collection('Flash Sales Time')
        .doc('Flash Sales Time')
        .snapshots()
        .listen((event) {
      setState(() {
        flashSales = event['Flash Sales Time'];
      });
    });
  }

  @override
  void initState() {
    getFlashSalesTime();
    super.initState();
  }

  Future<void> deleteAllDocumentsInCollection(String collectionPath) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(collectionPath);

    QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await collectionReference.doc(documentSnapshot.id).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Parse the string into a DateTime object
    DateTime targetDate = DateTime.parse(flashSales);

    // Calculate the difference between the target date and the current date
    DateTime currentDate = DateTime.now();
    Duration difference = targetDate.difference(currentDate);
    return TimerCountdown(
      format: widget.format,
      endTime: DateTime.now().add(difference),
      onEnd: () {
        deleteAllDocumentsInCollection('Flash Sales');
      },
      timeTextStyle: TextStyle(
        color: (widget.inverted)
            ? CupertinoColors.activeOrange
            : CupertinoColors.white,
        fontWeight: FontWeight.w300,
        fontSize: 40,
        fontFeatures: const <FontFeature>[
          FontFeature.tabularFigures(),
        ],
      ),
      colonsTextStyle: TextStyle(
        color: (widget.inverted)
            ? CupertinoColors.activeOrange
            : CupertinoColors.white,
        fontWeight: FontWeight.w300,
        fontSize: 40,
        fontFeatures: const <FontFeature>[
          FontFeature.tabularFigures(),
        ],
      ),
      descriptionTextStyle: TextStyle(
        color: (widget.inverted)
            ? CupertinoColors.activeOrange
            : CupertinoColors.white,
        fontSize: 10,
        fontFeatures: const <FontFeature>[
          FontFeature.tabularFigures(),
        ],
      ),
      spacerWidth: 5,
      daysDescription: "days",
      hoursDescription: "hours",
      minutesDescription: "minutes",
      secondsDescription: "seconds",
    );
  }
}
