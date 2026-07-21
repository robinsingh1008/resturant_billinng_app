class PhoneNumberUtils {
  const PhoneNumberUtils._();

  static String normalizeLocalNumber(String value, {String countryCode = ''}) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';

    final countryCodeDigits = countryCode.replaceAll(RegExp(r'\D'), '');
    if (countryCodeDigits.isNotEmpty &&
        digits.startsWith(countryCodeDigits) &&
        digits.length > 10) {
      return digits.substring(countryCodeDigits.length);
    }

    if (digits.length > 10) {
      return digits.substring(digits.length - 10);
    }

    return digits;
  }
}
