// ignore_for_file: file_names
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

class IsLoggedWidget extends StatelessWidget {
  const IsLoggedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/image/login-icon.png',
              height: MediaQuery.of(context).size.width >= 1100
                  ? MediaQuery.of(context).size.height / 1.8
                  : MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width >= 1100
                  ? MediaQuery.of(context).size.height / 1.8
                  : MediaQuery.of(context).size.height / 2,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 45, 42, 42)),
                  onPressed: () {
                    context.go('/login');
                  },
                  child: const Text('Login to continue').tr()),
            )
          ],
        ),
      ),
    );
  }
}
