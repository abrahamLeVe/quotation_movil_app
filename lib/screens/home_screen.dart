import 'package:flutter/material.dart';
import 'package:pract_01/models/product/get_all_product_model.dart'
    as product_all_model;
import 'package:pract_01/models/quotation/get_all_quotation_model.dart'
    as quotation_all_model;
import 'package:pract_01/providers/product_state.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/screens/product/edit_product_screen.dart';
import 'package:pract_01/screens/product/list_product_screen.dart';
import 'package:pract_01/screens/quotation/edit_quotation_screen.dart';
import 'package:pract_01/screens/quotation/list_quotation_screen.dart';
import 'package:pract_01/services/messaging/messaging_service.dart';
import 'package:pract_01/services/product_service.dart';
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
  Future<List<product_all_model.Product>>? _productsFuture;
  Future<List<quotation_all_model.Quotation>>? _quotationsFuture;
  final _messagingService =
      MessagingService(); 

  late QuotationState _quotationState;
  late ProductState _productState;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _quotationState = Provider.of<QuotationState>(context, listen: false);
    _productState = Provider.of<ProductState>(context, listen: false);

    _loadData();

    _messagingService.init(context);

    _messagingService.onQuotationsUpdated.listen((_) {
      _loadQuotationsOnNotification();
    });
  }

  Tab _getQuotationTab(int quotationCount) {
    return Tab(text: 'Cotizaciones ($quotationCount)');
  }

  Tab _getProductTab(int productCount) {
    return Tab(text: 'Productos ($productCount)');
  }

  void _loadData() async {
    final quotationState = Provider.of<QuotationState>(context, listen: false);

    final quotationsFuture = QuotationService().getAllQuotation();
    final productsFuture = ProductService().getAllProduct();

    final quotationsResult = await quotationsFuture;
    final productsResult = await productsFuture;

    setState(() {
      _quotationsFuture = Future.value(quotationsResult.data);
      _productsFuture = Future.value(productsResult.data);
    });

    quotationState.setQuotations(quotationsResult.data);
    _loadProducts();
  }

  void _loadQuotationsOnNotification() async {
    final result = await QuotationService().getAllQuotation();

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

  void _loadProducts() async {
    final result = await ProductService().getAllProduct();
    setState(() {
      _productsFuture = Future.value(result.data);
    });
    _productState.setProducts(result.data);
    _productState.setProductsCount(result.data.length);
  }

  void openEditProductScreen(product_all_model.Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          product: product,
          onProductUpdated: (updatedProduct) {
            _loadProducts();
          },
        ),
      ),
    );

    if (result == true) {
      _loadProducts();
    }
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

  @override
  Widget build(BuildContext context) {
    _quotationState = Provider.of<QuotationState>(context, listen: true);

    final tabs = [
      _getQuotationTab(_quotationState.quotationsCount),
      _getProductTab(_productState.productsCount),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQuotationList(),
          _buildProductList(),
        ],
      ),
    );
  }

  Widget _buildQuotationList() {
    return FutureBuilder<List<quotation_all_model.Quotation>>(
      future: _quotationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar las cotizaciones'));
        } else {
          final quotationList = snapshot.data ?? [];
          return ChangeNotifierProvider.value(
            value: _quotationState,
            child: QuotationListScreen(
              quotationList: quotationList,
              openEditQuotationScreen: openEditQuotationScreen,
            ),
          );
        }
      },
    );
  }

  Widget _buildProductList() {
    return FutureBuilder<List<product_all_model.Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar los productos'));
        } else {
          final productList = snapshot.data ?? [];
          return ChangeNotifierProvider.value(
            value: _productState,
            child: ProductListScreen(
              productList: productList,
              openEditProductScreen: openEditProductScreen,
            ),
          );
        }
      },
    );
  }
}
