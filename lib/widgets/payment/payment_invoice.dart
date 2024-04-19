import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pract_01/models/payment/get_all_payment.dart';
import 'package:open_file/open_file.dart';
import 'package:pract_01/utils/date_utils.dart' as util_format;

void downloadInvoice(BuildContext context, Payment payment) async {
  // Crear el documento PDF
  final pdf = pw.Document();

  // Definición de estilos de texto con colores hexadecimales
  final pw.TextStyle headerStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromHex("#0000FF") // Azul para encabezados
      );

  final pw.TextStyle titleStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromHex("#333333") // Gris oscuro para títulos
      );

  final pw.TextStyle normalStyle = pw.TextStyle(
      fontSize: 12,
      color: PdfColor.fromHex("#666666") // Gris más claro para texto normal
      );

  pdf.addPage(
    pw.MultiPage(
      build: (pw.Context context) => [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Código de Pago - ${payment.attributes.cotizacion.data!.id}',
                style: headerStyle,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Fecha de Creación: ${util_format.DateUtils.formatCreationDate(
                payment.attributes.createdAt.toString(),
              )}',
              style: titleStyle,
            ),
            pw.SizedBox(height: 10),
            pw.Text('Estado: Aprobado', style: normalStyle),
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
                    spacing: 8, // Espacio horizontal entre los colores
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

  // Guardar el documento como archivo
  final String fileName =
      'factura_${payment.attributes.cotizacion.data!.id}.pdf';

  // Obtener la ruta del directorio temporal
  final directory = await getTemporaryDirectory();
  final String path = '${directory.path}/$fileName';

  // Guardar el archivo y mostrar un diálogo de confirmación
  final File file = File(path);
  final bytes = await pdf.save();
  await file.writeAsBytes(bytes);

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text('Factura descargada: $fileName'),
        ),
        TextButton(
          onPressed: () {
            OpenFile.open(path);
          },
          child: const Text('Abrir', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          child: const Text('Cerrar', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
    duration: const Duration(minutes: 5),
  ));
}
