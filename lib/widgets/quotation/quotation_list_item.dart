import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/screens/quotation/edit_quotation_screen.dart';
import 'package:pract_01/utils/date_utils.dart' as util_format;

class QuotationItem extends StatelessWidget {
  final Quotation quotation;

  const QuotationItem({Key? key, required this.quotation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Text(
              'Código: ${quotation.attributes.codeQuotation.toUpperCase()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado: En proceso',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            Text(
              util_format.DateUtils.formatCreationDate(
                quotation.attributes.createdAt.toString(),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditQuotationScreen(quotationId: quotation.id),
                  ),
                );
              },
              child: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}