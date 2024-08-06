import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Entry point of flutteFuture<void>p
Future<void> main() async {
  //TODO: Add widgets binding
  //TODO: Init local storage
  //TODO: Await native splash
  //TODO: Initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then(
      (FirebaseApp value)=>Get.put(AuthenticationRepository()),
  );
  //TODO: Initialize Authentication

  //Load all the Material Design / Themes / Localizations / Bindings
  runApp(const App());
}
