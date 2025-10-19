/// ============================================================================
/// EXTENSIONS UTILITY
/// ============================================================================
/// 
/// Extensions Dart pour ajouter des fonctionnalités utilitaires aux types
/// de base et classes utilitaires personnalisées.
/// 
/// Contenu :
/// - Debouncer : Utilitaire pour limiter la fréquence d'exécution (recherche)
/// - StringExtensions : Extensions sur String (validation, nettoyage)
/// - DateTimeExtensions : Extensions sur DateTime (vérification de durée)
/// 
/// Utilisation :
/// ```dart
/// // Debouncer pour recherche
/// final debouncer = Debouncer(duration: Duration(milliseconds: 500));
/// debouncer.run(() => performSearch());
/// 
/// // String extensions
/// '123.45'.isNumeric; // true
/// 'Hello World'.withoutWhitespace; // 'HelloWorld'
/// 
/// // DateTime extensions
/// DateTime.now().isWithinDuration(Duration(minutes: 5)); // true
/// ```
/// ============================================================================

import 'dart:async';
import 'package:flutter/foundation.dart';

// ============================================================================
// DEBOUNCER UTILITY
// ============================================================================

/// Utilitaire pour limiter la fréquence d'exécution d'une fonction
/// 
/// Le Debouncer attend que l'utilisateur arrête d'appeler la fonction
/// pendant une certaine durée avant de l'exécuter réellement.
/// 
/// Cas d'usage typique : Recherche en temps réel
/// - L'utilisateur tape dans un champ de recherche
/// - Au lieu de faire une requête à chaque frappe
/// - On attend qu'il arrête de taper pendant X ms
/// 
/// Exemple :
/// ```dart
/// final debouncer = Debouncer(duration: Duration(milliseconds: 500));
/// 
/// TextField(
///   onChanged: (text) {
///     debouncer.run(() {
///       // Cette fonction ne s'exécutera que 500ms après
///       // la dernière frappe de l'utilisateur
///       performSearch(text);
///     });
///   },
/// )
/// ```
class Debouncer {
  Debouncer({required this.duration});

  /// Durée d'attente avant l'exécution
  final Duration duration;
  
  /// Timer interne (nullable car peut être annulé)
  Timer? _timer;

  /// Execute l'action après la durée spécifiée
  /// 
  /// Si appelé à nouveau avant la fin du délai, le timer est réinitialisé.
  /// 
  /// @param action : Fonction à exécuter après le délai
  void run(VoidCallback action) {
    _timer?.cancel(); // Annule le timer précédent s'il existe
    _timer = Timer(duration, action); // Démarre un nouveau timer
  }

  /// Nettoie les ressources (annule le timer en cours)
  /// 
  /// À appeler dans dispose() du widget pour éviter les fuites mémoire
  void dispose() {
    _timer?.cancel();
  }
}

// ============================================================================
// STRING EXTENSIONS
// ============================================================================

/// Extensions sur le type String pour validation et manipulation
extension StringExtensions on String {
  /// Vérifie si la chaîne est un nombre valide
  /// 
  /// @return true si la chaîne peut être parsée en double, false sinon
  /// 
  /// Exemples :
  /// ```dart
  /// '123'.isNumeric; // true
  /// '123.45'.isNumeric; // true
  /// 'abc'.isNumeric; // false
  /// '12.34.56'.isNumeric; // false
  /// ```
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  /// Supprime tous les espaces de la chaîne
  /// 
  /// @return Nouvelle chaîne sans espaces
  /// 
  /// Exemples :
  /// ```dart
  /// 'Hello World'.withoutWhitespace; // 'HelloWorld'
  /// '1 234 567'.withoutWhitespace; // '1234567'
  /// ```
  String get withoutWhitespace {
    return replaceAll(' ', '');
  }
}

// ============================================================================
// DATETIME EXTENSIONS
// ============================================================================

/// Extensions sur le type DateTime pour vérifications temporelles
extension DateTimeExtensions on DateTime {
  /// Vérifie si la date est dans une durée spécifiée depuis maintenant
  ///
  /// @param duration : Durée maximale depuis maintenant
  /// @return true si la différence avec maintenant est inférieure à duration
  ///
  /// Exemples :
  /// ```dart
  /// final now = DateTime.now();
  /// final fiveMinutesAgo = now.subtract(Duration(minutes: 5));
  ///
  /// fiveMinutesAgo.isWithinDuration(Duration(minutes: 10)); // true
  /// fiveMinutesAgo.isWithinDuration(Duration(minutes: 3)); // false
  /// ```
  bool isWithinDuration(Duration duration) {
    final now = DateTime.now();
    return now.difference(this) < duration;
  }
}

