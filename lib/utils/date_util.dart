String formatDateTime(String dateTimeStr) {
  final DateTime dt = DateTime.parse(dateTimeStr);

  const days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];

  const months = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  String dayName = days[dt.weekday % 7];
  String monthName = months[dt.month];

  return '$dayName, ${dt.day} $monthName ${dt.year}';
}
