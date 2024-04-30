import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/providers/client_state.dart';
import 'package:pract_01/providers/contact_state.dart';
import 'package:pract_01/providers/dataState_state.dart';
import 'package:pract_01/providers/payment_state.dart';
import 'package:pract_01/providers/price_state.dart';
import 'package:pract_01/providers/product_state.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/routes/app_routes.dart';
import 'package:pract_01/screens/chart/charts_screen.dart';
import 'package:pract_01/screens/chart/clients_chart_screen.dart';
import 'package:pract_01/screens/chart/states_chart_screen.dart';
import 'package:pract_01/screens/home_screen.dart';
import 'package:pract_01/screens/login_screen.dart';
import 'package:pract_01/screens/price/list_price_screen.dart';
import 'package:pract_01/screens/product/list_product_screen.dart';
import 'package:pract_01/services/client_service.dart';
import 'package:pract_01/services/contact_service.dart';
import 'package:pract_01/services/messaging/firebase_options.dart';
import 'package:pract_01/services/payment_service.dart';
import 'package:pract_01/services/price_service.ts.dart';
import 'package:pract_01/services/product_service.dart';
import 'package:pract_01/services/quotation_service.dart';
import 'package:pract_01/services/state_quotation_service.dart';
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
        ChangeNotifierProvider<DataStateState>(
          create: (_) => DataStateState(),
        ),
        Provider<StateService>(
          create: (_) => StateService(context: context),
        ),
        ChangeNotifierProvider<QuotationState>(
          create: (_) => QuotationState(),
        ),
        Provider<QuotationService>(
          create: (_) => QuotationService(context: context),
        ),
        ChangeNotifierProvider<PaymentState>(
          create: (_) => PaymentState(),
        ),
        Provider<PaymentService>(
          create: (_) => PaymentService(context: context),
          lazy: false,
          //puesto ultimo
        ),
        ChangeNotifierProvider<ContactState>(
          create: (_) => ContactState(),
        ),
        Provider<ContactService>(
          create: (_) => ContactService(context: context),
          lazy: false,
        ),
        ChangeNotifierProvider<ClientState>(
          create: (_) => ClientState(),
        ),
        Provider<ClientService>(
          create: (_) => ClientService(context: context),
          lazy: false,
        ),
        ChangeNotifierProvider<ProductState>(
          create: (_) => ProductState(),
        ),
        Provider<ProductService>(
          create: (_) => ProductService(context: context),
          lazy: false,
        ),
        ChangeNotifierProvider<PriceState>(
          create: (_) => PriceState(),
        ),
        Provider<PriceService>(
          create: (_) => PriceService(context: context),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Consorcio AyC Eléctrica S.A.C',
        initialRoute: initialRoute,
        routes: {
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.home: (context) => const HomeScreen(selectedTabIndex: 1),
          AppRoutes.charts: (context) => const ChartsScreen(),
          AppRoutes.chartsstares: (context) => const ChartsStatesScreen(),
          AppRoutes.chartsclients: (context) => const ChartClientsScreen(),
          AppRoutes.products: (context) => const ProductListScreen(),
          AppRoutes.prices: (context) => const PriceListScreen(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 11, 2, 88),
          ),
          useMaterial3: true,
        ),
      ),
    );
  }
}
