/// ============================================================================
/// FICHIER PRINCIPAL DE L'APPLICATION FXNOW
/// ============================================================================
///
/// Ce fichier est le point d'entrée de l'application de conversion de devises.
/// Il initialise tous les services nécessaires avant de lancer l'application.
///
/// Fonctionnalités principales :
/// - Initialisation du service de cache local (SharedPreferences)
/// - Configuration du système de gestion d'état (Riverpod)
/// - Lancement de l'application Flutter
///
/// @author Votre Nom
/// @version 1.0.0
/// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fxnow/src/app/app.dart';
import 'package:fxnow/src/router/routes.dart';
import 'package:fxnow/src/data/providers/providers.dart';
import 'package:fxnow/src/data/cache/cache_service.dart';

/// Point d'entrée principal de l'application
///
/// Cette fonction asynchrone est appelée au démarrage de l'application.
/// Elle effectue les opérations suivantes dans l'ordre :
///
/// 1. Initialise les bindings Flutter (nécessaire pour les opérations async)
/// 2. Crée et initialise le service de cache local
/// 3. Lance l'application avec le système de gestion d'état Riverpod
///
/// @returns void - Ne retourne rien, lance l'application
void main() async {
  // Initialise les bindings Flutter pour permettre les opérations asynchrones
  // avant le lancement de l'application
  WidgetsFlutterBinding.ensureInitialized();

  // Crée et initialise le service de cache (SharedPreferences)
  // Ce service permet de sauvegarder les préférences utilisateur localement
  final cacheService = await CacheService.create();

  // Lance l'application Flutter avec le système de gestion d'état Riverpod
  runApp(
    // ProviderScope : Conteneur racine pour tous les providers Riverpod
    ProviderScope(
      // Override : Injecte notre instance de CacheService dans l'application
      overrides: [
        cacheServiceProvider.overrideWithValue(cacheService),
      ],
      // Lance l'application principale avec la configuration des routes
      child: FXNowApp(router: router),
    ),
  );
}
