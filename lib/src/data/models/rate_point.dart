
/// Modèle de données représentant un point dans l'historique des taux.
///
/// Utilisé pour :
/// - Afficher des graphiques d'évolution des taux
/// - Stocker l'historique des taux de change
/// - Analyser les tendances
///
/// Structure simple :
/// - date : Date du point de données
/// - value : Valeur du taux à cette date
///
/// Caractéristiques :
/// - Immutable (propriétés final)
/// - Comparable (extends Equatable)
/// - Sérialisable (fromJson/toJson)
///
/// Utilisation :
/// ```dart
/// final point = RatePoint(
///   date: DateTime(2024, 1, 15),
///   value: 0.92,
/// );
///
/// // Pour un graphique
/// final points = [
///   RatePoint(date: DateTime(2024, 1, 1), value: 0.90),
///   RatePoint(date: DateTime(2024, 1, 2), value: 0.91),
///   RatePoint(date: DateTime(2024, 1, 3), value: 0.92),
/// ];
/// ```
/// ============================================================================

import 'package:equatable/equatable.dart';

/// Modèle représentant un point de données dans l'historique des taux
///
/// Classe simple et immutable qui représente la valeur d'un taux de change
/// à une date donnée. Utilisée principalement pour l'affichage de graphiques
/// et l'analyse de l'évolution des taux dans le temps.
///
/// Extends Equatable pour faciliter la comparaison et le tri des points.
class RatePoint extends Equatable {
  const RatePoint({
    required this.date,
    required this.value,
  });

  /// Date du point de données
  ///
  /// Représente le moment où ce taux était valide
  final DateTime date;

  /// Valeur du taux de change à cette date
  ///
  /// Exemple : 0.92 pour un taux USD vers EUR
  final double value;

  /// Propriétés utilisées pour la comparaison d'égalité
  ///
  /// Deux RatePoint sont égaux si leur date et valeur sont égales
  @override
  List<Object?> get props => [date, value];

  /// Crée une instance depuis un objet JSON
  ///
  /// Utilisé pour désérialiser depuis le cache ou l'API.
  ///
  /// @param json : Map contenant les données
  /// @return Instance de RatePoint
  /// @throws FormatException : Si le format JSON est invalide
  ///
  /// Format attendu :
  /// ```json
  /// {
  ///   "date": "2024-01-15T00:00:00.000Z",
  ///   "value": 0.92
  /// }
  /// ```
  factory RatePoint.fromJson(Map<String, dynamic> json) {
    return RatePoint(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
    );
  }

  /// Convertit l'instance en objet JSON
  ///
  /// Utilisé pour sérialiser vers le cache.
  ///
  /// @return Map représentant l'objet en JSON
  ///
  /// Format produit :
  /// ```json
  /// {
  ///   "date": "2024-01-15T00:00:00.000Z",
  ///   "value": 0.92
  /// }
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'value': value,
    };
  }
}
