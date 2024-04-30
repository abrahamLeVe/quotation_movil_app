import 'package:flutter/material.dart';
import 'package:pract_01/models/contact/get_all_contact.dart';
import 'package:pract_01/models/payment/get_all_payment.dart'
    as payment_all_model;
import 'package:pract_01/models/quotation/get_all_quotation_model.dart'
    as quotation_all_model;
import 'package:pract_01/providers/client_state.dart';
import 'package:pract_01/providers/contact_state.dart';
import 'package:pract_01/providers/payment_state.dart';
import 'package:pract_01/providers/price_state.dart';
import 'package:pract_01/providers/product_state.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/screens/contact/list_contact_screen.dart';
import 'package:pract_01/screens/payment/list_payment_screen.dart';
import 'package:pract_01/screens/quotation/list_quotation_screen.dart';
import 'package:pract_01/services/authentication_service.dart';
import 'package:pract_01/services/messaging/messaging_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final int selectedTabIndex;

  const HomeScreen({Key? key, required this.selectedTabIndex})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<List<quotation_all_model.Quotation>>? _quotationsFuture;
  Future<List<payment_all_model.Payment>>? _paymentsFuture;
  Future<List<Contact>>? _contactsFuture;
  late QuotationState _quotationState;
  late PaymentState _paymentState;
  late ContactState _contactState;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  void _loadData() async {
    final messagingService = MessagingService();
    messagingService.init(context);
    Provider.of<QuotationState>(context, listen: false)
        .loadNewQuotations(context);
    Provider.of<QuotationState>(context, listen: false)
        .loadFullQuotations(context);
    Provider.of<PaymentState>(context, listen: false).loadNewPayments(context);
    Provider.of<ContactState>(context, listen: false).loadNewContacts(context);
    Provider.of<ClientState>(context, listen: false).loadNewClients(context);
    Provider.of<ProductState>(context, listen: false).loadFullProducts(context);
    Provider.of<PriceState>(context, listen: false).loadFullPrices(context);

    messagingService.onQuotationsUpdated.listen((_) {
      _quotationState.loadNewQuotations(context);
    });
    messagingService.onPaymentsUpdated.listen((_) {
      _paymentState.loadNewPayments(context);
    });
    messagingService.onContactsUpdated.listen((_) {
      _contactState.loadNewContacts(context);
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void logout(BuildContext context) {
    final authService = AuthenticationService(context: context);
    authService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  Tab _getQuotationTab(int quotationCount) {
    return Tab(text: 'Cotización ($quotationCount)');
  }

  Tab _getPaymentTab(int productCount) {
    return Tab(text: 'Pagos ($productCount)');
  }

  Tab _getContactTab(int contactCount) {
    return Tab(text: 'Mensajes ($contactCount)');
  }

  @override
  Widget build(BuildContext context) {
    _quotationState = Provider.of<QuotationState>(context, listen: true);
    _paymentState = Provider.of<PaymentState>(context, listen: true);
    _contactState = Provider.of<ContactState>(context, listen: true);

    final tabs = [
      _getQuotationTab(_quotationState.quotationsCount),
      _getPaymentTab(_paymentState.paymentsCount),
      _getContactTab(_contactState.contactsCount),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'logout') {
                logout(context);
              } else if (value == 'charts') {
                Navigator.pushNamed(context, '/charts');
              } else if (value == 'chartsstates') {
                Navigator.pushNamed(context, '/chartsstates');
              } else if (value == 'chartsclients') {
                Navigator.pushNamed(context, '/chartsclients');
              } else if (value == 'prices') {
                Navigator.pushNamed(context, '/prices');
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'prices',
                child: Text('Productos'),
              ),
              const PopupMenuItem(
                value: 'charts',
                child: Text('Top Cotizaciones'),
              ),
              const PopupMenuItem(
                value: 'chartsstates',
                child: Text('Top Ventas'),
              ),
              const PopupMenuItem(
                value: 'chartsclients',
                child: Text('Top Clientes'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Cerrar sesión'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: _isLoading
          ? const LinearProgressIndicator()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildQuotationList(),
                _buildPaymentsList(),
                _buildContactsList()
              ],
            ),
    );
  }

  Widget _buildQuotationList() {
    return FutureBuilder<List<quotation_all_model.Quotation>>(
      future: _quotationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final quotationList = snapshot.data ?? [];
          return QuotationListScreen(
            quotationList: quotationList,
          );
        }
      },
    );
  }

  Widget _buildPaymentsList() {
    return FutureBuilder<List<payment_all_model.Payment>>(
      future: _paymentsFuture,
      builder: (context, snapshot) {
        final paymentList = snapshot.data ?? [];

        return ChangeNotifierProvider.value(
          value: _paymentState,
          child: PaymentListScreen(
            paymentList: paymentList,
          ),
        );
      },
    );
  }

  Widget _buildContactsList() {
    return FutureBuilder<List<Contact>>(
      future: _contactsFuture,
      builder: (context, snapshot) {
        final contactList = snapshot.data ?? [];

        return ChangeNotifierProvider.value(
          value: _contactState,
          child: ContactListScreen(
            contactList: contactList,
          ),
        );
      },
    );
  }
}
