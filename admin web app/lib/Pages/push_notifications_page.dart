import 'package:admin_web_app/Widget/push_notifications_datatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widget/add_push_notifications.dart';



class PushNotificationPage extends StatefulWidget {
  const PushNotificationPage({super.key});

  @override
  State<PushNotificationPage> createState() => _PushNotificationPageState();
}

class _PushNotificationPageState extends State<PushNotificationPage> {
  @override
  void initState() {
    super.initState();
  }

  bool? loggedIn;

  getSelectedRoute() {
    Future.delayed(const Duration(seconds: 2), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool? repeat = prefs.getBool('logged in');
      setState(() {
        loggedIn = repeat;
      });
      if (repeat == false || repeat == null) {
        // ignore: use_build_context_synchronously
        context.go('/login');
        // ignore: avoid_print
        print('Repeat is $repeat');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getSelectedRoute();
    return  Scaffold(
       floatingActionButtonLocation:MediaQuery.of(context).size.width >= 1100? FloatingActionButtonLocation.endTop:FloatingActionButtonLocation.endDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (builder) {
                        return const AddPushNotification();
                      });
                },
                child: const Icon(Icons.add),
              ),
            ),
      body: const SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: PushNotificationsData(),
            ),
          ],
        ),
      ),
    );
  }
}
