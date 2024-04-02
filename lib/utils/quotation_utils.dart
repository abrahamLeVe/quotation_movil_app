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

    case 'Atendido':
    // return allQuotations.where((quotation) {
    //   return quotation.attributes.pdfVoucher?.data?.isNotEmpty == true;
    // }).toList();

    case 'En proceso':
    // return allQuotations.where((quotation) {
    //   return quotation.attributes.pdfVoucher?.data?.isNotEmpty == false;
    // }).toList();

    case 'Descendente':
    // final sortedQuotations = List<Quotation>.from(allQuotations);
    // sortedQuotations.sort((a, b) {
    //   final createdAtA = a.attributes.createdAt;
    //   final createdAtB = b.attributes.createdAt;

    //   if (createdAtA != null && createdAtB != null) {
    //     return createdAtB.compareTo(createdAtA);
    //   }

    //   // Manejo en caso de que uno o ambos valores sean null
    //   return 0;
    // });
    // return sortedQuotations;

    default:
      return allQuotations;
  }
}
