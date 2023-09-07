import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewScreen extends StatelessWidget {
  final String pdfUrl;

  const PdfViewScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comprobante de cotización'),
      ),
      body: SfPdfViewer.network(
        pdfUrl,
        // You can customize various properties here
        // For example:
        // pageLayoutMode: PdfPageLayoutMode.single,
        // scrollDirection: PdfScrollDirection.horizontal,
        // enableTextSelection: true,
        // ...
      ),
    );
  }
}
