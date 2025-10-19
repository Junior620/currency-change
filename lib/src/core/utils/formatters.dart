/// ============================================================================
/// FORMATTERS UTILITY
/// ============================================================================
///
/// Fonctions utilitaires pour formater des nombres, devises, dates et temps.
///
/// Toutes les fonctions supportent l'internationalisation (i18n) via le
/// paramètre locale pour adapter le formatage à la langue de l'utilisateur.
///
/// Fonctions disponibles :
/// - formatCurrency() : Formate un montant avec symbole de devise
/// - formatNumber() : Formate un nombre avec séparateurs localisés
/// - formatPercentage() : Formate un pourcentage avec signe +/-
/// - formatDate() : Formate une date (ex: "15 janv. 2024")
/// - formatTime() : Formate une heure (ex: "14:30")
/// - formatRelativeTime() : Temps relatif (ex: "Il y a 5 min")
///
/// Utilisation :
/// ```dart
/// formatCurrency(123.45, 'USD', 'en'); // "$123.45"
/// formatNumber(1234.56, 'fr'); // "1 234,56"
/// formatPercentage(2.5); // "+2.50%"
/// ```
/// ============================================================================

import 'package:intl/intl.dart';

/// Formate un montant avec le symbole de devise et selon la locale
///
/// @param amount : Montant à formater
/// @param currencyCode : Code ISO de la devise (ex: 'USD', 'EUR')
/// @param locale : Locale pour le formatage (ex: 'en', 'fr')
/// @return String formaté (ex: "$123.45" ou "123,45 €")
///
/// Exemples :
/// ```dart
/// formatCurrency(123.45, 'USD', 'en'); // "$123.45"
/// formatCurrency(123.45, 'EUR', 'fr'); // "123,45 €"
/// ```
String formatCurrency(double amount, String currencyCode, String locale) {
  final formatter = NumberFormat.currency(
    locale: locale,
    symbol: currencyCode,
    decimalDigits: 2,
  );
  return formatter.format(amount);
}

/// Formate un nombre avec les séparateurs selon la locale
///
/// @param number : Nombre à formater
/// @param locale : Locale pour le formatage (ex: 'en', 'fr')
/// @param decimals : Nombre de décimales (défaut: 2)
/// @return String formaté avec séparateurs appropriés
///
/// Exemples :
/// ```dart
/// formatNumber(1234.56, 'en'); // "1,234.56"
/// formatNumber(1234.56, 'fr'); // "1 234,56"
/// formatNumber(1234.567, 'en', decimals: 3); // "1,234.567"
/// ```
String formatNumber(double number, String locale, {int decimals = 2}) {
  final formatter = NumberFormat.decimalPatternDigits(
    locale: locale,
    decimalDigits: decimals,
  );
  return formatter.format(number);
}

/// Formate un pourcentage avec signe +/- et décimales
///
/// @param value : Valeur du pourcentage (ex: 2.5 pour 2.5%)
/// @param decimals : Nombre de décimales (défaut: 2)
/// @return String formaté avec signe (ex: "+2.50%" ou "-1.25%")
///
/// Exemples :
/// ```dart
/// formatPercentage(2.5); // "+2.50%"
/// formatPercentage(-1.25); // "-1.25%"
/// formatPercentage(0.5, decimals: 1); // "+0.5%"
/// ```
String formatPercentage(double value, {int decimals = 2}) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(decimals)}%';
}

/// Formate une date selon la locale
///
/// @param date : Date à formater
/// @param locale : Locale pour le formatage (ex: 'en', 'fr')
/// @return Date formatée (ex: "Jan 15, 2024" ou "15 janv. 2024")
///
/// Exemples :
/// ```dart
/// formatDate(DateTime(2024, 1, 15), 'en'); // "Jan 15, 2024"
/// formatDate(DateTime(2024, 1, 15), 'fr'); // "15 janv. 2024"
/// ```
String formatDate(DateTime date, String locale) {
  return DateFormat.yMMMd(locale).format(date);
}

/// Formate une heure selon la locale
///
/// @param time : Heure à formater
/// @param locale : Locale pour le formatage (ex: 'en', 'fr')
/// @return Heure formatée (ex: "2:30 PM" ou "14:30")
///
/// Exemples :
/// ```dart
/// formatTime(DateTime(2024, 1, 15, 14, 30), 'en'); // "2:30 PM"
/// formatTime(DateTime(2024, 1, 15, 14, 30), 'fr'); // "14:30"
/// ```
String formatTime(DateTime time, String locale) {
  return DateFormat.Hm(locale).format(time);
}

/// Formate un temps relatif (ex: "Il y a 5 minutes")
///
/// Supporte plusieurs niveaux de granularité :
/// - Moins d'1 minute : "À l'instant" / "Just now"
/// - Moins d'1 heure : "Il y a X min" / "X min ago"
/// - Moins d'1 jour : "Il y a X h" / "X h ago"
/// - Moins d'1 mois : "Il y a X j" / "X d ago"
/// - Plus d'1 mois : "Il y a X mois" / "X mo ago"
///
/// @param dateTime : Date/heure à comparer avec maintenant
/// @param locale : Locale pour les textes (ex: 'en', 'fr')
/// @return Temps relatif formaté
///
/// Exemples :
/// ```dart
/// formatRelativeTime(DateTime.now(), 'fr'); // "À l'instant"
/// formatRelativeTime(DateTime.now().subtract(Duration(minutes: 5)), 'en'); // "5 min ago"
/// ```
String formatRelativeTime(DateTime dateTime, String locale) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    // Moins d'une minute
    return locale == 'fr' ? 'À l\'instant' : 'Just now';
  } else if (difference.inMinutes < 60) {
    // Moins d'une heure
    final minutes = difference.inMinutes;
    return locale == 'fr'
        ? 'Il y a $minutes min'
        : '$minutes min ago';
  } else if (difference.inHours < 24) {
    // Moins d'un jour
    final hours = difference.inHours;
    return locale == 'fr'
        ? 'Il y a $hours h'
        : '$hours h ago';
  } else if (difference.inDays < 30) {
    // Moins d'un mois
    final days = difference.inDays;
    return locale == 'fr'
        ? 'Il y a $days j'
        : '$days d ago';
  } else {
    // Plus d'un mois
    final months = (difference.inDays / 30).floor();
    return locale == 'fr'
        ? 'Il y a $months mois'
        : '$months mo ago';
  }
}
