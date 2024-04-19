import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart'
    as quotation_all_model;
import 'package:pract_01/providers/payment_state.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/screens/payment/list_payment_screen.dart';
import 'package:pract_01/screens/quotation/edit_quotation_screen.dart';
import 'package:pract_01/screens/quotation/list_quotation_screen.dart';
import 'package:pract_01/services/authentication_service.dart';
import 'package:pract_01/services/messaging/messaging_service.dart';
import 'package:pract_01/services/payment_service.dart';
import 'package:pract_01/services/quotation_service.dart';
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
  final _messagingService = MessagingService();

  late QuotationState _quotationState;
  late PaymentState _paymentState;
  bool _isLoading = true;

  @override
  void initState() {
    _loadData();

    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _quotationState = Provider.of<QuotationState>(context, listen: false);
    _paymentState = Provider.of<PaymentState>(context, listen: false);

    _messagingService.init(context);
    _messagingService.onQuotationsUpdated.listen((_) {
      _loadQuotationsOnNotification();
    });
  }

  void _loadData() async {
    final cachedQuotations =
        await QuotationService(context: context).getCachedQuotations();

    final quotationsResult = cachedQuotations;

    setState(() {
      _quotationsFuture = Future.value(quotationsResult);
      _isLoading = false;
    });

    _loadPayments();
  }

  Tab _getQuotationTab(int quotationCount) {
    return Tab(text: 'Cotizaciones ($quotationCount)');
  }

  Tab _getPaymentTab(int productCount) {
    return Tab(text: 'Pagos ($productCount)');
  }

  void _loadQuotationsOnNotification() async {
    final result = await QuotationService(context: context).getAllQuotation(1);

    setState(() {
      _quotationsFuture = Future.value(result.data);
    });

    for (final newQuotation in result.data) {
      final exists = _quotationState.quotations.any(
        (existingQuotation) => existingQuotation.id == newQuotation.id,
      );

      if (!exists) {
        _quotationState.addQuotation(newQuotation);
      }
    }
  }

  void _loadPayments() async {
    final result = await PaymentService(context: context).getPaymentAll();
    _paymentState.payments = result.data;
    _paymentState.setPaymentsCount(result.data.length);
  }

  void openEditQuotationScreen(quotation_all_model.Quotation quotation) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditQuotationScreen(
          quotation: quotation,
          onQuotationUpdated: (updatedQuotation) {
            _loadQuotationsOnNotification();
            _quotationState.updateQuotationProvider(updatedQuotation);
          },
        ),
      ),
    );

    if (result == true) {
      _loadQuotationsOnNotification();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void logout(BuildContext context) {
    final authService = AuthenticationService(context: context);
    authService.logout();

    // Redirigir al inicio de sesión
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    _quotationState = Provider.of<QuotationState>(context, listen: true);
    _paymentState = Provider.of<PaymentState>(context, listen: true);

    final tabs = [
      _getQuotationTab(_quotationState.quotationsCount),
      _getPaymentTab(_paymentState.paymentsCount),
    ];

    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Pantalla Principal'),
            automaticallyImplyLeading: false,
            actions: [
              PopupMenuButton(
                onSelected: (value) {
                  if (value == 'logout') {
                    logout(context);
                  }
                },
                itemBuilder: (BuildContext context) => [
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
                  ],
                ),
        ));
  }

  Widget _buildQuotationList() {
    return FutureBuilder<List<quotation_all_model.Quotation>>(
      future: _quotationsFuture,
      builder: (context, snapshot) {
        final quotationList = snapshot.data ?? [];

        return ChangeNotifierProvider.value(
          value: _quotationState,
          child: QuotationListScreen(
            quotationList: quotationList,
            openEditQuotationScreen: openEditQuotationScreen,
          ),
        );
      },
    );
  }

  Widget _buildPaymentsList() {
    return ChangeNotifierProvider.value(
      value: _paymentState,
      child: Consumer<PaymentState>(
        builder: (context, paymentState, _) {
          final paymentList = paymentState.payments;
          if (paymentList.isEmpty) {
            return const Center(child: Text('No hay productos disponibles'));
          } else {
            return PaymentListScreen(
              paymentList: paymentList,
              // openEditProductScreen: openEditProductScreen,
            );
          }
        },
      ),
    );
  }
}
