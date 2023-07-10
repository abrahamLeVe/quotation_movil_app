import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/services/quotation_service.dart';
import 'package:pract_01/utils/quotation_utils.dart' as utils;
import 'package:pract_01/widgets/quotation/quotation_list_item.dart';
import 'package:provider/provider.dart' as provider;

class QuotationListScreen extends StatefulWidget {
  const QuotationListScreen({Key? key}) : super(key: key);

  @override
  State<QuotationListScreen> createState() => _QuotationListScreenState();
}

class _QuotationListScreenState extends State<QuotationListScreen> {
  List<Quotation> quotations = [];
  List<Quotation> filteredQuotations = [];
  bool isLoading = false;
  String filter = 'Todos';
  String selectedFilter = 'Todos';
  TextEditingController searchController = TextEditingController();

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    final result = await QuotationService().getAllQuotation();
    final allQuotations = result.data;

    final quotationState =
        // ignore: use_build_context_synchronously
        provider.Provider.of<QuotationState>(context, listen: false);
    quotationState.setQuotations(
        allQuotations); // Actualiza el estado global de las cotizaciones

    setState(() {
      isLoading = false;
      quotations = allQuotations;
      filterQuotations(); // Aplica los filtros inicialmente
    });
  }

  void filterQuotations() {
    filteredQuotations = utils.filterQuotations(quotations, selectedFilter);
    final String searchText = searchController.text;

    if (searchText.isNotEmpty) {
      filteredQuotations = filteredQuotations.where((quotation) {
        final String code = quotation.attributes.codeQuotation.toUpperCase();
        return code.contains(searchText.toUpperCase());
      }).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(); // Inicializa el formato de fecha para la localización actual
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      filterQuotations(); // Aplica el filtro de búsqueda cada vez que se cambia el texto
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Filtrar por código',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 100, // Ajusta el ancho según tus necesidades
              child: DropdownButton<String>(
                value: selectedFilter,
                onChanged: (String? value) {
                  setState(() {
                    selectedFilter = value!;
                    filterQuotations(); // Aplica los filtros cuando se cambia el filtro
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
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : provider.Consumer<QuotationState>(
              builder: (context, quotationState, _) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredQuotations.length,
                        itemBuilder: (BuildContext context, int index) {
                          final quotation = filteredQuotations[index];
                          return QuotationItem(quotation: quotation);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
