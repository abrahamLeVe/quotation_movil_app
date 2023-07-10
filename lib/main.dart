import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/screens/home_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: Environment.fileName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<QuotationState>(
          create: (_) => QuotationState(),
        ),
        // Otros proveedores aquí si los tienes
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cotizaciones Eléctrica S.A.C',
        home: const HomeScreen(selectedTabIndex: 2),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 2, 0, 19),
          ),
          useMaterial3: true,
        ),
      ),
    );
  }
}
