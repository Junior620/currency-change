import 'dart:async';
import 'package:flutter/foundation.dart';

/// Debouncer utility for search
class Debouncer {
  Debouncer({required this.duration});

  final Duration duration;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

/// Extension on String for validation
extension StringExtensions on String {
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  String get withoutWhitespace {
    return replaceAll(' ', '');
  }
}

/// Extension on DateTime
extension DateTimeExtensions on DateTime {
  bool isWithinDuration(Duration duration) {
    final now = DateTime.now();
    return now.difference(this) < duration;
  }
}

