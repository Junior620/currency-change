/// ============================================================================
/// CURRENCY DATA
/// ============================================================================
///
/// Base de données statique de toutes les devises supportées par l'application.
///
/// Structure :
/// - Codes ISO 4217 des devises (USD, EUR, etc.)
/// - Noms complets en anglais
/// - Chemins vers les icônes/drapeaux
///
/// Cette classe sert de source unique de vérité pour toutes les devises
/// disponibles dans l'application. Elle est utilisée par :
/// - Le sélecteur de devises
/// - Les formulaires de conversion
/// - Les listes de favoris
///
/// Pour ajouter une nouvelle devise :
/// 1. Ajouter l'entrée dans le Map currencies
/// 2. Ajouter l'icône correspondante dans assets/flags/
/// 3. Mettre à jour le fichier pubspec.yaml si nécessaire
///
/// Utilisation :
/// ```dart
/// final name = CurrencyData.getName('USD'); // "US Dollar"
/// final flag = CurrencyData.getFlag('EUR'); // "assets/flags/eur.png"
/// final allCodes = CurrencyData.codes; // ['USD', 'EUR', ...]
/// ```
/// ============================================================================

/// Base de données de toutes les devises supportées avec leurs métadonnées
class CurrencyData {
  /// Map de toutes les devises avec code ISO, nom et chemin d'icône
  ///
  /// Format : 'CODE': {'name': 'Nom complet', 'flag': 'chemin/vers/icone.png'}
  static const Map<String, Map<String, String>> currencies = {
    'USD': {'name': 'US Dollar', 'flag': 'assets/flags/usd.png'},
    'EUR': {'name': 'Euro', 'flag': 'assets/flags/eur.png'},
    'GBP': {'name': 'British Pound', 'flag': 'assets/flags/gbp.png'},
    'JPY': {'name': 'Japanese Yen', 'flag': 'assets/flags/jpy.png'},
    'CHF': {'name': 'Swiss Franc', 'flag': 'assets/flags/chf.png'},
    'CAD': {'name': 'Canadian Dollar', 'flag': 'assets/flags/cad.png'},
    'AUD': {'name': 'Australian Dollar', 'flag': 'assets/flags/aud.png'},
    'NZD': {'name': 'New Zealand Dollar', 'flag': 'assets/flags/nzd.png'},
    'CNY': {'name': 'Chinese Yuan', 'flag': 'assets/flags/cny.png'},
    'INR': {'name': 'Indian Rupee', 'flag': 'assets/flags/inr.png'},
    'BRL': {'name': 'Brazilian Real', 'flag': 'assets/flags/brl.png'},
    'ZAR': {'name': 'South African Rand', 'flag': 'assets/flags/zar.png'},
    'MXN': {'name': 'Mexican Peso', 'flag': 'assets/flags/mxn.png'},
    'SGD': {'name': 'Singapore Dollar', 'flag': 'assets/flags/sgd.png'},
    'HKD': {'name': 'Hong Kong Dollar', 'flag': 'assets/flags/hkd.png'},
    'NOK': {'name': 'Norwegian Krone', 'flag': 'assets/flags/nok.png'},
    'SEK': {'name': 'Swedish Krona', 'flag': 'assets/flags/sek.png'},
    'DKK': {'name': 'Danish Krone', 'flag': 'assets/flags/dkk.png'},
    'PLN': {'name': 'Polish Zloty', 'flag': 'assets/flags/pln.png'},
    'THB': {'name': 'Thai Baht', 'flag': 'assets/flags/thb.png'},
    'MYR': {'name': 'Malaysian Ringgit', 'flag': 'assets/flags/myr.png'},
    'IDR': {'name': 'Indonesian Rupiah', 'flag': 'assets/flags/idr.png'},
    'HUF': {'name': 'Hungarian Forint', 'flag': 'assets/flags/huf.png'},
    'CZK': {'name': 'Czech Koruna', 'flag': 'assets/flags/czk.png'},
    'ILS': {'name': 'Israeli Shekel', 'flag': 'assets/flags/ils.png'},
    'CLP': {'name': 'Chilean Peso', 'flag': 'assets/flags/clp.png'},
    'PHP': {'name': 'Philippine Peso', 'flag': 'assets/flags/php.png'},
    'AED': {'name': 'UAE Dirham', 'flag': 'assets/flags/aed.png'},
    'SAR': {'name': 'Saudi Riyal', 'flag': 'assets/flags/sar.png'},
    'TRY': {'name': 'Turkish Lira', 'flag': 'assets/flags/try.png'},
    'KRW': {'name': 'South Korean Won', 'flag': 'assets/flags/krw.png'},
    'RUB': {'name': 'Russian Ruble', 'flag': 'assets/flags/rub.png'},
  };

  /// Récupère la liste de tous les codes de devises
  ///
  /// @return Liste des codes ISO (ex: ['USD', 'EUR', 'GBP', ...])
  static List<String> get codes => currencies.keys.toList();

  /// Récupère le nom complet d'une devise
  ///
  /// @param code : Code ISO de la devise (ex: 'USD')
  /// @return Nom complet (ex: 'US Dollar') ou le code si non trouvé
  static String getName(String code) {
    return currencies[code]?['name'] ?? code;
  }

  /// Récupère le chemin de l'icône d'une devise
  ///
  /// @param code : Code ISO de la devise (ex: 'EUR')
  /// @return Chemin vers l'asset (ex: 'assets/flags/eur.png')
  static String getFlag(String code) {
    return currencies[code]?['flag'] ?? 'assets/flags/default.png';
  }
}
