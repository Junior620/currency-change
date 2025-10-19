/// ============================================================================
/// PAGE DE CONVERSION DE DEVISES
/// ============================================================================
///
/// Cette page principale permet à l'utilisateur de :
/// - Sélectionner une devise source et une devise cible
/// - Saisir un montant via un clavier numérique personnalisé
/// - Voir le résultat de la conversion en temps réel
/// - Inverser les devises avec le bouton Swap
/// - Actualiser les taux de change manuellement
///
/// Architecture :
/// - Utilise Riverpod pour la gestion d'état
/// - Animations fluides avec flutter_animate
/// - Mise à jour automatique des taux toutes les 60 secondes (optionnel)
///
/// @author Votre Nom
/// @version 1.0.0
/// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fxnow/l10n/app_localizations.dart';
import 'package:fxnow/src/features/converter/controllers/converter_controller.dart';
import 'package:fxnow/src/features/converter/widgets/currency_selector.dart';
import 'package:fxnow/src/features/converter/widgets/calculator_keypad.dart';
import 'package:fxnow/src/features/converter/widgets/result_display.dart';
import 'package:fxnow/src/data/providers/providers.dart';
import 'package:fxnow/src/core/utils/formatters.dart';
import 'dart:async';

/// Widget principal de la page de conversion
///
/// Ce StatefulWidget gère :
/// - L'état local de la saisie utilisateur
/// - Le timer pour l'actualisation automatique
/// - Les interactions avec le clavier numérique
class ConverterPage extends ConsumerStatefulWidget {
  const ConverterPage({super.key});

  @override
  ConsumerState<ConverterPage> createState() => _ConverterPageState();
}

/// État privé de la page de conversion
class _ConverterPageState extends ConsumerState<ConverterPage> {
  /// Timer pour l'actualisation automatique des taux de change
  Timer? _autoRefreshTimer;

  /// Montant actuellement affiché (sous forme de chaîne pour gérer la saisie)
  String _displayAmount = '0';

  /// Initialisation du widget
  /// Configure l'actualisation automatique si activée
  @override
  void initState() {
    super.initState();
    _setupAutoRefresh();
  }

  /// Nettoyage lors de la destruction du widget
  /// Annule le timer pour éviter les fuites mémoire
  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  /// Configure l'actualisation automatique des taux de change
  ///
  /// Si l'option est activée dans les préférences, un timer
  /// rafraîchit les taux toutes les 60 secondes
  void _setupAutoRefresh() {
    _autoRefreshTimer?.cancel();
    final autoRefresh = ref.read(autoRefreshProvider);

    if (autoRefresh) {
      _autoRefreshTimer = Timer.periodic(
        const Duration(seconds: 60),
        (_) {
          if (mounted) {
            ref.read(converterControllerProvider.notifier).refresh();
          }
        },
      );
    }
  }

  /// Gère la saisie d'un chiffre ou du point décimal
  ///
  /// Logique de saisie :
  /// - Si le montant est "0" et qu'on saisit un chiffre, on remplace le 0
  /// - On empêche la saisie de plusieurs points décimaux
  /// - On met à jour le contrôleur avec le nouveau montant
  ///
  /// @param value : Chiffre ou point décimal saisi ("0"-"9", ".", "00")
  void _handleNumberInput(String value) {
    setState(() {
      if (_displayAmount == '0' && value != '.') {
        // Remplace le zéro initial par le chiffre saisi
        _displayAmount = value;
      } else if (value == '.' && _displayAmount.contains('.')) {
        // Ne pas ajouter un deuxième point décimal
        return;
      } else {
        // Ajoute le caractère à la fin
        _displayAmount += value;
      }
    });

    // Parse et envoie le montant au contrôleur
    final parsed = double.tryParse(_displayAmount);
    if (parsed != null) {
      ref.read(converterControllerProvider.notifier).setAmount(parsed);
    }
  }

  /// Efface complètement le montant saisi (bouton C)
  /// Remet le montant à "0"
  void _handleClear() {
    setState(() {
      _displayAmount = '0';
    });
    ref.read(converterControllerProvider.notifier).setAmount(0);
  }

  /// Efface le dernier caractère saisi (bouton Backspace)
  ///
  /// Si un seul caractère reste, on remet "0"
  void _handleDelete() {
    setState(() {
      if (_displayAmount.length > 1) {
        // Supprime le dernier caractère
        _displayAmount = _displayAmount.substring(0, _displayAmount.length - 1);
      } else {
        // S'il ne reste qu'un caractère, on remet "0"
        _displayAmount = '0';
      }
    });

    // Met à jour le contrôleur avec le nouveau montant
    final parsed = double.tryParse(_displayAmount);
    ref.read(converterControllerProvider.notifier).setAmount(parsed ?? 0);
  }

  /// Construit l'interface utilisateur de la page
  @override
  Widget build(BuildContext context) {
    // Récupération des traductions
    final l10n = AppLocalizations.of(context)!;

    // Observation de l'état du convertisseur
    final state = ref.watch(converterControllerProvider);

    // Observation de la langue sélectionnée
    final locale = ref.watch(localeProvider);

    // Récupération du thème actuel
    final theme = Theme.of(context);

    return Scaffold(
      // ========== Barre d'application ==========
      appBar: AppBar(
        title: Text(l10n.converter),
        actions: [
          // Bouton d'actualisation manuelle
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: state.isLoading
                ? null // Désactive si chargement en cours
                : () {
                    ref.read(converterControllerProvider.notifier).refresh();
                  },
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ========== Zone scrollable (haut de l'écran) ==========
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // === Carte "Devise source" ===
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Label "De"
                            Text(
                              l10n.from,
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12),

                            // Sélecteur de devise source
                            CurrencySelector(
                              selectedCurrency: state.fromCurrency,
                              onChanged: (currency) {
                                ref
                                    .read(converterControllerProvider.notifier)
                                    .setFromCurrency(currency);
                              },
                            ),

                            const SizedBox(height: 16),

                            // Label "Montant"
                            Text(
                              l10n.amount,
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),

                            // Affichage du montant saisi
                            Text(
                              _displayAmount,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 300.ms).slideY(
                          begin: -0.2,
                          end: 0,
                          duration: 300.ms,
                        ),

                    const SizedBox(height: 16),

                    // === Bouton d'inversion des devises ===
                    Center(
                      child: IconButton.filled(
                        onPressed: () {
                          ref.read(converterControllerProvider.notifier).swap();
                        },
                        icon: const Icon(Icons.swap_vert),
                        iconSize: 32,
                        padding: const EdgeInsets.all(12),
                      ).animate(
                        key: ValueKey(state.fromCurrency + state.toCurrency),
                      ).rotate(
                        duration: 300.ms,
                        curve: Curves.easeInOut,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // === Carte "Devise cible" avec résultat ===
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Label "Vers"
                            Text(
                              l10n.to,
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12),

                            // Sélecteur de devise cible
                            CurrencySelector(
                              selectedCurrency: state.toCurrency,
                              onChanged: (currency) {
                                ref
                                    .read(converterControllerProvider.notifier)
                                    .setToCurrency(currency);
                              },
                            ),

                            const SizedBox(height: 16),

                            // Affichage du résultat de la conversion
                            ResultDisplay(
                              result: state.result,
                              currency: state.toCurrency,
                              isLoading: state.isLoading,
                              locale: locale,
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(
                          duration: 300.ms,
                          delay: 100.ms,
                        ).slideY(
                          begin: -0.2,
                          end: 0,
                          duration: 300.ms,
                          delay: 100.ms,
                        ),

                    const SizedBox(height: 16),

                    // === Informations sur le taux de change ===
                    if (state.rate != null) ...[
                      _RateInfoCard(
                        rate: state.rate!.rate,
                        fromCurrency: state.fromCurrency,
                        toCurrency: state.toCurrency,
                        timestamp: state.rate!.timestamp,
                        isLive: state.rate!.isLive,
                        locale: locale,
                      ).animate().fadeIn(delay: 200.ms),
                    ],

                    // === Message d'erreur (si présent) ===
                    if (state.error != null) ...[
                      Card(
                        color: theme.colorScheme.errorContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  state.error!,
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ========== Clavier numérique fixe (bas de l'écran) ==========
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: CalculatorKeypad(
                onNumberPressed: _handleNumberInput,
                onClear: _handleClear,
                onDelete: _handleDelete,
              ).animate().fadeIn(delay: 300.ms),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// WIDGET D'AFFICHAGE DES INFORMATIONS SUR LE TAUX DE CHANGE
/// ============================================================================

/// Carte affichant les détails du taux de change actuel
///
/// Affiche :
/// - Le taux de conversion (ex: 1 USD = 0.85 EUR)
/// - Le statut (live ou en cache)
/// - L'heure de la dernière mise à jour
class _RateInfoCard extends StatelessWidget {
  const _RateInfoCard({
    required this.rate,
    required this.fromCurrency,
    required this.toCurrency,
    required this.timestamp,
    required this.isLive,
    required this.locale,
  });

  /// Taux de change actuel
  final double rate;

  /// Code de la devise source (ex: "USD")
  final String fromCurrency;

  /// Code de la devise cible (ex: "EUR")
  final String toCurrency;

  /// Date/heure de la dernière mise à jour du taux
  final DateTime timestamp;

  /// Indique si le taux vient de l'API (true) ou du cache (false)
  final bool isLive;

  /// Code de langue pour le formatage
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage du taux de conversion
            Row(
              children: [
                Text(
                  '1 $fromCurrency = ${formatNumber(rate, locale)} $toCurrency',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Statut et timestamp
            Row(
              children: [
                // Icône de statut (point vert = live, icône cache = cached)
                Icon(
                  isLive ? Icons.circle : Icons.cached,
                  size: 12,
                  color: isLive ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),

                // Label du statut
                Text(
                  isLive ? l10n.live : l10n.cached,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isLive ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(width: 16),

                // Heure de la dernière mise à jour
                Text(
                  '${l10n.lastUpdated}: ${formatRelativeTime(timestamp, locale)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
