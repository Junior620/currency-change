/// ============================================================================
/// WIDGET CLAVIER NUMÉRIQUE PERSONNALISÉ
/// ============================================================================
///
/// Ce widget affiche un clavier numérique compact pour saisir des montants.
///
/// Disposition du clavier :
/// ┌────┬────┬────┬────────┐
/// │ 7  │ 8  │ 9  │ ⌫ DEL  │
/// ├────┼────┼────┼────────┤
/// │ 4  │ 5  │ 6  │ C CLR  │
/// ├────┼────┼────┼────────┤
/// │ 1  │ 2  │ 3  │ 00     │
/// ├────┼────┼────┼────────┤
/// │ .  │ 0  │    │        │
/// └────┴────┴────┴────────┘
///
/// Fonctionnalités :
/// - Saisie des chiffres de 0 à 9
/// - Bouton "00" pour saisir rapidement deux zéros
/// - Bouton "." pour le séparateur décimal
/// - Bouton "⌫" pour effacer le dernier caractère
/// - Bouton "C" pour tout effacer
///
/// @author Votre Nom
/// @version 1.0.0
/// ============================================================================

import 'package:flutter/material.dart';

/// Widget du clavier numérique personnalisé
///
/// Ce widget stateless affiche un clavier compact avec des callbacks
/// pour gérer les interactions utilisateur.
class CalculatorKeypad extends StatelessWidget {
  const CalculatorKeypad({
    required this.onNumberPressed,
    required this.onClear,
    required this.onDelete,
    super.key,
  });

  /// Callback appelé quand l'utilisateur appuie sur un chiffre ou le point
  /// @param value : La valeur pressée ("0"-"9", ".", "00")
  final Function(String) onNumberPressed;

  /// Callback appelé quand l'utilisateur appuie sur le bouton Clear (C)
  final VoidCallback onClear;

  /// Callback appelé quand l'utilisateur appuie sur le bouton Delete (⌫)
  final VoidCallback onDelete;

  /// Construit l'interface du clavier
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // ========== Première ligne : 7, 8, 9, Delete ==========
        Row(
          children: [
            _buildKey(context, '7'),
            const SizedBox(width: 4),
            _buildKey(context, '8'),
            const SizedBox(width: 4),
            _buildKey(context, '9'),
            const SizedBox(width: 4),
            _buildActionKey(
              context,
              icon: Icons.backspace_outlined,
              onPressed: onDelete,
            ),
          ],
        ),
        const SizedBox(height: 4),

        // ========== Deuxième ligne : 4, 5, 6, Clear ==========
        Row(
          children: [
            _buildKey(context, '4'),
            const SizedBox(width: 4),
            _buildKey(context, '5'),
            const SizedBox(width: 4),
            _buildKey(context, '6'),
            const SizedBox(width: 4),
            _buildActionKey(
              context,
              icon: Icons.clear,
              onPressed: onClear,
              color: theme.colorScheme.error,
            ),
          ],
        ),
        const SizedBox(height: 4),

        // ========== Troisième ligne : 1, 2, 3, 00 ==========
        Row(
          children: [
            _buildKey(context, '1'),
            const SizedBox(width: 4),
            _buildKey(context, '2'),
            const SizedBox(width: 4),
            _buildKey(context, '3'),
            const SizedBox(width: 4),
            _buildKey(context, '00'),
          ],
        ),
        const SizedBox(height: 4),

        // ========== Quatrième ligne : . , 0 ==========
        Row(
          children: [
            _buildKey(context, '.'),
            const SizedBox(width: 4),
            _buildKey(context, '0'),
            const SizedBox(width: 4),
            // Espace vide pour équilibrer la disposition
            Expanded(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      ],
    );
  }

  /// Construit une touche numérique standard
  ///
  /// Cette méthode crée un bouton arrondi avec le chiffre ou symbole.
  /// Le bouton a un ratio d'aspect de 1.5:1 pour être compact.
  ///
  /// @param context : Contexte de construction
  /// @param value : Valeur à afficher sur la touche
  /// @returns Widget de la touche
  Widget _buildKey(BuildContext context, String value) {
    final theme = Theme.of(context);

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.5, // Ratio largeur/hauteur pour un bouton compact
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          elevation: 1, // Légère ombre pour donner de la profondeur
          child: InkWell(
            onTap: () => onNumberPressed(value),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Construit une touche d'action (Delete ou Clear)
  ///
  /// Ces touches affichent une icône au lieu de texte et peuvent
  /// avoir une couleur personnalisée (rouge pour Clear).
  ///
  /// @param context : Contexte de construction
  /// @param icon : Icône à afficher
  /// @param onPressed : Callback à appeler lors du clic
  /// @param color : Couleur optionnelle (pour le bouton Clear rouge)
  /// @returns Widget de la touche d'action
  Widget _buildActionKey(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Material(
          // Couleur de fond avec légère transparence si couleur personnalisée
          color: color?.withOpacity(0.1) ?? theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
          elevation: 1,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Icon(
                  icon,
                  color: color ?? theme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
