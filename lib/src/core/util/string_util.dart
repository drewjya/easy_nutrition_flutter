import 'package:intl/intl.dart';

class StringUtil {
  static String formatDate(DateTime date) {
    final dateFormat = DateFormat('EEEE, d MMMM y', 'id_ID');
    return dateFormat.format(date);
  }
}
