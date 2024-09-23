import 'package:flutter/material.dart';

class CounterNotifier extends ValueNotifier<bool> {
  CounterNotifier({bool? value}) : super(value ?? false);

  void isLoggedTrue() {
    true;
  }

  void isLoggedFalse() {
    false;
  }
}
