import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/screens/quotation/btn_edit_quotation_screen.dart';
import 'package:pract_01/screens/quotation/edit_quotation_screen.dart';
import 'package:pract_01/utils/date_utils.dart' as util_format;
import 'package:pract_01/widgets/quotation/quotation_invoice.dart';

class QuotationItem extends StatelessWidget {
  final Quotation quotation;

  const QuotationItem({
    Key? key,
    required this.quotation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        decoration: BoxDecoration(color: Colors.amber[50]),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Icon(Icons.description, color: Colors.blueGrey[400]),
          title: Text(
            'Código: ${quotation.id}',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estado: ${quotation.attributes.codeStatus}',
                style: TextStyle(
                  color: quotation.attributes.codeStatus == "En progreso"
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Fecha: ${util_format.DateUtils.formatCreationDate(quotation.attributes.updatedAt.toString())}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botón de editar cotización

              // Condición para mostrar el botón de descarga
              // if (quotation.attributes.codeStatus == "Cerrada" ||
              //     quotation.attributes.codeStatus == "Cancelada")
              IconButton(
                icon: const Icon(Icons.cloud_download),
                onPressed: () {
                  downloadQuotation(context, quotation);
                },
                tooltip: 'Descargar comprobante',
              ),
              if (quotation.attributes.codeStatus == "En progreso" ||
                  quotation.attributes.codeStatus == "Completada")
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue[300]),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditQuotationScreen(quotation: quotation),
                      ),
                    );
                  },
                  tooltip: 'Editar cotización',
                ),
              if (quotation.attributes.codeStatus == "Cancelada")
                IconButton(
                  icon: const Icon(Icons.archive),
                  onPressed: () {
                    archiveQuotation(context, quotation.id);
                  },
                  tooltip: 'Archivar pago',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
