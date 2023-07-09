import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_details_quotation_model.dart';
import 'package:pract_01/screens/quotation/list_quotation_screen.dart';
import 'package:pract_01/services/quotation_service.dart';
import 'package:pract_01/utils/dialog_utils.dart';
import 'package:pract_01/widgets/quotation/quotation_edit_item.dart';
import 'package:pract_01/widgets/send_pdf_to_mail.dart';
import 'package:pract_01/widgets/send_pdf_to_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';

class EditQuotationScreen extends StatefulWidget {
  final int quotationId;

  const EditQuotationScreen({Key? key, required this.quotationId})
      : super(key: key);

  @override
  State<EditQuotationScreen> createState() => _EditQuotationScreenState();
}

class _EditQuotationScreenState extends State<EditQuotationScreen> {
  List<ProductDeail> products = [];
  bool _isLoading = false;
  late GetDetailsQuotation productDetail;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> refreshData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final quotationDetails =
          await QuotationService().getDeatilsQuotation(widget.quotationId);
      setState(() {
        _isLoading = false;
        productDetail = quotationDetails;
        products = productDetail.data.attributes.products;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error al cargar los detalles de la cotización')),
        );
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const QuotationListScreen()),
        );
      }
    }
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
    final updatedData = {
      'data': {
        'id': productDetail.data.id,
        'name': productDetail.data.attributes.name,
        'phone': productDetail.data.attributes.phone,
        'message': productDetail.data.attributes.message,
        'email': productDetail.data.attributes.email,
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
        "code_quotation": productDetail.data.attributes.codeQuotation
      },
    };

    try {
      if (mounted) {
        _handleButtonPress(context);
      }

      await QuotationService().updateQuotation(widget.quotationId, updatedData);

      if (mounted) {
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
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditQuotationScreen(
                              quotationId: productDetail.data.id)),
                    );
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar la cotización')),
        );
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const QuotationListScreen()),
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

  void deleteQuotation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar cotización permanentemente'),
          content: const Text(
              '¿Estás seguro de eliminar esta Cotización de forma permanente?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Respuesta negativa: No
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Respuesta positiva: Sí
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed != null && confirmed) {
        performDeleteAction();
      }
    });
  }

  void performDeleteAction() async {
    _handleButtonPress(context);

    try {
      await QuotationService().deleteQuotation(widget.quotationId);

      if (mounted) {
        Navigator.pop(context); // Cerrar el modal de progreso

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cotización eliminada')),
        );

        Navigator.pop(context); // Volver a la pantalla anterior
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const QuotationListScreen()),
        ); // Navegar a la pantalla de lista de productos y actualizarla
      }
    } catch (error) {
      if (mounted) {
        Navigator.pop(context); // Cerrar el modal de progreso

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar cotización')),
        );

        Navigator.pop(context); //Volver a la pantalla anterior
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const QuotationListScreen()),
        ); // Navegar a la pantalla de lista de productos y actualizarla
      }
    }
  }

  void updateQuotation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Archivar cotización ${productDetail.data.attributes.codeQuotation}'),
          content: const Text('¿Estás seguro de archivar esta cotización?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Respuesta negativa: No
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Respuesta positiva: Sí
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed != null && confirmed) {
        performanceUpdateAction();
      }
    });
  }

  void performanceUpdateAction() async {
    _handleButtonPress(context);

    try {
      await QuotationService().archiveQuotation(widget.quotationId);

      if (mounted) {
        Navigator.pop(context); // Cerrar el modal de progreso

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cotización archivada')),
        );

        Navigator.pop(context); // Volver a la pantalla anterior
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const QuotationListScreen()),
        ); // Navegar a la pantalla de lista de productos y actualizarla
      }
    } catch (error) {
      if (mounted) {
        Navigator.pop(context); // Cerrar el modal de progreso

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al archivar cotización')),
        );

        Navigator.pop(context); // Volver a la pantalla anterior
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const QuotationListScreen()),
        ); // Navegar a la pantalla de lista de productos y actualizarla
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cotización'),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                onTap: deleteQuotation,
                child: const Row(
                  children: [
                    Icon(Icons.delete), // Ícono a la izquierda
                    SizedBox(width: 8), // Espacio entre el ícono y el texto
                    Text('Eliminar'), // Texto
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: updateQuotation,
                child: const Row(
                  children: [
                    Icon(Icons.archive), // Ícono a la izquierda
                    SizedBox(width: 8), // Espacio entre el ícono y el texto
                    Text('Archivar'), // Texto
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(children: [
                  productDetail.data.attributes.pdfVoucher.data!.isNotEmpty
                      ? const Icon(Icons.picture_as_pdf)
                      : const Icon(Icons.hourglass_empty_outlined),
                  const SizedBox(width: 8),
                  const Text('Descargar'),
                ]),
                onTap: () {
                  _openPdf(
                    productDetail
                        .data.attributes.pdfVoucher.data![0].attributes.url,
                  );
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
                  SendPdfToWhatsAppButton(
                    customerName: productDetail.data.attributes.name,
                    code: productDetail.data.attributes.codeQuotation,
                    pdfFilePath: productDetail
                        .data.attributes.pdfVoucher.data![0].attributes.url,
                    phoneNumber: productDetail.data.attributes.phone,
                  );
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
                  SendEmailButton(
                    customerName: productDetail.data.attributes.name,
                    code: productDetail.data.attributes.codeQuotation,
                    pdfFilePath: productDetail
                        .data.attributes.pdfVoucher.data![0].attributes.url,
                    recipientEmail: productDetail.data.attributes.email,
                  );
                },
              ),
            ],
            icon: const Icon(Icons.more_vert), // Icono de menú
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Mostrar el spinner
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Número: ${productDetail.data.attributes.codeQuotation}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Cliente: ${productDetail.data.attributes.name}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Email: ${productDetail.data.attributes.email}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Cel: ${productDetail.data.attributes.phone}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Mensaje: ${productDetail.data.attributes.message}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Productos: (${productDetail.data.attributes.products.length})',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
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
                            updateProductPrice(
                                productIndex, sizeIndex, newPrice);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
