// import 'package:flutter/material.dart';
// import 'package:pract_01/models/quotation/get_all_quotation_model.dart'
//     as model_quotation;
// import 'package:pract_01/models/quotation/update_quotation_model.dart';
// import 'package:pract_01/providers/quotation_state.dart';
// import 'package:pract_01/screens/home_screen.dart';
// import 'package:pract_01/screens/quotation/quotation_actions.dart';
// import 'package:pract_01/services/quotation_service.dart';
// import 'package:pract_01/utils/dialog_utils.dart';
// import 'package:pract_01/widgets/quotation/quotation_edit_item.dart';
// import 'package:pract_01/widgets/send_pdf_to_mail.dart';
// import 'package:pract_01/widgets/send_pdf_to_whatsapp.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:provider/provider.dart';

// class EditQuotationScreen extends StatefulWidget {
//   final model_quotation.Quotation quotation;
//   final Function(model_quotation.Quotation) onQuotationUpdated;

//   const EditQuotationScreen({
//     Key? key,
//     required this.quotation,
//     required this.onQuotationUpdated,
//   }) : super(key: key);

//   @override
//   State<EditQuotationScreen> createState() => _EditQuotationScreenState();
// }

// class _EditQuotationScreenState extends State<EditQuotationScreen> {
//   List<model_quotation.Product> products = [];
//   late UpdateQuotationModel response;
//   late bool _changesSaved = false;
//   bool _pdfAvailable = false;
//   final bool _isLoading = false;
//   late QuotationState quotationState;

//   @override
//   void initState() {
//     super.initState();
//     products =
//         widget.quotation.attributes.products.cast<model_quotation.Product>();
//     quotationState = Provider.of<QuotationState>(context, listen: false);
//     if (widget.quotation.attributes.pdfVoucher.data == null ||
//         widget.quotation.attributes.pdfVoucher.data!.isEmpty) {
//       _pdfAvailable = false;
//     } else {
//       _pdfAvailable = true;
//     }
//   }

//   void updateProductPrice(
//     int productIndex,
//     int sizeIndex,
//     double newPrice,
//     List<model_quotation.Product> updatedProducts,
//   ) {
//     setState(() {
//       final copiedProducts =
//           List<model_quotation.Product>.from(updatedProducts);

//       final product = copiedProducts[productIndex];
//       if (product.size.isNotEmpty) {
//         final copiedSizes = List<model_quotation.Size>.from(product.size);
//         final size = copiedSizes[sizeIndex];
//         final updatedSize = model_quotation.Size(
//           id: size.id,
//           val: size.val,
//           quantity: size.quantity,
//           quotationPrice: newPrice,
//         );
//         copiedSizes[sizeIndex] = updatedSize;
//         final updatedProduct = model_quotation.Product(
//           id: product.id,
//           name: product.name,
//           size: copiedSizes.toList(),
//           quantity: product.quantity,
//           quotationPrice: product.quotationPrice,
//         );
//         copiedProducts[productIndex] = updatedProduct;
//       } else {
//         final updatedProduct = model_quotation.Product(
//           id: product.id,
//           name: product.name,
//           size: product.size,
//           quantity: product.quantity,
//           quotationPrice: newPrice,
//         );
//         copiedProducts[productIndex] = updatedProduct;
//       }

//       products = copiedProducts;
//     });
//   }

//   void _handleButtonPress(BuildContext context) {
//     showLoadingDialog(context);
//   }

//   Future<void> _openPdf(String url) async {
//     final Uri url0 = Uri.parse(url);
//     if (!await launchUrl(
//       url0,
//       mode: LaunchMode.externalApplication,
//     )) {
//       throw Exception('Could not launch $url0');
//     }
//   }

//   void saveChanges() async {
//     final quotationState = Provider.of<QuotationState>(context, listen: false);
//     final updatedData = {
//       'data': {
//         'id': widget.quotation.id,
//         'name': widget.quotation.attributes.name,
//         'phone': widget.quotation.attributes.phone,
//         'message': widget.quotation.attributes.message,
//         'email': widget.quotation.attributes.email,
//         'products': products.map((product) {
//           return {
//             'id': product.id,
//             'name': product.name,
//             'size': product.size.map((size) {
//               return {
//                 'id': size.id,
//                 'val': size.val,
//                 'quantity': size.quantity,
//                 'quotation_price': size.quotationPrice,
//               };
//             }).toList(),
//             'quantity': product.quantity,
//             'quotation_price': product.quotationPrice,
//           };
//         }).toList(),
//         "code_quotation": widget.quotation.attributes.codeQuotation
//       },
//     };

//     try {
//       if (mounted) {
//         _handleButtonPress(context);
//       }
//       _changesSaved = true;

//       response = await QuotationService()
//           .updateQuotation(widget.quotation.id, updatedData);

//       await Future.delayed(const Duration(seconds: 2));

//       if (mounted) {
//         widget.onQuotationUpdated(widget.quotation);
//         quotationState.updateQuotationProvider(widget.quotation);
//         Navigator.pop(context);

//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Cotización actualizada'),
//               content: const Text('La cotización se actualizó exitosamente.'),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context, true);
//                   },
//                   child: const Text('Aceptar'),
//                 ),
//               ],
//             );
//           },
//         ).then((confirm) {
//           if (confirm == true) {
//             final index = quotationState.quotations
//                 .indexWhere((q) => q.id == widget.quotation.id);

//             if (index != -1) {
//               model_quotation.Quotation updatedQuotation =
//                   quotationState.quotations[index];

//               String pdfUrl = updatedQuotation
//                   .attributes.pdfVoucher.data![0].attributes.url;

//               _openPdf(pdfUrl);

//               SendPdfToWhatsAppButton(
//                 customerName: updatedQuotation.attributes.name,
//                 code: updatedQuotation.attributes.codeQuotation,
//                 pdfFilePath: pdfUrl,
//                 phoneNumber: updatedQuotation.attributes.phone,
//               );

//               SendEmailButton(
//                 customerName: updatedQuotation.attributes.name,
//                 code: updatedQuotation.attributes.codeQuotation,
//                 pdfFilePath: pdfUrl,
//                 recipientEmail: updatedQuotation.attributes.email,
//               );
//             }
//           }
//         });
//       }
//       _pdfAvailable = true;
//     } catch (error) {
//       _changesSaved = false;

//       if (mounted) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Error al actualizar la cotización')),
//         );
//         Navigator.pop(context);
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const HomeScreen(selectedTabIndex: 1),
//           ),
//           (route) => false,
//         );
//       }
//     }
//   }

//   bool _changesNotSaved() {
//     if (_changesSaved) {
//       return true; // Los cambios fueron guardados, no hay cambios sin guardar
//     }
//     return products.any((product) {
//       final originalProduct = widget.quotation.attributes.products
//           .firstWhere((p) => p.id == product.id);

//       ('Product ID: ${product.id}');
//       ('Product Original Quotation Price: ${originalProduct.quotationPrice}');
//       ('Product Current Quotation Price: ${product.quotationPrice}');

//       if (product.size.isNotEmpty) {
//         return product.size.any((size) {
//           final originalSize =
//               originalProduct.size.firstWhere((s) => s.id == size.id);

//           ('Size ID: ${size.id}');
//           ('Size Original Quotation Price: ${originalSize.quotationPrice}');
//           ('Size Current Quotation Price: ${size.quotationPrice}');

//           return size.quotationPrice != originalSize.quotationPrice;
//         });
//       } else {
//         return product.quotationPrice != originalProduct.quotationPrice;
//       }
//     });
//   }

//   Future<bool> _confirmDiscardChanges(BuildContext context) async {
//     if (_changesNotSaved()) {
//       if (!_changesSaved) {
//         final confirmed = await showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Descartar cambios'),
//               content: const Text(
//                   '¿Estás seguro de que quieres descartar los cambios sin guardar?'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context, true),
//                   child: const Text('Descartar'),
//                 ),
//                 TextButton(
//                   onPressed: () => Navigator.pop(context, false),
//                   child: const Text('Cancelar'),
//                 ),
//               ],
//             );
//           },
//         );

//         return confirmed ?? false;
//       }
//     }

//     return true;
//   }

//   deleteQuotation() {
//     deleteQuotation1(context, widget.quotation.id);
//   }

//   archiveQuotation() {
//     archiveQuotation1(context, widget.quotation.id,
//         widget.quotation.attributes.codeQuotation);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => _confirmDiscardChanges(context),
//       child: Scaffold(
//         appBar: buildAppBar(),
//         body: _isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Número: ${widget.quotation.attributes.codeQuotation}',
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         'Cliente: ${widget.quotation.attributes.name}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         'Email: ${widget.quotation.attributes.email}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         'Cel: ${widget.quotation.attributes.phone}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       Text(
//                         'Mensaje: ${widget.quotation.attributes.message}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Productos: (${widget.quotation.attributes.products.length})',
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         physics: const ClampingScrollPhysics(),
//                         itemCount: products.length,
//                         itemBuilder: (BuildContext context, int productIndex) {
//                           final product = products[productIndex];
//                           return QuotationEditItem(
//                             product: product,
//                             productIndex: productIndex,
//                             products: products,
//                             onPriceUpdate: (productIndex, sizeIndex, newPrice,
//                                 updatedProducts) {
//                               updateProductPrice(productIndex, sizeIndex,
//                                   newPrice, updatedProducts);
//                               quotationState
//                                   .updateQuotationProvider(widget.quotation);
//                             },
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }

//   AppBar buildAppBar() {
//     return AppBar(
//       title: const Text('Editar Cotización'),
//       actions: [
//         PopupMenuButton(
//           itemBuilder: (BuildContext context) => [
//             PopupMenuItem(
//               onTap: deleteQuotation,
//               child: const Row(
//                 children: [
//                   Icon(Icons.delete),
//                   SizedBox(width: 8),
//                   Text('Eliminar'),
//                 ],
//               ),
//             ),
//             if (_pdfAvailable)
//               PopupMenuItem(
//                 onTap: archiveQuotation,
//                 child: const Row(
//                   children: [
//                     Icon(Icons.archive),
//                     SizedBox(width: 8),
//                     Text('Archivar'),
//                   ],
//                 ),
//               ),
//             if (!_pdfAvailable)
//               PopupMenuItem(
//                 child: const Row(children: [
//                   Icon(Icons.save),
//                   SizedBox(width: 8),
//                   Text('Generar pdf'),
//                 ]),
//                 onTap: () {
//                   _isLoading ? null : saveChanges();
//                 },
//               ),
//             if (_changesNotSaved() || _changesSaved)
//               PopupMenuItem(
//                 child: const Row(children: [
//                   Icon(Icons.save),
//                   SizedBox(width: 8),
//                   Text('Guardar cambios'),
//                 ]),
//                 onTap: () {
//                   _isLoading ? null : saveChanges();
//                 },
//               ),
//             if (_pdfAvailable)
//               PopupMenuItem(
//                 child: const Row(children: [
//                   Icon(Icons.picture_as_pdf),
//                   SizedBox(width: 8),
//                   Text('Descargar'),
//                 ]),
//                 onTap: () {
//                   QuotationState quotationState =
//                       Provider.of<QuotationState>(context, listen: false);
//                   final index = quotationState.quotations
//                       .indexWhere((q) => q.id == widget.quotation.id);

//                   if (index != -1) {
//                     String pdfUrl = quotationState.quotations[index].attributes
//                         .pdfVoucher.data![0].attributes.url;
//                     _openPdf(pdfUrl);
//                   }
//                 },
//               ),
//             if (_pdfAvailable)
//               PopupMenuItem(
//                 child: const Row(
//                   children: [
//                     Icon(Icons.send),
//                     SizedBox(width: 8),
//                     Text('Enviar PDF por WhatsApp'),
//                   ],
//                 ),
//                 onTap: () {
//                   QuotationState quotationState =
//                       Provider.of<QuotationState>(context, listen: false);
//                   final index = quotationState.quotations
//                       .indexWhere((q) => q.id == widget.quotation.id);

//                   if (index != -1) {
//                     String pdfUrl = quotationState.quotations[index].attributes
//                         .pdfVoucher.data![0].attributes.url;

//                     SendPdfToWhatsAppButton(
//                       customerName: widget.quotation.attributes.name,
//                       code: widget.quotation.attributes.codeQuotation,
//                       pdfFilePath: pdfUrl,
//                       phoneNumber: widget.quotation.attributes.phone,
//                     );
//                   }
//                 },
//               ),
//             if (_pdfAvailable)
//               PopupMenuItem(
//                 child: const Row(
//                   children: [
//                     Icon(Icons.email),
//                     SizedBox(width: 8),
//                     Text('Enviar PDF por email'),
//                   ],
//                 ),
//                 onTap: () {
//                   QuotationState quotationState =
//                       Provider.of<QuotationState>(context, listen: false);
//                   final index = quotationState.quotations
//                       .indexWhere((q) => q.id == widget.quotation.id);

//                   if (index != -1) {
//                     String pdfUrl = quotationState.quotations[index].attributes
//                         .pdfVoucher.data![0].attributes.url;

//                     SendEmailButton(
//                       customerName: widget.quotation.attributes.name,
//                       code: widget.quotation.attributes.codeQuotation,
//                       pdfFilePath: pdfUrl,
//                       recipientEmail: widget.quotation.attributes.email,
//                     );
//                   }
//                 },
//               ),
//           ],
//           icon: const Icon(Icons.more_vert),
//         ),
//       ],
//     );
//   }

//   Column quotationDetailsColumn(List<model_quotation.Quotation> quotations) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Número: ${widget.quotation.attributes.codeQuotation}',
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           'Cliente: ${widget.quotation.attributes.name}',
//           style: const TextStyle(fontSize: 16),
//         ),
//         Text(
//           'Email: ${widget.quotation.attributes.email}',
//           style: const TextStyle(fontSize: 16),
//         ),
//         Text(
//           'Cel: ${widget.quotation.attributes.phone}',
//           style: const TextStyle(fontSize: 16),
//         ),
//         Text(
//           'Mensaje: ${widget.quotation.attributes.message}',
//           style: const TextStyle(fontSize: 16),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           'Productos: (${widget.quotation.attributes.products.length})',
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Expanded(
//           child: ListView.builder(
//             shrinkWrap: true,
//             physics: const ClampingScrollPhysics(),
//             itemCount: products.length,
//             itemBuilder: (BuildContext context, int productIndex) {
//               final product = products[productIndex];
//               return QuotationEditItem(
//                 product: product,
//                 productIndex: productIndex,
//                 products: products,
//                 onPriceUpdate:
//                     (productIndex, sizeIndex, newPrice, updatedProducts) {
//                   updateProductPrice(
//                       productIndex, sizeIndex, newPrice, updatedProducts);
//                   quotationState.updateQuotationProvider(widget.quotation);
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
