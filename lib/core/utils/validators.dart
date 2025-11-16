/// Utility class for input validation
class Validators {
  Validators._();

  /// Validate if string is not empty
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Validate phone number (Indonesian format)
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    final phoneRegex = RegExp(r'^(08|62)[0-9]{8,12}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s-]'), ''))) {
      return 'Format nomor telepon tidak valid';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    if (value.length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }
    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    if (value.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter';
    }
    return null;
  }

  /// Validate number (positive)
  static String? validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return '$fieldName harus berupa angka';
    }
    if (number <= 0) {
      return '$fieldName harus lebih besar dari 0';
    }
    return null;
  }

  /// Validate amount (currency)
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Jumlah tidak boleh kosong';
    }
    // Remove currency formatting
    final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    final amount = double.tryParse(cleaned);
    if (amount == null) {
      return 'Jumlah tidak valid';
    }
    if (amount <= 0) {
      return 'Jumlah harus lebih besar dari 0';
    }
    return null;
  }

  /// Validate password strength
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung minimal 1 huruf besar';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password harus mengandung minimal 1 huruf kecil';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung minimal 1 angka';
    }
    return null;
  }

  /// Validate confirm password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != password) {
      return 'Password tidak cocok';
    }
    return null;
  }

  /// Validate date is not in the future
  static String? validatePastDate(DateTime? value) {
    if (value == null) {
      return 'Tanggal tidak boleh kosong';
    }
    if (value.isAfter(DateTime.now())) {
      return 'Tanggal tidak boleh di masa depan';
    }
    return null;
  }

  /// Validate date is not in the past
  static String? validateFutureDate(DateTime? value) {
    if (value == null) {
      return 'Tanggal tidak boleh kosong';
    }
    if (value.isBefore(DateTime.now())) {
      return 'Tanggal harus di masa depan';
    }
    return null;
  }

  /// Validate URL format
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL tidak boleh kosong';
    }
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    if (!urlRegex.hasMatch(value)) {
      return 'Format URL tidak valid';
    }
    return null;
  }

  /// Validate NPWP (Indonesian tax number)
  static String? validateNPWP(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NPWP tidak boleh kosong';
    }
    final npwpRegex = RegExp(r'^\d{2}\.\d{3}\.\d{3}\.\d{1}-\d{3}\.\d{3}$');
    if (!npwpRegex.hasMatch(value)) {
      return 'Format NPWP tidak valid (XX.XXX.XXX.X-XXX.XXX)';
    }
    return null;
  }
}
