/// ============================================================================
/// ENVIRONMENT CONFIGURATION
/// ============================================================================
///
/// Configuration centralisée de toutes les constantes d'environnement.
///
/// Ce fichier contient toutes les valeurs de configuration globales :
/// - URL de l'API
/// - Durées de timeout et cache
/// - Intervalles de rafraîchissement
/// - Limites et seuils
///
/// Avantages de centraliser la configuration :
/// - Un seul endroit pour modifier les valeurs
/// - Type-safe (erreurs de compilation si mal utilisé)
/// - Facilite les tests (possibilité de mock)
/// - Documentation claire des valeurs par défaut
///
/// Pour la production, ces valeurs pourraient être chargées depuis :
/// - Variables d'environnement système
/// - Fichiers de configuration (.env)
/// - Services de configuration cloud
///
/// Utilisation :
/// ```dart
/// final api = RatesApi(baseUrl: Env.apiBaseUrl);
/// final debouncer = Debouncer(duration: Env.searchDebounce);
/// ```
/// ============================================================================

/// Configuration d'environnement de l'application
///
/// Classe statique contenant toutes les constantes de configuration.
/// Les valeurs sont en const pour optimisation au compile-time.
class Env {
  /// URL de base de l'API Frankfurter
  ///
  /// API gratuite et open-source pour les taux de change.
  /// Documentation : https://www.frankfurter.app/docs/
  static const String apiBaseUrl = 'https://api.frankfurter.app';

  /// Durée de validité du cache
  ///
  /// Après cette durée, les données en cache sont considérées comme périmées
  /// et doivent être rafraîchies depuis l'API.
  ///
  /// Valeur : 10 minutes
  static const Duration cacheTimeout = Duration(minutes: 10);

  /// Intervalle de rafraîchissement automatique
  ///
  /// Si le rafraîchissement auto est activé, l'app récupère les nouveaux
  /// taux toutes les 60 secondes.
  ///
  /// Valeur : 60 secondes
  static const Duration autoRefreshInterval = Duration(seconds: 60);

  /// Délai de debounce pour la recherche
  ///
  /// Temps d'attente après la dernière frappe avant de déclencher
  /// une recherche. Évite les recherches inutiles pendant la saisie.
  ///
  /// Valeur : 300 millisecondes (0.3 seconde)
  static const Duration searchDebounce = Duration(milliseconds: 300);

  /// Nombre maximum de tentatives en cas d'échec
  ///
  /// Si une requête API échoue, l'app réessaiera jusqu'à 3 fois
  /// avant d'afficher une erreur à l'utilisateur.
  ///
  /// Valeur : 3 tentatives
  static const int maxRetries = 3;
}
