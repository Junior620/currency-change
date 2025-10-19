/// ============================================================================
/// CONFIGURATION DES ROUTES DE NAVIGATION
/// ============================================================================
///
/// Ce fichier définit toutes les routes de navigation de l'application.
/// Il utilise GoRouter pour une navigation déclarative et type-safe.
///
/// Routes disponibles :
/// - '/' : Page de conversion de devises (route par défaut)
///
/// @author Votre Nom
/// @version 1.0.0
/// ============================================================================

import 'package:go_router/go_router.dart';
import 'package:fxnow/src/features/converter/ui/converter_page.dart';

/// Configuration globale du routeur de l'application
///
/// Cette instance de GoRouter définit toutes les routes disponibles
/// et gère la navigation entre les différentes pages.
///
/// Structure de navigation :
/// - Route initiale : '/' (Converter)
final router = GoRouter(
  // Route de démarrage de l'application
  initialLocation: '/',

  // Liste de toutes les routes disponibles
  routes: [
    /// Route principale : Page de conversion de devises
    ///
    /// Chemin : '/'
    /// Nom : 'converter'
    /// Widget : ConverterPage (page de conversion avec clavier personnalisé)
    GoRoute(
      path: '/',                    // URL de la route
      name: 'converter',            // Nom pour la navigation programmatique
      builder: (context, state) => const ConverterPage(),
    ),
  ],
);
