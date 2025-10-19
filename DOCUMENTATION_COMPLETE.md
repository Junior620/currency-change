/// ============================================================================
/// DOCUMENTATION COMPLÈTE DU PROJET FXNOW
/// ============================================================================
/// 
/// Application Flutter de conversion de devises en temps réel
/// Version: 1.0.0
/// Architecture: Single Page Application (SPA)
/// 
/// ============================================================================
/// 📁 STRUCTURE DU PROJET
/// ============================================================================
/// 
/// lib/
/// ├── main.dart                          # Point d'entrée de l'application
/// ├── l10n/                              # Fichiers de traduction (i18n)
/// │   ├── app_localizations.dart         # Classe de localisation générée
/// │   ├── app_localizations_en.dart      # Traductions anglaises
/// │   └── app_localizations_fr.dart      # Traductions françaises
/// │
/// └── src/
///     ├── app/                           # Configuration de l'application
///     │   ├── app.dart                   # Widget racine MaterialApp
///     │   └── theme/
///     │       └── themes.dart            # Thèmes clair/sombre
///     │
///     ├── core/                          # Fonctionnalités de base
///     │   ├── env/
///     │   │   └── env.dart               # Variables d'environnement
///     │   ├── errors/
///     │   │   └── failures.dart          # Gestion d'erreurs typée
///     │   └── utils/
///     │       ├── extensions.dart        # Extensions Dart utilitaires
///     │       └── formatters.dart        # Fonctions de formatage
///     │
///     ├── data/                          # Couche de données
///     │   ├── api/
///     │   │   └── rates_api.dart         # Client HTTP Dio
///     │   ├── cache/
///     │   │   └── cache_service.dart     # Service de cache local
///     │   ├── models/
///     │   │   ├── currency.dart          # Modèle de devise
///     │   │   ├── currency_data.dart     # Base de données des devises
///     │   │   ├── exchange_rate.dart     # Modèle de taux de change
///     │   │   └── rate_point.dart        # Point d'historique de taux
///     │   ├── providers/
///     │   │   └── providers.dart         # Providers Riverpod
///     │   └── repositories/
///     │       └── rates_repository.dart  # Repository avec cache
///     │
///     ├── features/                      # Fonctionnalités de l'app
///     │   └── converter/                 # Module de conversion (PAGE UNIQUE)
///     │       ├── controllers/
///     │       │   └── converter_controller.dart  # Logique métier
///     │       ├── ui/
///     │       │   └── converter_page.dart        # Interface principale
///     │       └── widgets/
///     │           ├── calculator_keypad.dart     # Clavier de saisie
///     │           ├── currency_selector.dart     # Sélecteur de devise
///     │           └── result_display.dart        # Affichage du résultat
///     │
///     └── router/
///         └── routes.dart                # Configuration GoRouter (route unique)
/// 
/// ============================================================================
/// 🏗️ ARCHITECTURE
/// ============================================================================
/// 
/// L'application suit une architecture en couches inspirée de Clean Architecture
/// avec une approche Single Page Application (SPA) - Une seule page centralisée.
/// 
/// 1. PRÉSENTATION (UI Layer)
///    - Page unique (converter_page.dart) - Toutes les fonctionnalités en un lieu
///    - Widgets réutilisables (currency_selector, calculator_keypad, result_display)
///    - Controller Riverpod (converter_controller.dart) - Gestion d'état centralisée
/// 
/// 2. DOMAINE (Business Logic)
///    - Modèles métier (ExchangeRate, Currency, RatePoint)
///    - Gestion d'erreurs typée (Failures)
/// 
/// 3. DONNÉES (Data Layer)
///    - API Client (rates_api.dart) - Communication avec Frankfurter API
///    - Cache Service (cache_service.dart) - Persistance locale
///    - Repository (rates_repository.dart) - Couche d'abstraction
/// 
/// Flux de données simplifié :
/// UI (Page Unique) → Controller → Repository → [Cache ou API] → Repository → Controller → UI
/// 
/// ============================================================================
/// 📦 DÉPENDANCES PRINCIPALES
/// ============================================================================
/// 
/// - flutter_riverpod: ^2.4.9        # Gestion d'état
/// - go_router: ^13.0.0              # Navigation (route unique)
/// - dio: ^5.4.0                     # Client HTTP
/// - shared_preferences: ^2.2.2      # Stockage local
/// - equatable: ^2.0.5               # Comparaison d'objets
/// - intl: ^0.19.0                   # Formatage i18n
/// - share_plus: ^7.2.1              # Partage système
/// - hive: ^2.2.3                    # Base de données NoSQL
/// 
/// ============================================================================
/// 🎨 FONCTIONNALITÉS
/// ============================================================================
/// 
/// ✅ Conversion de devises en temps réel
/// ✅ Support de 32+ devises internationales
/// ✅ Cache intelligent avec fallback offline
/// ✅ Interface moderne Material Design 3
/// ✅ Thème clair/sombre/système
/// ✅ Internationalisation (Français/Anglais)
/// ✅ Copie et partage des résultats
/// ✅ Clavier personnalisé pour saisie rapide
/// ✅ Recherche de devises
/// ✅ Gestion des favoris
/// ✅ Animations fluides
/// ✅ Architecture SPA - Tout en une page
/// 
/// ============================================================================
/// 🔑 CONCEPTS CLÉS
/// ============================================================================
/// 
/// SINGLE PAGE APPLICATION (SPA)
/// ------------------------------
/// L'application utilise une seule page (converter_page.dart) qui contient
/// toutes les fonctionnalités. Avantages :
/// - Navigation simplifiée
/// - État centralisé
/// - Performance optimale
/// - Expérience utilisateur fluide
/// 
/// RIVERPOD PROVIDERS
/// ------------------
/// Les providers Riverpod gèrent l'état global :
/// - cacheServiceProvider : Service de cache
/// - ratesApiProvider : Client API
/// - ratesRepositoryProvider : Repository
/// - themeProvider : Thème actif
/// - localeProvider : Langue active
/// - favoritesProvider : Liste des favoris
/// 
/// CACHE STRATEGY
/// --------------
/// 1. Vérifier le cache (si frais < 5 min, retourner)
/// 2. Appeler l'API (si succès, mettre en cache)
/// 3. En cas d'erreur, retourner cache périmé si disponible
/// 
/// HISTORIQUE DES TAUX
/// -------------------
/// L'historique dans le cache (RatePoint) sert pour :
/// - Analyser l'évolution des taux
/// - Afficher des graphiques (feature future)
/// - Garder un historique local des conversions
/// Note: Ce n'est PAS une page d'historique utilisateur
/// 
/// ERROR HANDLING
/// --------------
/// Toutes les erreurs sont typées avec des Failures :
/// - NetworkFailure : Problème réseau
/// - RateLimitFailure : Limite API atteinte
/// - ParseFailure : Réponse invalide
/// - UnknownFailure : Erreur inconnue
/// 
/// ============================================================================
/// 🚀 DÉMARRAGE RAPIDE
/// ============================================================================
/// 
/// 1. Installation des dépendances :
///    ```bash
///    flutter pub get
///    ```
/// 
/// 2. Génération du code (Hive, l10n) :
///    ```bash
///    flutter pub run build_runner build --delete-conflicting-outputs
///    flutter gen-l10n
///    ```
/// 
/// 3. Lancement de l'application :
///    ```bash
///    flutter run
///    ```
/// 
/// ============================================================================
/// 📝 FICHIERS DOCUMENTÉS
/// ============================================================================
/// 
/// Tous les fichiers suivants contiennent une documentation complète :
/// 
/// CONFIGURATION :
/// ✅ app.dart - Widget racine de l'application
/// ✅ themes.dart - Configuration des thèmes
/// ✅ routes.dart - Configuration des routes (route unique)
/// ✅ env.dart - Variables d'environnement
/// 
/// CORE :
/// ✅ failures.dart - Gestion d'erreurs
/// ✅ extensions.dart - Extensions utilitaires
/// ✅ formatters.dart - Fonctions de formatage
/// 
/// DATA :
/// ✅ rates_api.dart - Client API HTTP
/// ✅ cache_service.dart - Service de cache
/// ✅ currency.dart - Modèle de devise
/// ✅ currency_data.dart - Base de données des devises
/// ✅ exchange_rate.dart - Modèle de taux de change
/// ✅ rate_point.dart - Point d'historique de taux
/// ✅ providers.dart - Providers Riverpod
/// ✅ rates_repository.dart - Repository avec cache
/// 
/// FEATURES :
/// ✅ converter_controller.dart - Contrôleur de conversion
/// ✅ converter_page.dart - Page principale (UNIQUE)
/// ✅ calculator_keypad.dart - Clavier personnalisé
/// ✅ currency_selector.dart - Sélecteur de devise
/// ✅ result_display.dart - Affichage du résultat
/// 
/// ============================================================================
/// 🎯 BONNES PRATIQUES UTILISÉES
/// ============================================================================
/// 
/// ✅ Architecture Single Page Application (SPA)
/// ✅ Séparation des responsabilités (Clean Architecture)
/// ✅ Immutabilité des modèles (const constructors)
/// ✅ Type safety avec Dart null safety
/// ✅ Documentation exhaustive de tout le code
/// ✅ Gestion d'erreurs robuste avec Failures
/// ✅ Cache intelligent pour mode offline
/// ✅ Tests unitaires possibles (injection de dépendances)
/// ✅ Code maintenable et extensible
/// ✅ Performance optimisée (const, caching)
/// ✅ Accessibilité (Material Design guidelines)
/// 
/// ============================================================================
/// 📚 RESSOURCES
/// ============================================================================
/// 
/// API Utilisée :
/// - Frankfurter API: https://www.frankfurter.app/
/// 
/// Documentation Flutter :
/// - Riverpod: https://riverpod.dev/
/// - GoRouter: https://pub.dev/packages/go_router
/// - Dio: https://pub.dev/packages/dio
/// 
/// ============================================================================

