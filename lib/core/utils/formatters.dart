import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import '../constants/app_constants.dart';

/// Utility class for formatting currency, dates, and numbers
class Formatters {
  Formatters._();

  /// Format amount to Indonesian Rupiah currency
  static String formatCurrency(double amount, {String? currency}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: currency ?? AppConstants.currencySymbol,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format amount to compact currency (e.g., 1.5M, 2.3K)
  static String formatCompactCurrency(double amount) {
    if (amount >= 1000000000) {
      return '${AppConstants.currencySymbol} ${(amount / 1000000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000000) {
      return '${AppConstants.currencySymbol} ${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return '${AppConstants.currencySymbol} ${(amount / 1000).toStringAsFixed(1)}rb';
    }
    return formatCurrency(amount);
  }

  /// Format date to dd/MM/yyyy
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  /// Format date to dd MMMM yyyy (e.g., 16 November 2024)
  static String formatDateLong(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  /// Format time to HH:mm
  static String formatTime(DateTime time) {
    return DateFormat(AppConstants.timeFormat).format(time);
  }

  /// Format datetime to dd/MM/yyyy HH:mm
  static String formatDateTime(DateTime dateTime) {
    return DateFormat(AppConstants.dateTimeFormat).format(dateTime);
  }

  /// Format month and year (e.g., November 2024)
  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy', 'id_ID').format(date);
  }

  /// Format to Hijri date
  static String formatHijriDate(DateTime date) {
    final hijri = HijriCalendar.fromDate(date);
    return '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} H';
  }

  /// Format number with thousand separator
  static String formatNumber(double number) {
    final formatter = NumberFormat('#,##0', 'id_ID');
    return formatter.format(number);
  }

  /// Format percentage
  static String formatPercentage(double value, {int decimals = 2}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Format relative time (e.g., "2 hari yang lalu", "3 jam yang lalu")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  /// Parse currency string to double
  static double parseCurrency(String value) {
    // Remove currency symbol and thousand separator
    final cleaned = value
        .replaceAll(AppConstants.currencySymbol, '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();
    return double.tryParse(cleaned) ?? 0.0;
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  /// Get greeting based on time of day
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Assalamu\'alaikum, Selamat Pagi';
    } else if (hour < 15) {
      return 'Assalamu\'alaikum, Selamat Siang';
    } else if (hour < 18) {
      return 'Assalamu\'alaikum, Selamat Sore';
    } else {
      return 'Assalamu\'alaikum, Selamat Malam';
    }
  }
}
