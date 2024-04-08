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

    case 'Vencido':
      return allQuotations.where((quotation) {
        final dateLimit =
            DateTime.parse(quotation.attributes.dateLimit.toString());

        final now = DateTime.now().toUtc();

        return dateLimit.isBefore(now);
      }).toList();

    case 'En progreso':
      final inProgressQuotations = allQuotations
          .where(
              (quotation) => quotation.attributes.codeStatus == "En progreso")
          .toList();

      return inProgressQuotations;

    case 'Cancelada':
      final canceledQuotations = allQuotations
          .where((quotation) => quotation.attributes.codeStatus == "Cancelada")
          .toList();

      return canceledQuotations;

    case 'Cerrada':
      final closedQuotations = allQuotations
          .where((quotation) => quotation.attributes.codeStatus == "Cerrada")
          .toList();

      return closedQuotations;

    case 'Completada':
      final completedQuotations = allQuotations
          .where((quotation) => quotation.attributes.codeStatus == "Completada")
          .toList();

      return completedQuotations;

    case 'Descendente':
      final sortedQuotations = List<Quotation>.from(allQuotations);
      sortedQuotations.sort((a, b) {
        final createdAtA = a.attributes.createdAt;
        final createdAtB = b.attributes.createdAt;

        return createdAtB.compareTo(createdAtA);
      });
      return sortedQuotations;

    default:
      return allQuotations;
  }
}
