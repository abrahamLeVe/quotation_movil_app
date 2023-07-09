import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/routes/routes.dart';

Future<void> main() async {
  await dotenv.load(fileName: Environment.fileName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cotizaciones Eléctrica S.A.C',
      initialRoute: '/',
      routes: Routes.routes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 2, 0, 19)),
        useMaterial3: true,
      ),
    );
  }
}
