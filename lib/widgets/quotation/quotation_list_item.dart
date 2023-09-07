import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/screens/product/pdf_view_screen.dart';
import 'package:pract_01/screens/quotation/quotation_actions.dart';
import 'package:pract_01/utils/date_utils.dart' as util_format;

class QuotationItem extends StatelessWidget {
  final Quotation quotation;
  final void Function(Quotation) openEditQuotationScreen;

  const QuotationItem({
    Key? key,
    required this.quotation,
    required this.openEditQuotationScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Text(
              'Código: ${quotation.attributes.codeQuotation?.toUpperCase()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (quotation.attributes.pdfVoucher?.data?.isNotEmpty ?? false)
              const Text(
                'Estado: Atendido',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            if (quotation.attributes.pdfVoucher?.data?.isEmpty ?? true)
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
            if (quotation.attributes.pdfVoucher?.data?.isNotEmpty ?? false)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewScreen(
                        pdfUrl: quotation
                            .attributes.pdfVoucher!.data![0].attributes.url,
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding:
                      EdgeInsets.only(right: 16), // Agrega un margen derecho
                  child: Icon(
                    Icons.picture_as_pdf,
                    color: Colors.blue, // Cambia el color a tu preferencia
                  ),
                ),
              ),
            if (quotation.attributes.pdfVoucher?.data?.isNotEmpty ?? false)
              GestureDetector(
                onTap: () {
                  archiveQuotation(context, quotation.id);
                },
                child: const Padding(
                  padding:
                      EdgeInsets.only(right: 16), // Agrega un margen derecho
                  child: Icon(
                    Icons.archive,
                    color: Colors.blue, // Cambia el color a tu preferencia
                  ),
                ),
              ),
            GestureDetector(
              onTap: () {
                openEditQuotationScreen(quotation);
              },
              child: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
