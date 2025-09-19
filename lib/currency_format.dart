/// Lightweight "SP" formatter without intl.
String formatRupiah(int amount) {
  final s = amount.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final left = s.length - i;
    buf.write(s[i]);
    if (left > 1 && left % 3 == 1) buf.write('.');
  }
  return '${buf.toString()} SP';
}
