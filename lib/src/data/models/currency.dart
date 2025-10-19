/// ============================================================================
/// CURRENCY MODEL
/// ============================================================================
///
/// Modèle de données pour une devise avec persistance Hive.
///
/// Ce modèle représente une devise complète avec :
/// - Code ISO (ex: 'USD', 'EUR')
/// - Nom complet (ex: 'US Dollar')
/// - Chemin vers l'icône du drapeau
///
/// Caractéristiques :
/// - Persistance Hive (@HiveType) pour stockage local rapide
/// - Immutable (propriétés final)
/// - Comparable (extends Equatable)
/// - Sérialisable JSON (fromJson/toJson)
///
/// Note : Ce modèle nécessite la génération de code Hive :
/// ```bash
/// flutter pub run build_runner build
/// ```
///
/// Utilisation :
/// ```dart
/// final usd = Currency(
///   code: 'USD',
///   name: 'US Dollar',
///   flagAsset: 'assets/flags/usd.png',
/// );
///
/// // Stockage Hive
/// final box = await Hive.openBox<Currency>('currencies');
/// await box.put('USD', usd);
/// ```
/// ============================================================================

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'currency.g.dart';

/// Modèle représentant une devise complète
///
/// Classe immutable avec support de persistance Hive pour un
/// stockage local rapide et efficace.
///
/// @HiveType identifie cette classe pour Hive (typeId: 0)
@HiveType(typeId: 0)
class Currency extends Equatable {
  const Currency({
    required this.code,
    required this.name,
    required this.flagAsset,
  });

  /// Code ISO 4217 de la devise
  ///
  /// Exemples : 'USD', 'EUR', 'GBP', 'JPY'
  /// @HiveField(0) indique que c'est le premier champ à persister
  @HiveField(0)
  final String code;

  /// Nom complet de la devise
  ///
  /// Exemples : 'US Dollar', 'Euro', 'British Pound'
  /// @HiveField(1) indique que c'est le deuxième champ à persister
  @HiveField(1)
  final String name;

  /// Chemin vers l'asset de l'icône/drapeau
  ///
  /// Exemple : 'assets/flags/usd.png'
  /// @HiveField(2) indique que c'est le troisième champ à persister
  @HiveField(2)
  final String flagAsset;

  /// Propriétés utilisées pour la comparaison d'égalité
  ///
  /// Deux Currency sont égales si toutes ces propriétés sont égales
  @override
  List<Object?> get props => [code, name, flagAsset];

  /// Crée une instance depuis un objet JSON
  ///
  /// Utilisé pour désérialiser depuis une API ou un fichier.
  ///
  /// @param json : Map contenant les données
  /// @return Instance de Currency
  ///
  /// Format attendu :
  /// ```json
  /// {
  ///   "code": "USD",
  ///   "name": "US Dollar",
  ///   "flagAsset": "assets/flags/usd.png"
  /// }
  /// ```
  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] as String,
      name: json['name'] as String,
      flagAsset: json['flagAsset'] as String,
    );
  }

  /// Convertit l'instance en objet JSON
  ///
  /// Utilisé pour sérialiser vers une API ou un fichier.
  ///
  /// @return Map représentant l'objet en JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'flagAsset': flagAsset,
    };
  }
}
