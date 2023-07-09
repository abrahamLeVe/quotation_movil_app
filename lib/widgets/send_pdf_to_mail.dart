import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SendEmailButton extends StatefulWidget {
  final String recipientEmail;
  final String pdfFilePath;
  final String code;
  final String customerName;

  SendEmailButton({
    Key? key,
    required this.recipientEmail,
    required this.pdfFilePath,
    required this.code,
    required this.customerName,
  }) : super(key: key) {
    _sendEmail();
  }

  Future<void> _sendEmail() async {
    final encodedUrl = Uri.encodeFull(pdfFilePath);
    final encodedBody = 'Estimado Cliente: $customerName\n\n'
        'Es grato saludarlo y a la vez confirmarle la recepción de su cotización, por favor enviar el número de RUC y Razón Social de su empresa; en caso de ser a nombre de persona natural favor de indicarnos su número de DNI y la dirección de su domicilio para poder ser registrado en nuestra base.\n\n'
        'Nota:\n'
        '*Es importante que nos envíe sus números telefónicos para poder contactarnos con ustedes, y dirección de su empresa para poder registrarlo en nuestro sistema.\n'
        '** Por indicaciones de SUNAT todo registro de clientes debe contar con su respectiva dirección fiscal para una eventual emisión de comprobante de pago.\n\n'
        'Adjunto datos de la cotización:\n'
        'Código: $code\n'
        'Recibo: $encodedUrl\n\n'
        'Empresa de importación y venta de materiales eléctricos para transformadores CONSORCIO A&C ELÉCTRICA S.A.C.\n'
        'RUC: 2060342527\n'
        'Cel: 948125398\n'
        'Correo: consorcio.electrica.sac@gmail.com\n\n'
        'Atentamente,\n'
        'Call Center Ventas';

    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri uri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Cotización de productos',
        'body': encodedBody,
      }),
    );
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  State<SendEmailButton> createState() => _SendEmailButtonState();
}

class _SendEmailButtonState extends State<SendEmailButton> {
  @override
  Widget build(BuildContext context) {
    return const ElevatedButton(
      onPressed: null,
      child: Text('Enviar Email'),
    );
  }
}
