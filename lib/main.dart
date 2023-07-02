import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/screens/product_list_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: Enviroment.fileName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductListScreen(),
    );
  }
}
