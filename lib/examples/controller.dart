import 'dart:math';

import 'package:flutter/material.dart';

class ControllerState {
  final bool isLoading;
  final List<Color>? colors;
  final bool isError;

  ControllerState({
    this.isLoading = false,
    this.colors,
    this.isError = false,
  });
}

class ScreenController extends ValueNotifier<ControllerState> {
  ScreenController() : super(ControllerState(colors: []));

  Future<void> simulateRequest({required int length}) async {
    value = ControllerState(isLoading: true);
    final List<Color> colors = List<Color>.generate(
      length,
      (index) => Colors.primaries[Random().nextInt(
        Colors.primaries.length,
      )],
    );
    await Future.delayed(const Duration(seconds: 1));
    value = ControllerState(colors: colors);
  }
}
