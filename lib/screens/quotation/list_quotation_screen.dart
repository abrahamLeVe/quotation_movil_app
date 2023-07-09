import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/services/quotation_service.dart';
import 'package:pract_01/utils/quotation_utils.dart' as utils;
import 'package:pract_01/widgets/quotation/quotation_list_item.dart';

class QuotationListScreen extends StatefulWidget {
  const QuotationListScreen({Key? key}) : super(key: key);

  @override
  State<QuotationListScreen> createState() => _QuotationListScreenState();
}

class _QuotationListScreenState extends State<QuotationListScreen> {
  List<Quotation> quotations = [];
  bool isLoading = false;
  String filter = 'Todos';
  TextEditingController searchController = TextEditingController();

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    final result = await QuotationService().getAllQuotation();
    final allQuotations = result.data;

    quotations = utils.filterQuotations(allQuotations, filter);
    setState(() {
      isLoading = false;
    });
  }

  void filterQuotations() {
    final String searchText = searchController.text;
    final List<Quotation> filteredQuotations =
        utils.filterQuotations(quotations, filter);

    if (searchText.isNotEmpty) {
      final List<Quotation> searchResults =
          filteredQuotations.where((quotation) {
        final String code = quotation.attributes.codeQuotation.toUpperCase();
        return code.contains(searchText.toUpperCase());
      }).toList();

      setState(() {
        quotations = searchResults;
      });
    } else {
      setState(() {
        quotations = filteredQuotations;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    refreshData();
    initializeDateFormatting("es_PE");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Cotizaciones'),
            const SizedBox(
                width: 8), // Espacio entre el título y el campo de búsqueda
            Expanded(
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  filterQuotations();
                },
                decoration: const InputDecoration(
                  labelText: 'Filtrar por código',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                DropdownButton<String>(
                  value: filter,
                  onChanged: (String? value) {
                    setState(() {
                      filter = value!;
                      refreshData();
                    });
                  },
                  items: [
                    'Todos',
                    'Hoy',
                    'Ayer',
                    'Semana',
                    'Mes',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: quotations.length,
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final quotation = quotations[index];
                      return QuotationItem(quotation: quotation);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
