import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final darkTheme = ThemeData(
        // fontFamily: 'Robot',
        useMaterial3: false,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        indicatorColor: Colors.white,
        primaryColor: const Color(0xFF362F2F),
        brightness: Brightness.dark,
        cardColor: Colors.black12,
        dividerColor: Colors.black12,
        textTheme: GoogleFonts.openSansTextTheme(
            const TextTheme(titleLarge: TextStyle(fontSize: 14))),
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.blue, brightness: Brightness.dark)
            .copyWith(secondary: Colors.white)
            .copyWith(background: const Color(0xFF1D1B1B)))
    .copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
  },
));

final lightTheme = ThemeData(
        useMaterial3: false,
        indicatorColor: Colors.black,
        cardColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        primaryColor: Colors.white,
        brightness: Brightness.light,
        dividerColor: Colors.white54,
        textTheme: GoogleFonts.openSansTextTheme(
            const TextTheme(titleLarge: TextStyle(fontSize: 14))),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.black)
            .copyWith(background: Colors.white))
    .copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
  },
));
