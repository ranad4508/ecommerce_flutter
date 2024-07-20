import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class THelperFunctions {
  static Color? getColor(String value) {
    //Define your product specific colors here and it will math the attribute colors and show specific

    if (value == "Green") {
      return Colors.green;
    } else if (value == "Red") {
      return Colors.red;
    } else if (value == "Blue") {
      return Colors.blue;
    } else if (value == "Pink") {
      return Colors.pink;
    } else if (value == "Grey") {
      return Colors.grey;
    } else if (value == "Purple") {
      return Colors.purple;
    } else if (value == "Black") {
      return Colors.black;
    } else if (value == "White") {
      return Colors.white;
    } else if (value == "Brown") {
      return Colors.brown;
    } else if (value == "Teal") {
      return Colors.teal;
    } else if (value == "Indigo") {
      return Colors.indigo;
    } else if (value == "Silver") {
      return Colors.grey.shade300; // Approximation for silver
    } else if (value == "Gold") {
      return Colors.amber.shade700; // Approximation for gold
    } else if (value == "Rose Gold") {
      return Colors.pink.shade100; // Approximation for rose gold
    } else if (value == "Midnight Green") {
      return Colors.green.shade900; // Approximation for midnight green
    } else if (value == "Space Grey") {
      return Colors.grey.shade800; // Approximation for space grey
    } else if (value == "Jet Black") {
      return Colors.black; // Jet black is pure black
    } else if (value == "Matte Black") {
      return Colors.black87; // Slightly less intense black
    } else if (value == "Coral") {
      return Colors.deepOrange.shade300; // Approximation for coral
    } else if (value == "Lavender") {
      return Colors.purple.shade100; // Approximation for lavender
    } else if (value == "Champagne") {
      return Colors.amber.shade100; // Approximation for champagne
    } else if (value == "Graphite") {
      return Colors.grey.shade900; // Approximation for graphite
    } else if (value == "Ocean Blue") {
      return Colors.blue.shade700; // Approximation for ocean blue
    } else if (value == "Sunset Orange") {
      return Colors.deepOrange; // Approximation for sunset orange
    } else if (value == "Mint Green") {
      return Colors.green.shade200; // Approximation for mint green
    } else if (value == "Ceramic White") {
      return Colors.white; // Ceramic white is pure white
    } else if (value == "Stormy Grey") {
      return Colors.blueGrey; // Approximation for stormy grey
    } else {
      return null;
    }
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showArt(String title, String message) {
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              )
            ],
          );
        });
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(DateTime date,
      {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }
}
