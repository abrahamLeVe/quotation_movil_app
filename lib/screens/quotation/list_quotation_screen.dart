import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/models/state/state_model.dart';
import 'package:pract_01/providers/dataState_state.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/services/quotation_service.dart';
import 'package:pract_01/widgets/quotation/quotation_list_item.dart';
import 'package:provider/provider.dart' as provider;

class QuotationListScreen extends StatefulWidget {
  final List<Quotation> quotationList;

  const QuotationListScreen({
    Key? key,
    required this.quotationList,
  }) : super(key: key);

  @override
  State<QuotationListScreen> createState() => _QuotationListScreenState();
}

class _QuotationListScreenState extends State<QuotationListScreen> {
  TextEditingController searchController = TextEditingController();
  DataState? selectedQuotationState;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();

    final dataStateState =
        provider.Provider.of<DataStateState>(context, listen: false);
    if (dataStateState.dataStates.isNotEmpty) {
      selectedQuotationState = dataStateState.dataStates.first;
      loadQuotationsByState(selectedQuotationState!.id);
    } else {
      provider.Provider.of<DataStateState>(context, listen: false)
          .loadNewDataStates(context);
    }
  }

  Future<void> loadQuotationsByState(int stateId) async {
    try {
      setState(() {
        isLoading = true;
      });

      final quotationService = QuotationService(context: context);
      final quotationModel = await quotationService.getAllQuotation(stateId);
      if (mounted) {
        provider.Provider.of<QuotationState>(context, listen: false)
            .setQuotations(quotationModel.data);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar las cotizaciones: $e');
      }
    }
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
                    provider.Provider.of<QuotationState>(context, listen: false)
                        .filterQuotations(value);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Filtrar por código',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 140,
              child: DropdownButton<DataState>(
                value: selectedQuotationState,
                onChanged: (DataState? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedQuotationState = newValue;
                    });
                    // Llama a la función para cargar las cotizaciones correspondientes al nuevo estado seleccionado
                    loadQuotationsByState(newValue.id);
                  }
                },
                items: [
                  // Agregar un elemento "Seleccione" al inicio de la lista
                  const DropdownMenuItem<DataState>(
                    value: null, // Valor nulo porque no se ha seleccionado nada
                    child: Text(
                        'Seleccione'), // Texto que se mostrará en el DropdownButton
                  ),
                  // Luego, agregar los elementos de la lista de estados
                  ...provider.Provider.of<DataStateState>(context, listen: true)
                      .dataStates
                      .map((DataState state) {
                    return DropdownMenuItem<DataState>(
                      value: state,
                      child: Text(state.attributes!.name),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        bottom: isLoading
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: ColorTween(
                    begin: Theme.of(context)
                        .colorScheme
                        .primary, // Color de respaldo
                  ).animate(const AlwaysStoppedAnimation(
                          1.0) // Usar un valor constante
                      ),
                ),
              )
            : null,
      ),
      body: provider.Consumer<QuotationState>(
        builder: (context, quotationState, _) {
          final filteredQuotations = quotationState.quotations;

          return filteredQuotations.isEmpty
              ? const Center(
                  child: Text('No hay cotizaciones disponibles'),
                )
              : ListView.builder(
                  itemCount: filteredQuotations.length,
                  itemBuilder: (BuildContext context, int index) {
                    final quotation = filteredQuotations[index];
                    return QuotationItem(
                      quotation: quotation,
                    );
                  },
                );
        },
      ),
    );
  }
}
