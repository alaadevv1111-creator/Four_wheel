/// Shared date helpers for the booking flow.
///
/// The backend expects dates as 'yyyy-MM-dd' (see the Postman examples:
/// "start_date": "2026-07-05"), while some screens display dates as
/// 'Jul 04, 2026'. This class centralizes the parsing/formatting logic
/// so every controller uses the exact same rules instead of each one
/// re-implementing (and slightly diverging from) the same code.
class BookingDateUtils {
  static const Map<String, int> _months = {
    'jan': 1,
    'feb': 2,
    'mar': 3,
    'apr': 4,
    'may': 5,
    'jun': 6,
    'jul': 7,
    'aug': 8,
    'sep': 9,
    'oct': 10,
    'nov': 11,
    'dec': 12,
  };

  /// Parses dates like '2026-07-05', '2026-07-05T00:00:00', or 'Jul 04, 2026'.
  static DateTime? parse(String value) {
    final text = value.trim();
    if (text.isEmpty) return null;

    final direct = DateTime.tryParse(text);
    if (direct != null) return direct;

    final cleaned = text.replaceAll(',', '');
    final parts = cleaned.split(RegExp(r'\s+'));

    if (parts.length >= 3) {
      final rawMonth = parts[0].toLowerCase();
      final key = rawMonth.substring(0, rawMonth.length >= 3 ? 3 : rawMonth.length);
      final month = _months[key];
      final day = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);

      if (month != null && day != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    return null;
  }

  /// Converts any supported date string into the 'yyyy-MM-dd' format the API expects.
  static String toApiDate(String value) {
    final date = parse(value);
    if (date == null) return value;

    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  /// Number of rental days between two date strings (any supported format).
  static int daysBetween(String start, String end, {int fallback = 1}) {
    final startDate = parse(start);
    final endDate = parse(end);

    if (startDate == null || endDate == null) return fallback;

    final days = endDate.difference(startDate).inDays;
    return days <= 0 ? 1 : days;
  }
}