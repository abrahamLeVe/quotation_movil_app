import 'package:flutter/material.dart';
import 'package:pract_01/screens/quotation/edit_quotation_screen.dart';
import 'package:pract_01/screens/quotation/list_quotation_screen.dart';

class Routes {
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const QuotationListScreen(),
    '/edit': (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final quotationId = args['quotationId'] as int;
      return EditQuotationScreen(quotationId: quotationId);
    },
  };
}
