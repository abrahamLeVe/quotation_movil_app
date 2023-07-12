import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart'
    as model_quotation;
import 'package:pract_01/models/quotation/update_quotation_model.dart';
import 'package:pract_01/providers/quotation_state.dart';

import 'package:pract_01/screens/home_screen.dart';
import 'package:pract_01/screens/quotation/quotation_actions.dart';
import 'package:pract_01/services/quotation_service.dart';
import 'package:pract_01/utils/dialog_utils.dart';
import 'package:pract_01/widgets/quotation/quotation_edit_item.dart';
import 'package:pract_01/widgets/send_pdf_to_mail.dart';
import 'package:pract_01/widgets/send_pdf_to_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class EditQuotationScreen extends StatefulWidget {
  final model_quotation.Quotation quotation;
  final Function(model_quotation.Quotation) onQuotationUpdated;

  const EditQuotationScreen({
    Key? key,
    required this.quotation,
    required this.onQuotationUpdated,
  }) : super(key: key);

  @override
  State<EditQuotationScreen> createState() => _EditQuotationScreenState();
}

class _EditQuotationScreenState extends State<EditQuotationScreen> {
  List<model_quotation.Product> products = [];
  late UpdateQuotationModel response;

  final bool _isLoading = false;
  late QuotationState quotationState;

  @override
  void initState() {
    super.initState();
    products =
        widget.quotation.attributes.products.cast<model_quotation.Product>();
    quotationState = Provider.of<QuotationState>(context, listen: false);
  }

  void updateProductPrice(int productIndex, int sizeIndex, double newPrice) {
    setState(() {
      final product = products[productIndex];
      if (product.size.isNotEmpty) {
        product.size[sizeIndex].quotationPrice = newPrice;
      } else {
        product.quotationPrice = newPrice;
      }
    });
  }

  void _handleButtonPress(BuildContext context) {
    showLoadingDialog(context);
  }

  void saveChanges() async {
    final quotationState = Provider.of<QuotationState>(context, listen: false);
    final updatedData = {
      'data': {
        'id': widget.quotation.id,
        'name': widget.quotation.attributes.name,
        'phone': widget.quotation.attributes.phone,
        'message': widget.quotation.attributes.message,
        'email': widget.quotation.attributes.email,
        'products': products.map((product) {
          return {
            'id': product.id,
            'name': product.name,
            'size': product.size.map((size) {
              return {
                'id': size.id,
                'val': size.val,
                'quantity': size.quantity,
                'quotation_price': size.quotationPrice ?? 0,
              };
            }).toList(),
            'quantity': product.quantity,
            'quotation_price': product.quotationPrice ?? 0,
          };
        }).toList(),
        "code_quotation": widget.quotation.attributes.codeQuotation
      },
    };

    try {
      if (mounted) {
        _handleButtonPress(context);
      }

      response = await QuotationService()
          .updateQuotation(widget.quotation.id, updatedData);

      // Simulación de carga de datos
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        widget.onQuotationUpdated(widget.quotation);
        quotationState.updateQuotationProvider(
            widget.quotation); // Actualizar la cotización en QuotationState
        Navigator.pop(context);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cotización actualizada'),
              content: const Text('La cotización se actualizó exitosamente.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true); // Confirmar
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        ).then((confirm) {
          if (confirm == true) {
            // Obtener la cotización actualizada del QuotationState
            final index = quotationState.quotations
                .indexWhere((q) => q.id == widget.quotation.id);

            // Verificar si se encontró un índice válido
            if (index != -1) {
              model_quotation.Quotation updatedQuotation =
                  quotationState.quotations[index];

              // Actualizar los datos de la cotización en los botones de descarga y envío
              String pdfUrl = updatedQuotation
                  .attributes.pdfVoucher.data![0].attributes.url;

              // Descargar el PDF
              _openPdf(pdfUrl);

              // Enviar el PDF por WhatsApp
              SendPdfToWhatsAppButton(
                customerName: updatedQuotation.attributes.name,
                code: updatedQuotation.attributes.codeQuotation,
                pdfFilePath: pdfUrl,
                phoneNumber: updatedQuotation.attributes.phone,
              );

              // Enviar el PDF por email
              SendEmailButton(
                customerName: updatedQuotation.attributes.name,
                code: updatedQuotation.attributes.codeQuotation,
                pdfFilePath: pdfUrl,
                recipientEmail: updatedQuotation.attributes.email,
              );
            }
          }
        });
      }
    } catch (error) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar la cotización')),
        );
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(selectedTabIndex: 1),
          ),
          (route) => false,
        );
      }
    }
  }

  Future<void> _openPdf(String url) async {
    final Uri url0 = Uri.parse(url);
    if (!await launchUrl(url0)) {
      throw Exception('Could not launch $url0');
    }
  }

  deleteQuotation() {
    deleteQuotation1(context, widget.quotation.id);
  }

  archiveQuotation() {
    archiveQuotation1(context, widget.quotation.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Consumer<QuotationState>(
                builder: (context, quotationState, _) {
                  return quotationDetailsColumn(quotationState.quotations);
                },
              ),
            ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Editar Cotización'),
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              onTap: deleteQuotation,
              child: const Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox(width: 8),
                  Text('Eliminar'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: archiveQuotation,
              child: const Row(
                children: [
                  Icon(Icons.archive),
                  SizedBox(width: 8),
                  Text('Archivar'),
                ],
              ),
            ),
            PopupMenuItem(
              child: Row(children: [
                widget.quotation.attributes.pdfVoucher.data!.isNotEmpty
                    ? const Icon(Icons.picture_as_pdf)
                    : const Icon(Icons.hourglass_empty_outlined),
                const SizedBox(width: 8),
                const Text('Descargar'),
              ]),
              onTap: () {
                // Obtener la cotización actualizada del QuotationState
                QuotationState quotationState =
                    Provider.of<QuotationState>(context, listen: false);
                final index = quotationState.quotations
                    .indexWhere((q) => q.id == widget.quotation.id);

                if (index != -1) {
                  // Obtener la URL actualizada del PDF
                  String pdfUrl = quotationState.quotations[index].attributes
                      .pdfVoucher.data![0].attributes.url;

                  // Descargar el PDF
                  _openPdf(pdfUrl);
                }
              },
            ),
            PopupMenuItem(
              child: const Row(children: [
                Icon(Icons.save),
                SizedBox(width: 8),
                Text('Guardar cambios'),
              ]),
              onTap: () {
                _isLoading ? null : saveChanges();
              },
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.send),
                  SizedBox(width: 8),
                  Text('Enviar PDF por WhatsApp'),
                ],
              ),
              onTap: () {
                // Obtener la cotización actualizada del QuotationState
                QuotationState quotationState =
                    Provider.of<QuotationState>(context, listen: false);
                final index = quotationState.quotations
                    .indexWhere((q) => q.id == widget.quotation.id);

                if (index != -1) {
                  // Obtener la URL actualizada del PDF
                  String pdfUrl = quotationState.quotations[index].attributes
                      .pdfVoucher.data![0].attributes.url;

                  // Enviar el PDF por WhatsApp
                  SendPdfToWhatsAppButton(
                    customerName: widget.quotation.attributes.name,
                    code: widget.quotation.attributes.codeQuotation,
                    pdfFilePath: pdfUrl,
                    phoneNumber: widget.quotation.attributes.phone,
                  );
                }
              },
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 8),
                  Text('Enviar PDF por email'),
                ],
              ),
              onTap: () {
                // Obtener la cotización actualizada del QuotationState
                QuotationState quotationState =
                    Provider.of<QuotationState>(context, listen: false);
                final index = quotationState.quotations
                    .indexWhere((q) => q.id == widget.quotation.id);

                if (index != -1) {
                  // Obtener la URL actualizada del PDF
                  String pdfUrl = quotationState.quotations[index].attributes
                      .pdfVoucher.data![0].attributes.url;

                  // Enviar el PDF por email
                  SendEmailButton(
                    customerName: widget.quotation.attributes.name,
                    code: widget.quotation.attributes.codeQuotation,
                    pdfFilePath: pdfUrl,
                    recipientEmail: widget.quotation.attributes.email,
                  );
                }
              },
            ),
          ],
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }

  Column quotationDetailsColumn(List<model_quotation.Quotation> quotations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Número: ${widget.quotation.attributes.codeQuotation}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Cliente: ${widget.quotation.attributes.name}',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'Email: ${widget.quotation.attributes.email}',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'Cel: ${widget.quotation.attributes.phone}',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'Mensaje: ${widget.quotation.attributes.message}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Text(
          'Productos: (${widget.quotation.attributes.products.length})',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, int productIndex) {
              final product = products[productIndex];
              return QuotationEditItem(
                product: product,
                productIndex: productIndex,
                products: products,
                onPriceUpdate: (productIndex, sizeIndex, newPrice) {
                  updateProductPrice(productIndex, sizeIndex, newPrice);
                  quotationState.updateQuotationProvider(widget.quotation);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
