/// ============================================================================
/// CONTRÔLEUR DE CONVERSION DE DEVISES
/// ============================================================================
///
/// Ce fichier gère toute la logique de conversion de devises.
/// Il utilise le pattern StateNotifier de Riverpod pour gérer l'état réactif.
///
/// Responsabilités :
/// - Gestion de l'état de la conversion (devises, montant, résultat)
/// - Communication avec le repository pour obtenir les taux
/// - Calcul des conversions
/// - Gestion des erreurs et du chargement
///
/// @author Votre Nom
/// @version 1.0.0
/// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fxnow/src/data/models/exchange_rate.dart';
import 'package:fxnow/src/data/repositories/rates_repository.dart';
import 'package:fxnow/src/data/providers/providers.dart';

/// ============================================================================
/// ÉTAT DU CONVERTISSEUR
/// ============================================================================

/// Classe immutable représentant l'état actuel du convertisseur
///
/// Cette classe contient toutes les données nécessaires pour afficher
/// l'interface de conversion et effectuer les calculs.
class ConverterState {
  const ConverterState({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    this.result,
    this.rate,
    this.isLoading = false,
    this.error,
    this.fromCache = false,
  });

  /// Code de la devise source (ex: "USD")
  final String fromCurrency;

  /// Code de la devise cible (ex: "EUR")
  final String toCurrency;

  /// Montant saisi par l'utilisateur
  final double amount;

  /// Résultat de la conversion (peut être null si pas encore calculé)
  final double? result;

  /// Taux de change actuel (peut être null si pas encore chargé)
  final ExchangeRate? rate;

  /// Indique si un chargement est en cours
  final bool isLoading;

  /// Message d'erreur (null si pas d'erreur)
  final String? error;

  /// Indique si le taux provient du cache local
  final bool fromCache;

  /// Crée une copie de l'état avec certains champs modifiés
  ///
  /// Cette méthode est essentielle pour l'immutabilité.
  /// Au lieu de modifier l'état existant, on crée un nouvel état.
  ///
  /// @returns Nouvelle instance de ConverterState
  ConverterState copyWith({
    String? fromCurrency,
    String? toCurrency,
    double? amount,
    double? result,
    ExchangeRate? rate,
    bool? isLoading,
    String? error,
    bool? fromCache,
  }) {
    return ConverterState(
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amount: amount ?? this.amount,
      result: result ?? this.result,
      rate: rate ?? this.rate,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      fromCache: fromCache ?? this.fromCache,
    );
  }
}

/// ============================================================================
/// CONTRÔLEUR DU CONVERTISSEUR
/// ============================================================================

/// Contrôleur gérant la logique de conversion de devises
///
/// Ce StateNotifier gère :
/// - Le chargement des taux de change depuis l'API ou le cache
/// - Les calculs de conversion
/// - Les changements de devises
/// - L'inversion des devises (swap)
/// - Le rafraîchissement manuel
class ConverterController extends StateNotifier<ConverterState> {
  /// Constructeur du contrôleur
  ///
  /// @param _repository : Repository pour accéder aux taux de change
  /// @param defaultCurrency : Devise par défaut de l'utilisateur
  ConverterController(this._repository, String defaultCurrency)
      : super(ConverterState(
          fromCurrency: defaultCurrency,
          toCurrency: 'EUR',
          amount: 1.0,
        )) {
    // Charge le premier taux au démarrage
    _loadRate();
  }

  /// Repository pour communiquer avec l'API et le cache
  final RatesRepository _repository;

  /// Charge le taux de change actuel depuis l'API ou le cache
  ///
  /// Cette méthode privée :
  /// 1. Met l'état en mode "chargement"
  /// 2. Appelle le repository pour obtenir le taux
  /// 3. Calcule le résultat de la conversion
  /// 4. Met à jour l'état avec les nouvelles données
  /// 5. Gère les erreurs éventuelles
  Future<void> _loadRate() async {
    // Début du chargement
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Récupération du taux depuis le repository
      final result = await _repository.getLatestRate(
        from: state.fromCurrency,
        to: state.toCurrency,
      );

      // Calcul de la conversion : montant × taux
      final calculatedResult = state.amount * result.rate.rate;

      // Mise à jour de l'état avec le résultat
      state = state.copyWith(
        rate: result.rate,
        result: calculatedResult,
        isLoading: false,
        fromCache: result.fromCache,
      );
    } catch (e) {
      // En cas d'erreur, on met à jour l'état avec le message d'erreur
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Met à jour le montant saisi par l'utilisateur
  ///
  /// Si un taux est déjà chargé, recalcule immédiatement le résultat
  /// sans faire de nouvelle requête API.
  ///
  /// @param amount : Nouveau montant saisi
  void setAmount(double amount) {
    state = state.copyWith(amount: amount);

    // Si on a déjà un taux, on recalcule le résultat
    if (state.rate != null) {
      final result = amount * state.rate!.rate;
      state = state.copyWith(result: result);
    }
  }

  /// Change la devise source et recharge le taux
  ///
  /// @param currency : Code de la nouvelle devise source (ex: "USD")
  void setFromCurrency(String currency) {
    state = state.copyWith(fromCurrency: currency);
    _loadRate();
  }

  /// Change la devise cible et recharge le taux
  ///
  /// @param currency : Code de la nouvelle devise cible (ex: "EUR")
  void setToCurrency(String currency) {
    state = state.copyWith(toCurrency: currency);
    _loadRate();
  }

  /// Inverse les devises source et cible
  ///
  /// Exemple : USD → EUR devient EUR → USD
  /// Cette méthode échange simplement les deux devises puis recharge le taux.
  void swap() {
    final temp = state.fromCurrency;
    state = state.copyWith(
      fromCurrency: state.toCurrency,
      toCurrency: temp,
    );
    _loadRate();
  }

  /// Force le rafraîchissement du taux depuis l'API
  ///
  /// Cette méthode est appelée quand l'utilisateur appuie sur le bouton
  /// de rafraîchissement. Elle ignore le cache et va chercher un taux frais.
  Future<void> refresh() async {
    await _loadRate();
  }
}

/// ============================================================================
/// PROVIDER RIVERPOD
/// ============================================================================

/// Provider global du contrôleur de conversion
///
/// Ce provider :
/// - Crée une instance unique du contrôleur
/// - Injecte automatiquement les dépendances (repository, devise par défaut)
/// - Permet à tous les widgets d'accéder à l'état de la conversion
///
/// Usage dans un widget :
/// ```dart
/// final state = ref.watch(converterControllerProvider);
/// ref.read(converterControllerProvider.notifier).setAmount(100);
/// ```
final converterControllerProvider =
    StateNotifierProvider<ConverterController, ConverterState>((ref) {
  final repository = ref.watch(ratesRepositoryProvider);
  final defaultCurrency = ref.watch(defaultCurrencyProvider);
  return ConverterController(repository, defaultCurrency);
});
