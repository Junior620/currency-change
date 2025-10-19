/// ============================================================================
/// CACHE SERVICE
/// ============================================================================
///
/// Service de gestion du cache local avec SharedPreferences.
///
/// Responsabilités :
/// - Cache des taux de change avec timestamps
/// - Cache de l'historique des taux
/// - Stockage des préférences utilisateur (devise par défaut, thème, locale)
/// - Gestion des favoris
/// - Vérification de la fraîcheur du cache
///
/// Durée de vie du cache :
/// - Taux : 5 minutes (considéré comme frais)
/// - Historique : Permanent jusqu'à suppression manuelle
///
/// Utilisation :
/// ```dart
/// final cache = await CacheService.create();
/// await cache.saveRate(exchangeRate);
/// final rate = cache.getRate('USD', 'EUR');
/// ```
/// ============================================================================

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exchange_rate.dart';
import '../models/rate_point.dart';

/// Service de cache local utilisant SharedPreferences
///
/// Gère toutes les opérations de persistance locale pour l'application,
/// incluant les taux de change, l'historique et les préférences.
class CacheService {
  CacheService._(); // Constructeur privé pour pattern singleton

  // ========== Clés de cache ==========
  static const String _ratePrefix = 'rate_';
  static const String _historyPrefix = 'history_';
  static const String _favoritesKey = 'favorites';
  static const String _defaultCurrencyKey = 'default_currency';
  static const String _themeKey = 'theme';
  static const String _localeKey = 'locale';
  static const String _autoRefreshKey = 'auto_refresh';

  late final SharedPreferences _prefs;

  /// Initialise le service de cache
  ///
  /// Méthode factory asynchrone car SharedPreferences nécessite
  /// une initialisation asynchrone.
  ///
  /// @return Instance initialisée de CacheService
  static Future<CacheService> create() async {
    final service = CacheService._();
    service._prefs = await SharedPreferences.getInstance();
    return service;
  }

  // ========== Méthodes utilitaires ==========

  /// Génère la clé de cache pour un taux de change
  String _getRateKey(String from, String to) => '${_ratePrefix}${from}_$to';

  /// Génère la clé de cache pour l'historique
  String _getHistoryKey(String from, String to) => '${_historyPrefix}${from}_$to';

  // ========== Gestion des taux de change ==========

  /// Sauvegarde un taux de change en cache
  ///
  /// Stocke également un timestamp pour vérifier la fraîcheur.
  ///
  /// @param rate : Taux de change à sauvegarder
  Future<void> saveRate(ExchangeRate rate) async {
    final key = _getRateKey(rate.fromCurrency, rate.toCurrency);
    final json = jsonEncode(rate.toJson());
    await _prefs.setString(key, json);
    await _prefs.setInt('${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  /// Récupère un taux de change du cache
  ///
  /// @param from : Code de la devise source
  /// @param to : Code de la devise cible
  /// @return Taux de change si trouvé, null sinon
  ExchangeRate? getRate(String from, String to) {
    final key = _getRateKey(from, to);
    final json = _prefs.getString(key);

    if (json == null) return null;

    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      return ExchangeRate.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Vérifie si un taux de change est frais (moins de 5 minutes)
  ///
  /// @param from : Code de la devise source
  /// @param to : Code de la devise cible
  /// @return true si le taux a moins de 5 minutes, false sinon
  bool isRateFresh(String from, String to) {
    final key = _getRateKey(from, to);
    final timestamp = _prefs.getInt('${key}_timestamp');

    if (timestamp == null) return false;

    final age = DateTime.now().millisecondsSinceEpoch - timestamp;
    return age < (5 * 60 * 1000); // 5 minutes en millisecondes
  }

  // ========== Gestion des favoris ==========

  /// Sauvegarde la liste des devises favorites
  ///
  /// @param favorites : Liste des codes de devises favorites
  Future<void> saveFavorites(List<String> favorites) async {
    await _prefs.setStringList(_favoritesKey, favorites);
  }

  /// Récupère la liste des devises favorites
  ///
  /// @return Liste des codes de devises favorites (vide si aucun)
  List<String> getFavorites() {
    return _prefs.getStringList(_favoritesKey) ?? [];
  }

  // ========== Préférences utilisateur ==========

  /// Définit la devise par défaut
  Future<void> setDefaultCurrency(String currency) async {
    await _prefs.setString(_defaultCurrencyKey, currency);
  }

  /// Récupère la devise par défaut
  ///
  /// @return Code de devise (USD par défaut)
  String getDefaultCurrency() {
    return _prefs.getString(_defaultCurrencyKey) ?? 'USD';
  }

  /// Définit le thème de l'application
  ///
  /// @param theme : 'light', 'dark' ou 'system'
  Future<void> setTheme(String theme) async {
    await _prefs.setString(_themeKey, theme);
  }

  /// Récupère le thème de l'application
  ///
  /// @return Thème ('system' par défaut)
  String getTheme() {
    return _prefs.getString(_themeKey) ?? 'system';
  }

  /// Définit la locale de l'application
  ///
  /// @param locale : Code de locale ('en', 'fr', etc.)
  Future<void> setLocale(String locale) async {
    await _prefs.setString(_localeKey, locale);
  }

  /// Récupère la locale de l'application
  ///
  /// @return Code de locale ('en' par défaut)
  String getLocale() {
    return _prefs.getString(_localeKey) ?? 'en';
  }

  /// Active/désactive le rafraîchissement automatique
  Future<void> setAutoRefresh(bool autoRefresh) async {
    await _prefs.setBool(_autoRefreshKey, autoRefresh);
  }

  /// Vérifie si le rafraîchissement automatique est activé
  ///
  /// @return true si activé (défaut), false sinon
  bool getAutoRefresh() {
    return _prefs.getBool(_autoRefreshKey) ?? true;
  }

  // ========== Gestion de l'historique ==========

  /// Sauvegarde l'historique des taux
  ///
  /// @param from : Code de la devise source
  /// @param to : Code de la devise cible
  /// @param history : Liste des points d'historique
  Future<void> saveHistory(String from, String to, List<RatePoint> history) async {
    final key = _getHistoryKey(from, to);
    final json = jsonEncode(history.map((point) => point.toJson()).toList());
    await _prefs.setString(key, json);
  }

  /// Récupère l'historique des taux
  ///
  /// @param from : Code de la devise source
  /// @param to : Code de la devise cible
  /// @return Liste des points d'historique (vide si aucun)
  List<RatePoint> getHistory(String from, String to) {
    final key = _getHistoryKey(from, to);
    final json = _prefs.getString(key);

    if (json == null) return [];

    try {
      final List<dynamic> data = jsonDecode(json);
      return data.map((item) => RatePoint.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // ========== Opérations de nettoyage ==========

  /// Supprime toutes les données du cache
  ///
  /// ⚠️ Attention : Supprime également les préférences utilisateur
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  /// Supprime uniquement le cache des taux
  ///
  /// Les préférences utilisateur sont conservées.
  Future<void> clearRates() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith(_ratePrefix));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  /// Supprime uniquement le cache de l'historique
  ///
  /// Les préférences utilisateur sont conservées.
  Future<void> clearHistory() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith(_historyPrefix));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
