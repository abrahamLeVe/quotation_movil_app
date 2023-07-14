import 'package:flutter/material.dart';
import 'package:pract_01/screens/home_screen.dart';
import 'package:pract_01/services/quotation_service.dart';
import 'package:pract_01/utils/dialog_utils.dart';

void _handleButtonPress(BuildContext context) {
  showLoadingDialog(context);
}

void deleteQuotation1(BuildContext context, int quotationId) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Eliminar cotización permanentemente'),
        content: const Text(
            '¿Estás seguro de eliminar esta Cotización de forma permanente?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Sí'),
          ),
        ],
      );
    },
  ).then((confirmed) {
    if (confirmed != null && confirmed) {
      performDeleteAction(context, quotationId);
    }
  });
}

void performDeleteAction(BuildContext context, int quotationId) async {
  _handleButtonPress(context);

  try {
    await QuotationService().deleteQuotation(quotationId);

    if (context.mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cotización eliminada')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(selectedTabIndex: 1),
        ),
        (route) => false,
      );
    }
  } catch (error) {
    if (context.mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar cotización')),
      );

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

void archiveQuotation1(
    BuildContext context, int quotationId, String codeQuotation) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Archivar cotización $codeQuotation'),
        content: const Text('¿Estás seguro de archivar esta cotización?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Sí'),
          ),
        ],
      );
    },
  ).then((confirmed) {
    if (confirmed != null && confirmed) {
      performanceUpdateAction(
        context,
        quotationId,
      );
    }
  });
}

void performanceUpdateAction(BuildContext context, int quotationId) async {
  _handleButtonPress(context);

  try {
    await QuotationService().archiveQuotation(quotationId);

    if (context.mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cotización archivada')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => const HomeScreen(selectedTabIndex: 1)),
        (route) => false,
      );
    }
  } catch (error) {
    if (context.mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al archivar cotización')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => const HomeScreen(selectedTabIndex: 1)),
        (route) => false,
      );
    }
  }
}
