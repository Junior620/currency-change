/// ============================================================================
/// APPLICATION THEMES
/// ============================================================================
///
/// Configuration des thèmes clair et sombre de l'application.
///
/// Ce fichier définit :
/// - La palette de couleurs complète (AppColors)
/// - Le thème clair (lightTheme)
/// - Le thème sombre (darkTheme)
/// - Les styles pour tous les composants Material Design
///
/// Architecture des couleurs :
/// - Couleurs primaires/secondaires pour les actions importantes
/// - Couleurs de surface pour les conteneurs
/// - Couleurs de texte avec niveaux de contraste
/// - Couleurs sémantiques (error, success, warning, info)
///
/// Utilisation :
/// ```dart
/// MaterialApp(
///   theme: lightTheme(),
///   darkTheme: darkTheme(),
///   themeMode: ThemeMode.system,
/// )
/// ```
/// ============================================================================

import 'package:flutter/material.dart';

// ============================================================================
// COLOR PALETTE
// ============================================================================

/// Palette de couleurs de l'application
///
/// Contient toutes les couleurs utilisées dans l'app, organisées par thème.
/// Utilise des couleurs constantes pour garantir la cohérence visuelle.
class AppColors {
  // ========== Couleurs du thème clair ==========

  /// Couleur primaire - Indigo vibrant pour les actions principales
  static const primary = Color(0xFF4F46E5);

  /// Couleur secondaire - Vert pour les indicateurs de succès
  static const secondary = Color(0xFF22C55E);

  /// Couleur de surface claire - Gris très léger pour les cartes
  static const surfaceLight = Color(0xFFF8FAFC);

  /// Couleur de fond clair - Blanc pur
  static const backgroundLight = Color(0xFFFFFFFF);

  /// Couleur de carte claire - Blanc pur avec ombre
  static const cardLight = Color(0xFFFFFFFF);

  /// Couleur de texte primaire clair - Presque noir
  static const textPrimaryLight = Color(0xFF0F172A);

  /// Couleur de texte secondaire clair - Gris moyen
  static const textSecondaryLight = Color(0xFF64748B);

  // ========== Couleurs du thème sombre ==========

  /// Couleur de surface sombre - Bleu marine très foncé
  static const surfaceDark = Color(0xFF0B1220);

  /// Couleur de fond sombre - Bleu marine foncé
  static const backgroundDark = Color(0xFF0F172A);

  /// Couleur de carte sombre - Gris bleuté
  static const cardDark = Color(0xFF1E293B);

  /// Couleur de texte primaire sombre - Presque blanc
  static const textPrimaryDark = Color(0xFFF8FAFC);

  /// Couleur de texte secondaire sombre - Gris clair
  static const textSecondaryDark = Color(0xFF94A3B8);

  // ========== Couleurs sémantiques (communes aux deux thèmes) ==========

  /// Rouge pour les erreurs et actions destructives
  static const error = Color(0xFFEF4444);

  /// Vert pour les succès et validations
  static const success = Color(0xFF22C55E);

  /// Orange pour les avertissements
  static const warning = Color(0xFFF59E0B);

  /// Bleu pour les informations
  static const info = Color(0xFF3B82F6);
}

// ============================================================================
// LIGHT THEME
// ============================================================================

/// Crée et retourne le thème clair de l'application
///
/// Configure tous les styles Material Design pour un look cohérent
/// et moderne en mode clair.
///
/// @return ThemeData configuré pour le mode clair
ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // ========== Schéma de couleurs ==========
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceLight,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryLight,
      onError: Colors.white,
    ),

    // ========== Couleur de fond d'écran ==========
    scaffoldBackgroundColor: AppColors.backgroundLight,

    // ========== Style des cartes ==========
    cardTheme: CardThemeData(
      color: AppColors.cardLight,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // ========== Style de l'AppBar ==========
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.textPrimaryLight,
      elevation: 0,
      centerTitle: true,
    ),

    // ========== Style de la navigation bar ==========
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      indicatorColor: AppColors.primary.withOpacity(0.1),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          );
        }
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondaryLight,
        );
      }),
    ),

    // ========== Style des champs de texte ==========
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),

    // ========== Style des boutons élevés ==========
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ========== Style des boutons texte ==========
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // ========== Thème des icônes ==========
    iconTheme: const IconThemeData(
      color: AppColors.textPrimaryLight,
    ),

    // ========== Typographie ==========
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryLight,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryLight,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryLight,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryLight,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimaryLight,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimaryLight,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondaryLight,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
    ),
  );
}

// ============================================================================
// DARK THEME
// ============================================================================

/// Crée et retourne le thème sombre de l'application
///
/// Configure tous les styles Material Design pour un look cohérent
/// et moderne en mode sombre.
///
/// @return ThemeData configuré pour le mode sombre
ThemeData darkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // ========== Schéma de couleurs ==========
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryDark,
      onError: Colors.white,
    ),

    // ========== Couleur de fond d'écran ==========
    scaffoldBackgroundColor: AppColors.backgroundDark,

    // ========== Style des cartes ==========
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // ========== Style de l'AppBar ==========
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
      centerTitle: true,
    ),

    // ========== Style de la navigation bar ==========
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      indicatorColor: AppColors.primary.withOpacity(0.2),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          );
        }
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondaryDark,
        );
      }),
    ),

    // ========== Style des champs de texte ==========
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),

    // ========== Style des boutons élevés ==========
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ========== Style des boutons texte ==========
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // ========== Thème des icônes ==========
    iconTheme: const IconThemeData(
      color: AppColors.textPrimaryDark,
    ),

    // ========== Typographie ==========
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryDark,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryDark,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryDark,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryDark,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimaryDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimaryDark,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondaryDark,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      ),
    ),
  );
}
