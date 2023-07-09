import 'package:intl/intl.dart';

class DateUtils {
  static String formatCreationDate(String createdAt) {
    final creationDate = DateTime.parse(createdAt).toLocal();
    final now = DateTime.now();
    final formatter = DateFormat.yMMMMEEEEd('es_PE');
    final formatterTime = DateFormat.Hm('es_PE');

    if (creationDate.year == now.year &&
        creationDate.month == now.month &&
        creationDate.day == now.day) {
      return 'Hoy ${formatterTime.format(creationDate)}';
    } else {
      return '${formatter.format(creationDate)} ${formatterTime.format(creationDate)}';
    }
  }
}
