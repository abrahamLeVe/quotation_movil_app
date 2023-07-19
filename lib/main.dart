import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/providers/product_state.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        ChangeNotifierProvider<ProductState>(
          create: (_) => ProductState(),
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
