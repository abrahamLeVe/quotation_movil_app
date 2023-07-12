import 'package:flutter/material.dart';
import 'package:pract_01/models/product/product_model.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart'
    as quotation_all_model;
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/providers/product_state.dart';
import 'package:pract_01/screens/product/edit_product_screen.dart';
import 'package:pract_01/screens/product/list_product_screen.dart';
import 'package:pract_01/screens/quotation/edit_quotation_screen.dart';
import 'package:pract_01/screens/quotation/list_quotation_screen.dart';
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
  Future<List<Product>>? _productsFuture;
  Future<List<quotation_all_model.Quotation>>? _quotationsFuture;

  late Tab _quotationTab;
  late QuotationState _quotationState;
  late ProductState _productState;
  late QuotationState quotationState;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _quotationTab = const Tab(text: 'Cotizaciones (Cargando...)');
    _quotationState = Provider.of<QuotationState>(context, listen: false);
    _productState = Provider.of<ProductState>(context, listen: false);
    quotationState = Provider.of<QuotationState>(context, listen: false);
    _loadData();
  }

  void _loadData() async {
    _loadQuotations();
    _loadProducts();
  }

  void _loadQuotations() async {
    final result = await QuotationService().getAllQuotation();

    setState(() {
      _quotationsFuture = Future.value(result.data);
      _quotationTab = Tab(text: 'Cotizaciones (${result.data.length})');
    });
    _quotationState.setQuotations(result.data);
  }

  void _loadProducts() async {
    final result = await ProductService().getAllProduct();
    setState(() {
      _productsFuture = Future.value(result.data);
    });
    _productState.setProducts(result.data);
  }

  void openEditProductScreen(Product product) async {
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
            _loadQuotations();
            quotationState.updateQuotationProvider(updatedQuotation);
          },
        ),
      ),
    );

    if (result == true) {
      _loadQuotations();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            _quotationTab,
            Consumer<ProductState>(
              builder: (context, productState, _) {
                final productCount = productState.products.length;
                return Tab(text: 'Productos ($productCount)');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder<List<quotation_all_model.Quotation>>(
            future: _quotationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error al cargar las cotizaciones'),
                );
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
          ),
          FutureBuilder<List<Product>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error al cargar los productos'),
                );
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
          ),
        ],
      ),
    );
  }
}
