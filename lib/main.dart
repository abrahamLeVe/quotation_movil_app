import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/providers/payment_state.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/routes/app_routes.dart';
import 'package:pract_01/screens/home_screen.dart';
import 'package:pract_01/screens/login_screen.dart';
import 'package:pract_01/services/messaging/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: Environment.fileName);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('auth_token');
  runApp(MyApp(
      initialRoute: authToken != null ? AppRoutes.home : AppRoutes.login));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<QuotationState>(
          create: (_) => QuotationState(),
        ),
        ChangeNotifierProvider<PaymentState>(
          create: (_) => PaymentState(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cotizaciones Eléctrica S.A.C',
        initialRoute: initialRoute,
        routes: {
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.home: (context) => const HomeScreen(selectedTabIndex: 1),
        },
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
