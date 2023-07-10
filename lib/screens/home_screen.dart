import 'package:flutter/material.dart';
import 'package:pract_01/models/product/product_model.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/screens/product/edit_product_screen.dart';
import 'package:pract_01/screens/product/list_product_screen.dart';
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
  late Tab _productTab;
  late QuotationState _quotationState;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _productTab = const Tab(text: 'Productos (Cargando...)');
    _quotationState = QuotationState();
    _loadData();
  }

  void _loadData() async {
    _loadProducts();
    _loadQuotations();
  }

  void _loadProducts() async {
    final result = await ProductService().getAllProduct();
    setState(() {
      _productsFuture = Future.value(result.data);
      _productTab = Tab(text: 'Productos (${result.data.length})');
    });
  }

  void _loadQuotations() async {
    final result = await QuotationService().getAllQuotation();
    final allQuotations = result.data;
    _quotationState.setQuotations(allQuotations);
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _quotationState,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pantalla Principal'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              _productTab,
              Consumer<QuotationState>(
                builder: (context, quotationState, _) {
                  final quotationCount = quotationState.quotations.length;
                  return Tab(text: 'Cotizaciones ($quotationCount)');
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
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
                  return ProductListScreen(
                    productList: productList,
                    openEditProductScreen: openEditProductScreen,
                  );
                }
              },
            ),
            const QuotationListScreen(),
          ],
        ),
      ),
    );
  }
}
