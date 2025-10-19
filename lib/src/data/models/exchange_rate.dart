import 'package:equatable/equatable.dart';

class ExchangeRate extends Equatable {
  const ExchangeRate({
    required this.rate,
    required this.timestamp,
    required this.fromCurrency,
    required this.toCurrency,
  });

  final double rate;
  final DateTime timestamp;
  final String fromCurrency;
  final String toCurrency;

  @override
  List<Object?> get props => [rate, timestamp, fromCurrency, toCurrency];

  bool get isLive {
    final now = DateTime.now();
    return now.difference(timestamp) < const Duration(minutes: 2);
  }

  bool get isStale {
    final now = DateTime.now();
    return now.difference(timestamp) > const Duration(minutes: 10);
  }

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      rate: (json['rate'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      fromCurrency: json['fromCurrency'] as String,
      toCurrency: json['toCurrency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'timestamp': timestamp.toIso8601String(),
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
    };
  }
}

