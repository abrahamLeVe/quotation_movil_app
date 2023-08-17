import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart'
    as model_quotation;
import 'package:pract_01/models/quotation/post_quotation_model.dart'
    as post_quotation_model;
import 'package:pract_01/screens/product/pdf_view_screen.dart';
import 'package:pract_01/screens/quotation/quotation_actions.dart';
import 'package:pract_01/services/quotation_service.dart';
import 'package:pract_01/utils/error_handlers.dart';
import 'package:pract_01/widgets/send_pdf_to_mail.dart';
import 'package:pract_01/widgets/send_pdf_to_whatsapp.dart';

class EditQuotationScreen extends StatefulWidget {
  final model_quotation.Quotation quotation;
  final void Function(model_quotation.Quotation) onQuotationUpdated;

  const EditQuotationScreen(
      {super.key, required this.quotation, required this.onQuotationUpdated});

  @override
  State<EditQuotationScreen> createState() => _EditQuotationScreenState();
}

class _EditQuotationScreenState extends State<EditQuotationScreen> {
  late model_quotation.Quotation _originalQuotation;
  List<List<double>> originalPrices = [];
  bool _isClientInfoExpanded = false;

  List<List<TextEditingController>> priceControllers = [];
  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _originalQuotation = model_quotation.Quotation.fromJson(
      widget.quotation.toJson(),
    );
    originalPrices = widget.quotation.attributes.products.map((product) {
      if (product.size.isNotEmpty) {
        return List.generate(
          product.size.length,
          (sizeIndex) {
            return product.size[sizeIndex].quotationPrice;
          },
        );
      } else {
        return [product.quotationPrice];
      }
    }).toList();

    priceControllers = widget.quotation.attributes.products.map((product) {
      if (product.size.isNotEmpty) {
        return List.generate(
          product.size.length,
          (sizeIndex) {
            final controller = TextEditingController(
              text: product.size[sizeIndex].quotationPrice.toString(),
            );
            controller.addListener(() {
              try {
                if (double.parse(controller.text) !=
                    product.size[sizeIndex].quotationPrice) {
                  _handlePriceChange();
                }
              } catch (e) {
                //---
              }
            });

            return controller;
          },
        );
      } else {
        final controller = TextEditingController(
          text: product.quotationPrice.toString(),
        );
        controller.addListener(() {
          try {
            final newPrice = double.parse(controller.text);
            if (newPrice != product.quotationPrice) {
              _handlePriceChange();
            }
          } catch (e) {
            // --
          }
        });
        return [controller];
      }
    }).toList();
  }

  void _handlePriceChange() {
    bool hasChanges = false;
    final updatedQuotation = model_quotation.Quotation.fromJson(
      widget.quotation.toJson(),
    );

    for (int productIndex = 0;
        productIndex < updatedQuotation.attributes.products.length;
        productIndex++) {
      final updatedProduct = updatedQuotation.attributes.products[productIndex];
      final originalProduct =
          _originalQuotation.attributes.products[productIndex];

      if (updatedProduct.size.isNotEmpty) {
        for (int sizeIndex = 0;
            sizeIndex < updatedProduct.size.length;
            sizeIndex++) {
          final updatedSize = updatedProduct.size[sizeIndex];
          final originalSize = originalProduct.size[sizeIndex];
          if (updatedSize.quotationPrice != originalSize.quotationPrice) {
            hasChanges = true;
            break;
          }
        }
      } else {
        if (updatedProduct.quotationPrice != originalProduct.quotationPrice) {
          hasChanges = true;
          break;
        }
      }
    }

    setState(() {
      _hasChanges = hasChanges;
    });
  }

  void _updateSizePrice(int productIndex, int? sizeIndex, String newValue) {
    setState(() {
      final product = widget.quotation.attributes.products[productIndex];
      try {
        final newPrice = double.parse(newValue);
        if (sizeIndex != null) {
          final size = product.size[sizeIndex];
          size.quotationPrice = newPrice;
        } else {
          product.quotationPrice = newPrice;
        }
        _checkForChanges();
      } catch (e) {
        print("Error al convertir el valor a double: $e");
      }
    });
  }

  void _checkForChanges() {
    bool hasChanges = false;
    for (int productIndex = 0;
        productIndex < widget.quotation.attributes.products.length;
        productIndex++) {
      final updatedProduct = widget.quotation.attributes.products[productIndex];
      final originalProduct =
          _originalQuotation.attributes.products[productIndex];

      if (updatedProduct.size.isNotEmpty) {
        for (int sizeIndex = 0;
            sizeIndex < updatedProduct.size.length;
            sizeIndex++) {
          final updatedSize = updatedProduct.size[sizeIndex];
          final originalSize = originalProduct.size[sizeIndex];
          if (updatedSize.quotationPrice != originalSize.quotationPrice) {
            hasChanges = true;
            break;
          }
        }
      } else {
        if (updatedProduct.quotationPrice != originalProduct.quotationPrice) {
          hasChanges = true;
          break;
        }
      }
    }

    setState(() {
      _hasChanges = hasChanges;
    });
  }

  Widget _buildClientInfoAccordion() {
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isClientInfoExpanded = !_isClientInfoExpanded;
        });
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              title: Text('Información del Cliente'),
            );
          },
          body: ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre: ${widget.quotation.attributes.name}'),
                Text('Teléfono: ${widget.quotation.attributes.phone}'),
                Text('Email: ${widget.quotation.attributes.email}'),
                Text('Mensaje: ${widget.quotation.attributes.message}'),
              ],
            ),
          ),
          isExpanded: _isClientInfoExpanded,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasChanges) {
          final shouldDiscard = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('¿Descartar cambios?'),
                content: const Text(
                    'Hay cambios no guardados. ¿Deseas descartarlos?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        for (int i = 0; i < priceControllers.length; i++) {
                          for (int j = 0; j < priceControllers[i].length; j++) {
                            final product =
                                widget.quotation.attributes.products[i];
                            if (product.size.isNotEmpty) {
                              product.size[j].quotationPrice =
                                  originalPrices[i][j];
                            } else {
                              product.quotationPrice = originalPrices[i][0];
                            }
                            priceControllers[i][j].text =
                                originalPrices[i][j].toString();
                          }
                        }
                        _hasChanges = false;
                      });
                      Navigator.pop(context, true);
                    },
                    child: const Text('Descartar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancelar'),
                  ),
                ],
              );
            },
          );

          return shouldDiscard;
        } else {
          return true;
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('Editar Cotización N° ${widget.quotation.id}'),
              actions: [_popupMenuItem(widget.quotation)],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _buildQuotationForm(widget.quotation),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _isSaving ? null : _saveQuotationChanges,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.save),
            ),
          ),
          if (_isSaving)
            const ModalBarrier(
              color: Colors.black54,
              dismissible: false,
            ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(int productIndex, int? sizeIndex,
      model_quotation.Product product, BuildContext context) {
    final TextEditingController controller = sizeIndex != null
        ? priceControllers[productIndex][sizeIndex]
        : priceControllers[productIndex][0];

    return Row(
      children: [
        Expanded(
          child: Text(
            sizeIndex != null ? product.size[sizeIndex].val : 'Precio general',
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              LengthLimitingTextInputFormatter(12),
            ],
            onChanged: (newValue) {
              _updateSizePrice(productIndex, sizeIndex, newValue);
            },
          ),
        ),
      ],
    );
  }

  void _saveQuotationChanges() async {
    try {
      setState(() {
        _isSaving = true;
      });
      List<post_quotation_model.Product> updatedProducts = [];

      for (int productIndex = 0;
          productIndex < widget.quotation.attributes.products.length;
          productIndex++) {
        final originalProduct =
            widget.quotation.attributes.products[productIndex];
        List<post_quotation_model.Size> updatedSizes = [];

        if (originalProduct.size.isNotEmpty) {
          for (int sizeIndex = 0;
              sizeIndex < originalProduct.size.length;
              sizeIndex++) {
            final size = originalProduct.size[sizeIndex];
            final controller = priceControllers[productIndex][sizeIndex];
            double newPrice = double.tryParse(controller.text) ?? 0.0;
            updatedSizes.add(post_quotation_model.Size(
              id: size.id,
              val: size.val,
              quantity: size.quantity,
              quotationPrice: newPrice,
            ));
          }
        }

        final generalPriceController = priceControllers[productIndex][0];
        double generalPrice =
            double.tryParse(generalPriceController.text) ?? 0.0;

        updatedProducts.add(post_quotation_model.Product(
          id: originalProduct.id,
          name: originalProduct.name,
          size: updatedSizes,
          quantity: originalProduct.quantity,
          quotationPrice: generalPrice,
        ));
      }

      post_quotation_model.Data updatedQuotation = post_quotation_model.Data(
        id: widget.quotation.id,
        name: widget.quotation.attributes.name,
        phone: widget.quotation.attributes.phone,
        message: widget.quotation.attributes.message,
        email: widget.quotation.attributes.email,
        products: updatedProducts,
      );

      Map<String, dynamic> updateData = {
        'data': updatedQuotation.toJson(),
      };

      final response = await QuotationService(context: context)
          .updateQuotation(widget.quotation.id, updateData);

      final pdfUrl = response.data.pdfVoucher[0].url;

// Actualizar el estado para reflejar los cambios
      setState(() {
        widget.quotation.attributes.pdfVoucher = model_quotation.PdfVoucher(
          data: [
            model_quotation.PdfVoucherDatum(
              id: response.data.id,
              attributes: model_quotation.FluffyAttributes(
                url: pdfUrl,
                name: response.data.pdfVoucher[0].name,
                hash: response.data.pdfVoucher[0].hash,
                ext: response.data.pdfVoucher[0].ext,
                mime: response.data.pdfVoucher[0].mime,
                size: response.data.pdfVoucher[0].size,
                provider: response.data.pdfVoucher[0].provider,
                providerMetadata: model_quotation.ProviderMetadata(
                  publicId:
                      response.data.pdfVoucher[0].providerMetadata.publicId,
                  resourceType:
                      response.data.pdfVoucher[0].providerMetadata.resourceType,
                ),
                createdAt: response.data.pdfVoucher[0].createdAt,
                updatedAt: response.data.pdfVoucher[0].updatedAt,
              ),
            ),
          ],
        );
      });

      if (context.mounted) {
        updateQuotationsInBackground(context);

        setState(() {
          _isSaving = false;
          _hasChanges = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cotización actualizada con éxito')),
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PdfViewScreen(pdfUrl: pdfUrl),
          ),
        );
      }
     
    } catch (error) {
      if (context.mounted) {
        showAuthenticationErrorDialog(context, error);

        setState(() {
          _isSaving = false;
          _hasChanges = false;
        });
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error no se pudo actualizar')),
        );
      }
    }
  }

  Widget _buildQuotationForm(model_quotation.Quotation quotation) {
    return Column(
      children: [
        _buildClientInfoAccordion(),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: quotation.attributes.products.length,
          itemBuilder: (context, productIndex) {
            final product = quotation.attributes.products[productIndex];
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(product.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.size.isNotEmpty)
                          for (int sizeIndex = 0;
                              sizeIndex < product.size.length;
                              sizeIndex++)
                            _buildPriceRow(
                              productIndex,
                              sizeIndex,
                              product,
                              context,
                            ),
                        if (product.size.isEmpty)
                          _buildPriceRow(
                            productIndex,
                            null,
                            product,
                            context,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _popupMenuItem(model_quotation.Quotation quotation) {
    final pdfVoucher = quotation.attributes.pdfVoucher?.data;
    return Column(
      children: [
        if (pdfVoucher!.isNotEmpty)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert), // Ícono del menú
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'download',
                child: Text('Descargar PDF'),
              ),
              const PopupMenuItem<String>(
                value: 'whatsapp',
                child: Text('Enviar por WhatsApp'),
              ),
              const PopupMenuItem<String>(
                value: 'email',
                child: Text('Enviar por Email'),
              ),
              const PopupMenuItem<String>(
                value: 'eliminar',
                child: Text('Eliminar'),
              ),
              const PopupMenuItem<String>(
                value: 'archivar',
                child: Text('Archivar'),
              ),
            ],
            onSelected: (String value) {
              final pdfUrl = pdfVoucher[0].attributes.url;
              if (value == 'download') {
                // _openPdf(pdfUrl);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewScreen(pdfUrl: pdfUrl),
                  ),
                );
              } else if (value == 'whatsapp') {
                SendPdfToWhatsAppButton(
                  customerName: widget.quotation.attributes.name,
                  code: widget.quotation.id,
                  pdfFilePath: pdfUrl,
                  phoneNumber: widget.quotation.attributes.phone,
                );
              } else if (value == 'email') {
                SendEmailButton(
                  customerName: widget.quotation.attributes.name,
                  code: widget.quotation.id,
                  pdfFilePath: pdfUrl,
                  recipientEmail: widget.quotation.attributes.email,
                );
              } else if (value == 'eliminar') {
                deleteQuotation(context, widget.quotation.id);
              } else if (value == 'archivar') {
                archiveQuotation(context, widget.quotation.id);
              }
            },
          ),
        if (pdfVoucher.isEmpty)
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {
                deleteQuotation(context, widget.quotation.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red, // Color de fondo rojo para indicar eliminar
              ),
              child: const Text(
                "Eliminar",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
