/// ============================================================================
/// CURRENCY SELECTOR WIDGET
/// ============================================================================
///
/// Widget permettant de sélectionner une devise parmi la liste complète
/// des devises disponibles.
///
/// Fonctionnalités :
/// - Affichage de la devise actuellement sélectionnée
/// - Ouverture d'un bottom sheet avec la liste des devises
/// - Recherche de devise par code ou nom
/// - Affichage visuel avec icône et nom complet
///
/// Utilisation :
/// ```dart
/// CurrencySelector(
///   selectedCurrency: 'USD',
///   onChanged: (code) => print('Nouvelle devise: $code'),
/// )
/// ```
/// ============================================================================

import 'package:flutter/material.dart';
import 'package:fxnow/src/data/models/currency_data.dart';

/// Widget de sélection de devise
///
/// Affiche la devise sélectionnée et permet d'ouvrir un bottom sheet
/// pour choisir une autre devise parmi toutes celles disponibles.
class CurrencySelector extends StatelessWidget {
  const CurrencySelector({
    required this.selectedCurrency,
    required this.onChanged,
    super.key,
  });

  /// Code de la devise actuellement sélectionnée (ex: 'USD')
  final String selectedCurrency;

  /// Callback appelé quand l'utilisateur sélectionne une nouvelle devise
  /// @param String : Le code de la nouvelle devise sélectionnée
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        // Ouvre le bottom sheet de sélection de devise
        final result = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _CurrencyPickerSheet(
            selectedCurrency: selectedCurrency,
          ),
        );

        // Si l'utilisateur a sélectionné une devise, on appelle le callback
        if (result != null) {
          onChanged(result);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icône circulaire avec la première lettre de la devise
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  selectedCurrency.substring(0, 1),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Code et nom de la devise
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCurrency,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    CurrencyData.getName(selectedCurrency),
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Flèche pour indiquer que c'est cliquable
            Icon(
              Icons.arrow_drop_down,
              color: theme.colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// CURRENCY PICKER BOTTOM SHEET
/// ============================================================================
///
/// Bottom sheet privé affichant la liste complète des devises disponibles
/// avec une barre de recherche pour filtrer les résultats.
/// ============================================================================

class _CurrencyPickerSheet extends StatefulWidget {
  const _CurrencyPickerSheet({required this.selectedCurrency});

  final String selectedCurrency;

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  /// Texte de recherche saisi par l'utilisateur
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filtre les devises selon la recherche (code ou nom)
    final currencies = CurrencyData.codes
        .where((code) =>
            code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            CurrencyData.getName(code)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // ========== Poignée de glissement ==========
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ========== Barre de recherche ==========
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search currency...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // ========== Liste des devises ==========
          Expanded(
            child: ListView.builder(
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final code = currencies[index];
                final isSelected = code == widget.selectedCurrency;

                return ListTile(
                  // Icône de la devise
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        code.substring(0, 1),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                  // Code de la devise
                  title: Text(
                    code,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),

                  // Nom complet de la devise
                  subtitle: Text(CurrencyData.getName(code)),

                  // Icône de sélection
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                        )
                      : null,

                  // Au tap, retourne le code sélectionné
                  onTap: () {
                    Navigator.of(context).pop(code);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

