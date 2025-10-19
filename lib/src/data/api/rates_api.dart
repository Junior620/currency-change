/// ============================================================================
/// RATES API CLIENT
/// ============================================================================
///
/// Client HTTP pour l'API Frankfurter (https://www.frankfurter.app/)
///
/// API Documentation :
/// - Base URL: https://api.frankfurter.app
/// - GET /latest?from=USD&to=EUR : Taux actuel
/// - GET /2024-01-01..2024-01-07?from=USD&to=EUR : Historique
/// - GET /currencies : Liste des devises disponibles
///
/// Caractéristiques :
/// - Configuration Dio avec timeouts
/// - Logging des requêtes/réponses
/// - Gestion d'erreurs typée
/// - Formatage automatique des dates
///
/// Utilisation :
/// ```dart
/// final api = RatesApi();
/// final data = await api.getLatestRate(from: 'USD', to: 'EUR');
/// print(data['rates']['EUR']);
/// ```
/// ============================================================================

import 'package:dio/dio.dart';
import 'package:fxnow/src/core/env/env.dart';

/// Client API pour les taux de change (Frankfurter API)
///
/// Gère toutes les communications HTTP avec l'API de taux de change
/// et fournit une interface typée pour les requêtes.
class RatesApi {
  RatesApi({Dio? dio}) : _dio = dio ?? _createDio();

  final Dio _dio;

  /// Crée et configure une instance Dio
  ///
  /// Configuration :
  /// - Base URL depuis les variables d'environnement
  /// - Timeouts de 10 secondes
  /// - Headers JSON
  /// - Intercepteur de logging
  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Ajoute un intercepteur pour logger les requêtes/réponses
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    return dio;
  }

  /// Récupère le taux de change actuel
  ///
  /// Endpoint : GET /latest?from=USD&to=EUR
  ///
  /// @param from : Code de la devise source (ex: 'USD')
  /// @param to : Code de la devise cible (ex: 'EUR')
  /// @return Map contenant les données de taux
  /// @throws Exception : En cas d'erreur réseau ou serveur
  ///
  /// Exemple de réponse :
  /// ```json
  /// {
  ///   "amount": 1.0,
  ///   "base": "USD",
  ///   "date": "2024-01-15",
  ///   "rates": {
  ///     "EUR": 0.92
  ///   }
  /// }
  /// ```
  Future<Map<String, dynamic>> getLatestRate({
    required String from,
    required String to,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/latest',
        queryParameters: {
          'from': from,
          'to': to,
        },
      );

      return response.data ?? {};
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Récupère l'historique des taux pour une période donnée
  ///
  /// Endpoint : GET /2024-01-01..2024-01-07?from=USD&to=EUR
  ///
  /// @param from : Code de la devise source
  /// @param to : Code de la devise cible
  /// @param startDate : Date de début de la période
  /// @param endDate : Date de fin de la période
  /// @return Map contenant l'historique des taux
  /// @throws Exception : En cas d'erreur
  ///
  /// Exemple de réponse :
  /// ```json
  /// {
  ///   "amount": 1.0,
  ///   "base": "USD",
  ///   "start_date": "2024-01-01",
  ///   "end_date": "2024-01-07",
  ///   "rates": {
  ///     "2024-01-01": {"EUR": 0.91},
  ///     "2024-01-02": {"EUR": 0.92},
  ///     ...
  ///   }
  /// }
  /// ```
  Future<Map<String, dynamic>> getHistoricalRates({
    required String from,
    required String to,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final start = _formatDate(startDate);
      final end = _formatDate(endDate);

      final response = await _dio.get<Map<String, dynamic>>(
        '/$start..$end',
        queryParameters: {
          'from': from,
          'to': to,
        },
      );

      return response.data ?? {};
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Récupère la liste de toutes les devises disponibles
  ///
  /// Endpoint : GET /currencies
  ///
  /// @return Map des devises avec leurs noms
  /// @throws Exception : En cas d'erreur
  ///
  /// Exemple de réponse :
  /// ```json
  /// {
  ///   "USD": "United States Dollar",
  ///   "EUR": "Euro",
  ///   "GBP": "British Pound",
  ///   ...
  /// }
  /// ```
  Future<Map<String, dynamic>> getCurrencies() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/currencies');
      return response.data ?? {};
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Formate une date au format YYYY-MM-DD
  ///
  /// @param date : Date à formater
  /// @return String au format 'YYYY-MM-DD'
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Gère les erreurs Dio et les convertit en exceptions explicites
  ///
  /// Types d'erreurs gérées :
  /// - Timeouts (connection, send, receive)
  /// - Erreurs de connexion
  /// - Erreurs serveur (4xx, 5xx)
  /// - Rate limiting (429)
  /// - Annulation de requête
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return Exception('Network error: ${e.message}');
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 429) {
          return Exception('Rate limit exceeded');
        }
        return Exception('Server error: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('Unknown error: ${e.message}');
    }
  }
}
