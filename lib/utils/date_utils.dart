const List<String> _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// Dates are stored in SQLite as 'YYYY-MM-DD' text, which also sorts
/// correctly with ORDER BY.
String dateToIso(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

String todayIso() => dateToIso(DateTime.now());

/// '2026-10-10' -> '10 Oct 2026' (falls back to the raw text).
String formatDate(String iso) {
  final d = DateTime.tryParse(iso);
  if (d == null) return iso;
  return '${d.day} ${_months[d.month - 1]} ${d.year}';
}
