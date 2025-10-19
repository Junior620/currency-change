/// ============================================================================
/// RESULT DISPLAY WIDGET
/// ============================================================================
///
/// Widget d'affichage du résultat de conversion avec animations et actions.
///
/// Fonctionnalités :
/// - Affichage animé du résultat de conversion
/// - Indicateur de chargement pendant la conversion
/// - Bouton de copie vers le presse-papiers
/// - Bouton de partage du résultat
/// - Formatage localisé des nombres
///
/// Utilisation :
/// ```dart
/// ResultDisplay(
///   result: 123.45,
///   currency: 'EUR',
///   isLoading: false,
///   locale: 'fr',
/// )
/// ```
/// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fxnow/l10n/app_localizations.dart';
import 'package:fxnow/src/core/utils/formatters.dart';
import 'package:share_plus/share_plus.dart';

/// Widget d'affichage du résultat de conversion
///
/// Affiche le résultat avec des animations et propose des actions
/// comme la copie et le partage.
class ResultDisplay extends StatelessWidget {
  const ResultDisplay({
    required this.result,
    required this.currency,
    required this.isLoading,
    required this.locale,
    super.key,
  });

  /// Résultat de la conversion (peut être null si pas encore calculé)
  final double? result;

  /// Code de la devise du résultat (ex: 'EUR')
  final String currency;

  /// Indique si une conversion est en cours
  final bool isLoading;

  /// Locale pour le formatage des nombres (ex: 'fr' ou 'en')
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ========== Label "Résultat" ==========
        Text(
          l10n.result,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 8),

        // ========== Résultat avec animation ==========
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: isLoading
              ? const CircularProgressIndicator()
              : Text(
                  result != null
                      ? formatNumber(result!, locale)
                      : '0.00',
                  key: ValueKey(result), // Key pour déclencher l'animation
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
        ),
        const SizedBox(height: 16),

        // ========== Boutons d'action ==========
        Row(
          children: [
            // Bouton Copier
            Expanded(
              child: OutlinedButton.icon(
                onPressed: result == null
                    ? null
                    : () {
                        // Copie le résultat dans le presse-papiers
                        Clipboard.setData(
                          ClipboardData(text: result.toString()),
                        );
                        // Affiche un message de confirmation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.copiedToClipboard),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                icon: const Icon(Icons.copy, size: 18),
                label: Text(l10n.copy),
              ),
            ),
            const SizedBox(width: 12),

            // Bouton Partager
            Expanded(
              child: OutlinedButton.icon(
                onPressed: result == null
                    ? null
                    : () {
                        // Partage le résultat via les apps du système
                        Share.share(
                          '${formatNumber(result!, locale)} $currency',
                        );
                      },
                icon: const Icon(Icons.share, size: 18),
                label: Text(l10n.share),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
