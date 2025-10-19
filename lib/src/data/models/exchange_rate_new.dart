/// ============================================================================
/// EXCHANGE RATE MODEL
/// ============================================================================
/// 
/// Modèle de données représentant un taux de change entre deux devises.
/// 
/// Caractéristiques :
/// - Immutable (toutes les propriétés sont final)
/// - Comparable (extends Equatable pour comparaison par valeur)
/// - Sérialisable (fromJson/toJson pour cache et API)
/// - Propriétés calculées (isLive, isStale)
/// 
/// Structure :
/// - rate : Valeur du taux de change
/// - timestamp : Date/heure de récupération du taux
/// - fromCurrency : Devise source (ex: 'USD')
/// - toCurrency : Devise cible (ex: 'EUR')
/// 
/// Utilisation :
/// ```dart
/// final rate = ExchangeRate(
///   rate: 0.92,
///   timestamp: DateTime.now(),
///   fromCurrency: 'USD',
///   toCurrency: 'EUR',
/// );
/// 
/// if (rate.isLive) {
///   print('Taux en direct : ${rate.rate}');
/// }
/// ```
/// ============================================================================

import 'package:equatable/equatable.dart';

/// Modèle représentant un taux de change entre deux devises
/// 
/// Classe immutable qui contient toutes les informations nécessaires
/// pour représenter un taux de change à un instant donné.
/// 
/// Extends Equatable pour permettre la comparaison par valeur au lieu
/// de la comparaison par référence.
class ExchangeRate extends Equatable {
  const ExchangeRate({
    required this.rate,
    required this.timestamp,
    required this.fromCurrency,
    required this.toCurrency,
  });

  /// Valeur du taux de change
  /// 
  /// Exemple : 0.92 signifie que 1 USD = 0.92 EUR
  final double rate;
  
  /// Date et heure de récupération du taux
  /// 
  /// Permet de déterminer si le taux est frais ou périmé
  final DateTime timestamp;
  
  /// Code ISO de la devise source (ex: 'USD')
  final String fromCurrency;
  
  /// Code ISO de la devise cible (ex: 'EUR')
  final String toCurrency;

  /// Propriétés utilisées pour la comparaison d'égalité
  /// 
  /// Deux ExchangeRate sont égaux si toutes ces propriétés sont égales
  @override
  List<Object?> get props => [rate, timestamp, fromCurrency, toCurrency];

  /// Vérifie si le taux est "en direct" (très récent)
  /// 
  /// Un taux est considéré comme "live" s'il a moins de 2 minutes.
  /// Utilisé pour afficher un indicateur visuel dans l'UI.
  /// 
  /// @return true si le taux a moins de 2 minutes, false sinon
  bool get isLive {
    final now = DateTime.now();
    return now.difference(timestamp) < const Duration(minutes: 2);
  }

  /// Vérifie si le taux est périmé
  /// 
  /// Un taux est considéré comme "stale" s'il a plus de 10 minutes.
  /// Utilisé pour décider s'il faut rafraîchir automatiquement.
  /// 
  /// @return true si le taux a plus de 10 minutes, false sinon
  bool get isStale {
    final now = DateTime.now();
    return now.difference(timestamp) > const Duration(minutes: 10);
  }

  /// Crée une instance depuis un objet JSON
  /// 
  /// Utilisé pour désérialiser depuis le cache ou l'API.
  /// 
  /// @param json : Map contenant les données
  /// @return Instance d'ExchangeRate
  /// @throws FormatException : Si le format JSON est invalide
  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      rate: (json['rate'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      fromCurrency: json['fromCurrency'] as String,
      toCurrency: json['toCurrency'] as String,
    );
  }

  /// Convertit l'instance en objet JSON
  /// 
  /// Utilisé pour sérialiser vers le cache.
  /// 
  /// @return Map représentant l'objet en JSON
  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'timestamp': timestamp.toIso8601String(),
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
    };
  }
}

