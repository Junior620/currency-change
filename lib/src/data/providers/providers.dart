
/// Définition de tous les providers Riverpod pour la gestion d'état globale.
///
///
/// Providers disponibles :
///
/// SERVICES :
/// - cacheServiceProvider : Service de cache local
/// - ratesApiProvider : Client API pour les taux
/// - ratesRepositoryProvider : Repository avec cache
///
/// PRÉFÉRENCES :
/// - defaultCurrencyProvider : Devise par défaut
/// - themeProvider : Thème de l'app (light/dark/system)
/// - localeProvider : Langue de l'app (en/fr)
/// - autoRefreshProvider : Rafraîchissement auto activé/désactivé
///
/// FAVORIS :
/// - favoritesProvider : Liste des devises favorites
///
/// Utilisation :
/// ```dart
/// // Dans un widget
/// final cache = ref.watch(cacheServiceProvider);
/// final theme = ref.watch(themeProvider);
///
/// // Modifier un state
/// ref.read(themeProvider.notifier).state = 'dark';
/// ```
/// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fxnow/src/data/api/rates_api.dart';
import 'package:fxnow/src/data/cache/cache_service.dart';
import 'package:fxnow/src/data/repositories/rates_repository.dart';

// ============================================================================
// SERVICES PROVIDERS
// ============================================================================

/// Provider du service de cache
///
/// Ce provider doit être overridé dans main() avec une instance réelle :
/// ```dart
/// ProviderScope(
///   overrides: [
///     cacheServiceProvider.overrideWithValue(await CacheService.create()),
///   ],
///   child: MyApp(),
/// )
/// ```
final cacheServiceProvider = Provider<CacheService>((ref) {
  throw UnimplementedError('CacheService must be overridden in main()');
});

/// Provider du client API pour les taux de change
///
/// Crée une instance de RatesApi avec configuration Dio par défaut
final ratesApiProvider = Provider<RatesApi>((ref) {
  return RatesApi();
});

/// Provider du repository des taux de change
///
/// Combine l'API et le cache pour fournir une interface unifiée
/// avec gestion automatique du cache et des erreurs
final ratesRepositoryProvider = Provider<RatesRepository>((ref) {
  final api = ref.watch(ratesApiProvider);
  final cache = ref.watch(cacheServiceProvider);

  return RatesRepository(
    api: api,
    cache: cache,
  );
});

// ============================================================================
// SETTINGS PROVIDERS (Préférences utilisateur)
// ============================================================================

/// Provider de la devise par défaut
///
/// Initialisé depuis le cache, peut être modifié avec :
/// ```dart
/// ref.read(defaultCurrencyProvider.notifier).state = 'EUR';
/// ```
final defaultCurrencyProvider = StateProvider<String>((ref) {
  final cache = ref.watch(cacheServiceProvider);
  return cache.getDefaultCurrency();
});

/// Provider du thème de l'application
///
/// Valeurs possibles : 'light', 'dark', 'system'
/// ```dart
/// ref.read(themeProvider.notifier).state = 'dark';
/// ```
final themeProvider = StateProvider<String>((ref) {
  final cache = ref.watch(cacheServiceProvider);
  return cache.getTheme();
});

/// Provider de la locale (langue) de l'application
///
/// Valeurs possibles : 'en', 'fr'
/// ```dart
/// ref.read(localeProvider.notifier).state = 'fr';
/// ```
final localeProvider = StateProvider<String>((ref) {
  final cache = ref.watch(cacheServiceProvider);
  return cache.getLocale();
});

/// Provider du mode rafraîchissement automatique
///
/// Si true, les taux sont rafraîchis automatiquement
/// ```dart
/// ref.read(autoRefreshProvider.notifier).state = false;
/// ```
final autoRefreshProvider = StateProvider<bool>((ref) {
  final cache = ref.watch(cacheServiceProvider);
  return cache.getAutoRefresh();
});

// ============================================================================
// FAVORITES PROVIDER
// ============================================================================

/// Provider de la liste des devises favorites
///
/// Utilise un StateNotifier pour gérer l'ajout/suppression de favoris
/// avec persistance automatique dans le cache.
///
/// Utilisation :
/// ```dart
/// // Récupérer la liste
/// final favorites = ref.watch(favoritesProvider);
///
/// // Ajouter/supprimer un favori
/// ref.read(favoritesProvider.notifier).toggle('EUR');
///
/// // Vérifier si c'est un favori
/// final isFav = ref.read(favoritesProvider.notifier).isFavorite('USD');
/// ```
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  final cache = ref.watch(cacheServiceProvider);
  return FavoritesNotifier(cache);
});

// ============================================================================
// FAVORITES NOTIFIER
// ============================================================================

/// StateNotifier pour gérer la liste des devises favorites
///
/// Persiste automatiquement les changements dans le cache.
class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier(this._cache) : super(_cache.getFavorites());

  final CacheService _cache;

  /// Ajoute ou retire une devise des favoris
  ///
  /// Si la devise est déjà favorite, elle est retirée.
  /// Sinon, elle est ajoutée.
  ///
  /// @param currencyCode : Code de la devise (ex: 'USD')
  void toggle(String currencyCode) {
    if (state.contains(currencyCode)) {
      state = state.where((code) => code != currencyCode).toList();
    } else {
      state = [...state, currencyCode];
    }
    _cache.saveFavorites(state);
  }

  /// Vérifie si une devise est dans les favoris
  ///
  /// @param currencyCode : Code de la devise à vérifier
  /// @return true si la devise est favorite, false sinon
  bool isFavorite(String currencyCode) {
    return state.contains(currencyCode);
  }
}
