import 'package:flutter/material.dart';
import 'package:pract_01/components/loading_dialog.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const LoadingDialog();
    },
  );
}
