import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_close_app/flutter_close_app.dart';
import 'package:rider_app/Pages/orders_page.dart';
import '../Model/categories.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int currentIndex = 0;
  List<CategoriesModel> allCats = [];
  bool isLoading = false;

  // Define your screens here

  navToHotDeal() {
    setState(() {
      currentIndex = 1;
    });
  }

  navToFlashSales() {
    setState(() {
      currentIndex = 2;
    });
  }

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return FlutterCloseAppPage(
      interval: 2,
      condition: true,
      onCloseFailed: () {
        // The interval is more than 2 seconds, or the return key is pressed for the first time
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Press again to exit'),
        ));
      },
      child: const Scaffold(
        body: OrdersPage(
                // navToHotDeal: navToHotDeal,
                // navToFlashSales: navToFlashSales,
                )
      ),
    );
  }
}
