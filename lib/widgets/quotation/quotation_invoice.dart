import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/utils/date_utils.dart' as util_format;
import 'package:share_plus/share_plus.dart';

void downloadQuotation(BuildContext context, Quotation quotation) async {
  final pdf = pw.Document();

  final pw.TextStyle headerStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromHex("#0000FF"));

  final pw.TextStyle titleStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromHex("#333333"));

  final pw.TextStyle normalStyle =
      pw.TextStyle(fontSize: 12, color: PdfColor.fromHex("#666666"));

  final img = await rootBundle.load('assets/logo_app.png');
  final imageBytes = img.buffer.asUint8List();
  pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));
  // final List<String> recipients = [quotation.attributes.email];

  pdf.addPage(
    pw.MultiPage(
      build: (pw.Context context) => [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Header(
                    level: 0,
                    child: pw.Text(
                      'Código de Cotización - ${quotation.id}',
                      style: headerStyle,
                    ),
                  ),
                  pw.Container(
                    alignment: pw.Alignment.center,
                    height: 50,
                    child: image1,
                  ),
                ]),
            pw.SizedBox(height: 20),
            pw.Text(
              'Fecha de Creación: ${util_format.DateFacUtils.formatCreationDate(
                quotation.attributes.createdAt.toString(),
              )}',
              style: titleStyle,
            ),
            pw.SizedBox(height: 10),
            pw.Text('Estado: ${quotation.attributes.codeStatus}',
                style: normalStyle),
            pw.Text(
              'Nota: ${quotation.attributes.notes ?? ''}',
              style: normalStyle,
            ),
            pw.SizedBox(height: 20),
            pw.Text('Información del Usuario:', style: titleStyle),
            pw.Text('Nombre: ${quotation.attributes.name}', style: normalStyle),
            pw.Text('Email: ${quotation.attributes.email}', style: normalStyle),
            pw.Text('Teléfono: ${quotation.attributes.phone}',
                style: normalStyle),
            pw.Text('Dirección: ${quotation.attributes.direction}',
                style: normalStyle),
            pw.SizedBox(height: 20),
            pw.Text('Productos:', style: titleStyle),
            ...quotation.attributes.products.asMap().entries.map((entry) {
              int index = entry.key;
              var product = entry.value;
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Producto ${index + 1}: ${product.title}',
                      style: titleStyle),
                  pw.Text('Cantidad: ${product.quantity}', style: normalStyle),
                  pw.Text('Precio Unitario: ${product.value}',
                      style: normalStyle),
                  pw.Text('Tamaño: ${product.size ?? 'N/A'}',
                      style: normalStyle),
                  pw.SizedBox(height: 10),
                  pw.Text('Colores:'),
                  pw.Wrap(
                    spacing: 8,
                    children: product.colors.map<pw.Widget>((color) {
                      return pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Container(
                            width: 15,
                            height: 15,
                            decoration: pw.BoxDecoration(
                              color:
                                  PdfColor.fromHex(color.color.attributes.code),
                              shape: pw.BoxShape.circle,
                            ),
                            margin: const pw.EdgeInsets.only(right: 10),
                          ),
                          pw.Text(
                              '${color.color.attributes.name} (${color.quantity})',
                              style: normalStyle),
                        ],
                      );
                    }).toList(),
                  ),
                  pw.SizedBox(height: 10),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    ),
  );

  final String fileName = 'Cotizacion_${quotation.id}.pdf';

  final directory = await getTemporaryDirectory();
  final String path = '${directory.path}/$fileName';

  final File file = File(path);
  final bytes = await pdf.save();
  await file.writeAsBytes(bytes);

  Share.shareXFiles(
    [XFile(path)],
    text: 'Aquí está su comprobante de cotización, Gracias por su preferencia.',
    subject: 'Cotización ${quotation.id}',
    sharePositionOrigin: const Rect.fromLTWH(0, 0, 10, 10),
  );

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Cotización guardada y lista para compartir: $fileName'),
      duration: const Duration(seconds: 3),
    ));
  }
}
