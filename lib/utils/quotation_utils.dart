import 'package:pract_01/models/quotation/get_all_quotation_model.dart';

List<Quotation> filterQuotations(List<Quotation> allQuotations, String filter) {
  final now = DateTime.now();

  switch (filter) {
    case 'Hoy':
      return allQuotations.where((quotation) {
        final createdAt =
            DateTime.parse(quotation.attributes.createdAt.toString()).toLocal();
        return createdAt.year == now.year &&
            createdAt.month == now.month &&
            createdAt.day == now.day;
      }).toList();

    case 'Ayer':
      final yesterday = now.subtract(const Duration(days: 1));
      return allQuotations.where((quotation) {
        final createdAt =
            DateTime.parse(quotation.attributes.createdAt.toString()).toLocal();
        return createdAt.year == yesterday.year &&
            createdAt.month == yesterday.month &&
            createdAt.day == yesterday.day;
      }).toList();

    case 'Semana':
      final startOfWeek = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: now.weekday - 1));
      return allQuotations.where((quotation) {
        final createdAt =
            DateTime.parse(quotation.attributes.createdAt.toString()).toLocal();
        return createdAt.isAfter(startOfWeek);
      }).toList();

    case 'Mes':
      return allQuotations.where((quotation) {
        final createdAt =
            DateTime.parse(quotation.attributes.createdAt.toString()).toLocal();
        return createdAt.year == now.year && createdAt.month == now.month;
      }).toList();

    default:
      return allQuotations;
  }
}
