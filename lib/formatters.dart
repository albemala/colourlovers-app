extension NumberFormatting on int? {
  String formatted() => (this ?? 0).toString();
}

extension DateTimeFormatting on DateTime? {
  String formatted() {
    final dateTime = this;
    if (dateTime == null) return '';

    final year = dateTime.year;
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year/$month/$day';
  }
}

extension DoubleToIntString on String {
  String toIntString() {
    final value = double.tryParse(this);
    if (value == null) return this;
    return value.truncate().toString();
  }
}
