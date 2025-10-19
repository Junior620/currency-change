/// ============================================================================
/// WIDGET PRINCIPAL DE L'APPLICATION FXNOW
/// ============================================================================
///
/// Ce fichier définit le widget racine de l'application MaterialApp.
/// Il configure tous les aspects globaux de l'application.
///
/// Fonctionnalités :
/// - Configuration des thèmes (clair/sombre)
/// - Gestion de l'internationalisation (français/anglais)
/// - Configuration du système de navigation (GoRouter)
/// - Observation des changements de thème et de langue
///
/// @author Votre Nom
/// @version 1.0.0
/// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fxnow/l10n/app_localizations.dart';
import 'package:fxnow/src/app/theme/themes.dart';
import 'package:fxnow/src/data/providers/providers.dart';

/// Widget racine de l'application FXNow
///
/// Ce widget utilise ConsumerWidget de Riverpod pour observer les changements
/// de thème et de langue en temps réel.
///
/// @param router : Configuration des routes de navigation
class FXNowApp extends ConsumerWidget {
  const FXNowApp({required this.router, super.key});

  /// Instance de GoRouter contenant toutes les routes de l'application
  final GoRouter router;

  /// Construit l'interface utilisateur de l'application
  ///
  /// Cette méthode configure :
  /// - Les thèmes clair et sombre
  /// - Les langues supportées (français et anglais)
  /// - Le système de navigation
  ///
  /// @param context : Contexte de construction du widget
  /// @param ref : Référence pour accéder aux providers Riverpod
  /// @returns Widget MaterialApp configuré
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observe le thème actuel sélectionné par l'utilisateur
    final theme = ref.watch(themeProvider);

    // Observe la langue actuelle sélectionnée par l'utilisateur
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      // Titre de l'application
      title: 'FXNow',

      // Désactive le bandeau "DEBUG" en mode développement
      debugShowCheckedModeBanner: false,

      // ========== Configuration des thèmes ==========
      // Thème clair utilisé par défaut
      theme: lightTheme(),

      // Thème sombre utilisé quand le mode sombre est activé
      darkTheme: darkTheme(),

      // Détermine quel thème utiliser (clair/sombre/système)
      themeMode: _getThemeMode(theme),

      // ========== Configuration de la localisation ==========
      // Définit la langue active de l'application
      locale: Locale(locale),

      // Délégués pour traduire les textes de l'application
      localizationsDelegates: const [
        AppLocalizations.delegate,              // Nos traductions personnalisées
        GlobalMaterialLocalizations.delegate,   // Traductions Material Design
        GlobalWidgetsLocalizations.delegate,    // Traductions des widgets Flutter
        GlobalCupertinoLocalizations.delegate,  // Traductions style iOS
      ],

      // Langues supportées par l'application
      supportedLocales: const [
        Locale('en'), // Anglais
        Locale('fr'), // Français
      ],

      // ========== Configuration de la navigation ==========
      // Utilise GoRouter pour la navigation déclarative
      routerConfig: router,
    );
  }

  /// Convertit une chaîne de thème en ThemeMode Flutter
  ///
  /// Cette méthode transforme la préférence de thème sauvegardée
  /// en un ThemeMode utilisable par Flutter.
  ///
  /// @param theme : Chaîne représentant le thème ('light', 'dark', 'system')
  /// @returns ThemeMode correspondant
  ///
  /// Valeurs possibles :
  /// - 'light' → ThemeMode.light (toujours clair)
  /// - 'dark' → ThemeMode.dark (toujours sombre)
  /// - 'system' → ThemeMode.system (suit le système)
  ThemeMode _getThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system; // Suit automatiquement le thème du système
    }
  }
}
