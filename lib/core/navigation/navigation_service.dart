import 'package:flutter/material.dart';

class NavigationService {
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  void setIndex(int index) {
    currentIndex.value = index;
  }
}
