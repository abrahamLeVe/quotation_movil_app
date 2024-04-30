import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pract_01/models/price/get_all_prices_model.dart';
import 'package:pract_01/utils/date_utils.dart' as util_format;

import 'package:share_plus/share_plus.dart';

void downloadProductInventori(
    BuildContext context, List<PriceModelData> products) async {
  final pdf = pw.Document();
  final pw.TextStyle titleStyle = pw.TextStyle(
    fontSize: 14,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.blue,
  );

  final pw.TextStyle headerStyle = pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromHex("#0000FF"));

  final pw.TextStyle normalStyle =
      pw.TextStyle(fontSize: 12, color: PdfColor.fromHex("#666666"));

  final img = await rootBundle.load('assets/logo_app.png');
  final imageBytes = img.buffer.asUint8List();
  pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));

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
                      'Inventario de productos',
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
                DateTime.now().toString(),
              )}',
              style: titleStyle,
            ),
            pw.Text('Productos:', style: titleStyle),
            ...products.asMap().entries.map((entry) {
              int index = entry.key;
              PriceModelData product = entry.value;

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Producto ${index + 1}: ${product.attributes.name}',
                      style: titleStyle),
                  pw.SizedBox(height: 10),
                  pw.Text('Detalles de Precios:', style: normalStyle),
                  ...product.attributes.prices.data
                      .map<pw.Widget>((priceDetail) {
                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              flex:
                                  3, // Ajusta según necesidad para el espacio de precios y medida
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                      'Precio: S/.${priceDetail.attributes.value.toStringAsFixed(2)}',
                                      style: normalStyle),
                                  pw.Text(
                                      'Medida: ${priceDetail.attributes.size.data?.attributes.name ?? "No especificado"}',
                                      style: normalStyle),
                                ],
                              ),
                            ),
                            pw.Expanded(
                              flex: 2, // Espacio para colores
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Colores:', style: normalStyle),
                                  pw.Wrap(
                                    spacing: 2,
                                    runSpacing: 5,
                                    children: priceDetail
                                        .attributes.productColors.data
                                        .map((color) => pw.Container(
                                              decoration: pw.BoxDecoration(
                                                color: PdfColor.fromHex(color
                                                    .attributes.code
                                                    .toString()),
                                                shape: pw.BoxShape.circle,
                                                border: pw.Border.all(
                                                  color: const PdfColor.fromInt(
                                                      0xff000000), // negro como ejemplo
                                                  width: 1, // ancho del borde
                                                ),
                                              ),
                                              width: 15,
                                              height: 15,
                                              margin: const pw.EdgeInsets.only(
                                                  right: 10),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        pw.Divider(),
                      ],
                    );
                  }).toList(),
                  pw.SizedBox(height: 20),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    ),
  );

  const String fileName = 'Inventario_productos.pdf';

  final directory = await getTemporaryDirectory();
  final String path = '${directory.path}/$fileName';

  final File file = File(path);
  final bytes = await pdf.save();
  await file.writeAsBytes(bytes);

  Share.shareXFiles(
    [XFile(path)],
    text: 'Aquí está su comprobante de cotización, Gracias por su preferencia.',
    subject: 'Inventario de productos',
    sharePositionOrigin: const Rect.fromLTWH(0, 0, 10, 10),
  );

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Cotización guardada y lista para compartir: $fileName'),
      duration: Duration(seconds: 3),
    ));
  }
}
