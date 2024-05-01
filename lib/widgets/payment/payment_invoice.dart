import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pract_01/models/payment/get_all_payment.dart';
import 'package:pract_01/utils/date_utils.dart' as util_format;
import 'package:share_plus/share_plus.dart';

void downloadInvoice(BuildContext context, Payment payment) async {
  double calculateTotal(List<Product> products) {
    double total = 0.0;
    for (var product in products) {
      total += product.value * product.quantity;
    }
    return total;
  }

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
                      'Código de Pago - ${payment.attributes.cotizacion.data!.id}',
                      style: headerStyle,
                    ),
                  ),
                  pw.Column(
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 50,
                        child: image1,
                      ),
                      pw.Text(
                        'RUC: 20603425627', // Aquí pones el RUC real de la empresa
                        style: const pw.TextStyle(
                          fontSize: 12, // Ajusta el tamaño según necesites
                          color: PdfColors.grey, // Elige el color que prefieras
                        ),
                      ),
                    ],
                  ),
                ]),
            pw.SizedBox(height: 20),
            pw.Text(
              'Fecha de Creación: ${util_format.DateFacUtils.formatCreationDate(
                payment.attributes.createdAt.toString(),
              )}',
              style: titleStyle,
            ),
            pw.SizedBox(height: 10),
            pw.Text('Estado: ${payment.attributes.status}', style: normalStyle),
            pw.Text('Código Mercado Pago: ${payment.attributes.paymentId}',
                style: normalStyle),
            pw.SizedBox(height: 20),
            pw.Text('Información del Usuario:', style: titleStyle),
            pw.Text(
                'Nombre: ${payment.attributes.cotizacion.data!.attributes.name}',
                style: normalStyle),
            pw.Text(
                'Email: ${payment.attributes.cotizacion.data!.attributes.email}',
                style: normalStyle),
            pw.Text(
                'Teléfono: ${payment.attributes.cotizacion.data!.attributes.phone}',
                style: normalStyle),
            pw.Text(
                'Dirección: ${payment.attributes.cotizacion.data!.attributes.direction}',
                style: normalStyle),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total:', style: titleStyle),
                pw.Text(
                    'S/.${calculateTotal(payment.attributes.cotizacion.data!.attributes.products).toStringAsFixed(2)}',
                    style: titleStyle),
              ],
            ),
            pw.Text('Productos:', style: titleStyle),
            ...payment.attributes.cotizacion.data!.attributes.products
                .asMap()
                .entries
                .map((entry) {
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

  final String fileName =
      'factura_${payment.attributes.cotizacion.data!.id}.pdf';

  final directory = await getTemporaryDirectory();
  final String path = '${directory.path}/$fileName';

  final File file = File(path);
  final bytes = await pdf.save();
  await file.writeAsBytes(bytes);

  // Opción para compartir inmediatamente después de guardar el archivo
  Share.shareXFiles([XFile(path)], text: 'Aquí está tu factura.');

  // Mostrar una notificación de que el PDF fue compartido
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Factura guardada y lista para compartir: $fileName'),
      duration: const Duration(seconds: 3),
    ));
  }
}
