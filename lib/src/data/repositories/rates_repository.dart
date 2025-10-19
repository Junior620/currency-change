/// ============================================================================
/// RATES REPOSITORY
/// ============================================================================
///
/// Repository gérant l'accès aux taux de change avec cache et gestion d'erreurs.
///
/// Architecture :
/// - Couche d'abstraction entre l'API et le reste de l'application
/// - Gestion du cache pour réduire les appels API
/// - Gestion des erreurs avec des Failures typées
/// - Support du mode offline avec cache périmé
///
/// Stratégie de cache :
/// 1. Vérifier si les données sont en cache et fraîches
/// 2. Si oui, retourner le cache
/// 3. Si non, appeler l'API
/// 4. Sauvegarder la réponse en cache
/// 5. En cas d'erreur API, retourner le cache périmé si disponible
///
/// Utilisation :
/// ```dart
/// final repo = RatesRepository(api: api, cache: cache);
/// final result = await repo.getLatestRate(from: 'USD', to: 'EUR');
/// print('Taux: ${result.rate.rate} (cache: ${result.fromCache})');
/// ```
/// ============================================================================

import 'dart:convert';
import 'package:fxnow/src/core/errors/failures.dart';
import 'package:fxnow/src/data/api/rates_api.dart';
import 'package:fxnow/src/data/cache/cache_service.dart';
import 'package:fxnow/src/data/models/exchange_rate.dart';
import 'package:fxnow/src/data/models/rate_point.dart';

/// Repository pour la gestion des taux de change
///
/// Fournit une interface unifiée pour accéder aux taux de change
/// en gérant le cache et les appels API de manière transparente.
class RatesRepository {
  RatesRepository({
    required RatesApi api,
    required CacheService cache,
  })  : _api = api,
        _cache = cache;

  final RatesApi _api;
  final CacheService _cache;

  /// Récupère le taux de change le plus récent avec gestion du cache
  ///
  /// @param from : Code de la devise source (ex: 'USD')
  /// @param to : Code de la devise cible (ex: 'EUR')
  /// @return Record contenant le taux et un flag indiquant si c'est du cache
  /// @throws NetworkFailure : En cas d'erreur réseau
  /// @throws RateLimitFailure : Si la limite d'API est atteinte
  /// @throws ParseFailure : Si la réponse est invalide
  Future<({ExchangeRate rate, bool fromCache})> getLatestRate({
    required String from,
    required String to,
  }) async {
    // Si les devises sont identiques, retourne 1.0
    if (from == to) {
      return (
        rate: ExchangeRate(
          rate: 1.0,
          timestamp: DateTime.now(),
          fromCurrency: from,
          toCurrency: to,
        ),
        fromCache: false,
      );
    }

    // Essaie de récupérer depuis le cache d'abord
    final cached = _cache.getRate(from, to);
    if (cached != null) {
      return (rate: cached, fromCache: true);
    }

    // Récupère depuis l'API
    try {
      final response = await _api.getLatestRate(from: from, to: to);

      // Parse la réponse
      final rates = response['rates'] as Map<String, dynamic>?;
      if (rates == null || rates.isEmpty) {
        throw const ParseFailure('No rates in response');
      }

      final rateValue = (rates[to] as num).toDouble();
      final date = DateTime.parse(response['date'] as String);

      final rate = ExchangeRate(
        rate: rateValue,
        timestamp: date,
        fromCurrency: from,
        toCurrency: to,
      );

      // Sauvegarde en cache pour une utilisation ultérieure
      await _cache.saveRate(rate);

      return (rate: rate, fromCache: false);
    } catch (e) {
      if (e is AppFailure) rethrow;

      // En cas d'erreur, essaie de retourner un cache périmé
      final staleCache = _cache.getRate(from, to);
      if (staleCache != null) {
        return (rate: staleCache, fromCache: true);
      }

      throw _mapException(e);
    }
  }

  /// Récupère l'historique des taux de change
  ///
  /// @param from : Code de la devise source
  /// @param to : Code de la devise cible
  /// @param days : Nombre de jours d'historique à récupérer
  /// @return Liste de points représentant l'évolution du taux
  /// @throws NetworkFailure, RateLimitFailure, ParseFailure
  Future<List<RatePoint>> getHistoricalRates({
    required String from,
    required String to,
    required int days,
  }) async {
    // Si les devises sont identiques, retourne une ligne plate à 1.0
    if (from == to) {
      final now = DateTime.now();
      return List.generate(
        days,
        (i) => RatePoint(
          date: now.subtract(Duration(days: days - i - 1)),
          value: 1.0,
        ),
      );
    }

    // Vérifie le cache
    final cached = _cache.getHistory(from, to);
    if (cached.isNotEmpty) {
      return cached;
    }

    // Récupère depuis l'API
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: days));

      final response = await _api.getHistoricalRates(
        from: from,
        to: to,
        startDate: startDate,
        endDate: endDate,
      );

      final parsedData = _parseHistoricalData(response, to);

      // Met en cache les données parsées
      await _cache.saveHistory(from, to, parsedData);

      return parsedData;
    } catch (e) {
      if (e is AppFailure) rethrow;
      throw _mapException(e);
    }
  }

  /// Parse les données historiques de l'API
  ///
  /// Convertit la structure de réponse API en liste de RatePoint
  /// triée par date croissante.
  List<RatePoint> _parseHistoricalData(Map<String, dynamic> data, String toCurrency) {
    final rates = data['rates'] as Map<String, dynamic>?;
    if (rates == null) return [];

    final points = <RatePoint>[];
    rates.forEach((dateStr, rateData) {
      final date = DateTime.parse(dateStr);
      final value = (rateData[toCurrency] as num).toDouble();
      points.add(RatePoint(date: date, value: value));
    });

    points.sort((a, b) => a.date.compareTo(b.date));
    return points;
  }

  /// Mappe les exceptions génériques vers des Failures typées
  ///
  /// Permet une gestion d'erreur plus précise dans l'UI
  AppFailure _mapException(Object e) {
    final message = e.toString();
    if (message.contains('Network error')) {
      return NetworkFailure(message);
    } else if (message.contains('Rate limit')) {
      return RateLimitFailure(message);
    } else if (message.contains('parse') || message.contains('Parse')) {
      return ParseFailure(message);
    } else {
      return UnknownFailure(message);
    }
  }
}
