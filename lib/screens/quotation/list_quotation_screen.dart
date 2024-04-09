import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/models/state/state_model.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/screens/quotation/edit_quotation_screen.dart';
import 'package:pract_01/screens/quotation/quotation_actions.dart';
import 'package:pract_01/services/state_service.dart';
import 'package:pract_01/widgets/quotation/quotation_list_item.dart';
import 'package:provider/provider.dart' as provider;
import 'package:pract_01/services/messaging/messaging_service.dart';

class QuotationListScreen extends StatefulWidget {
  final List<Quotation> quotationList;
  final void Function(Quotation) openEditQuotationScreen;

  const QuotationListScreen({
    Key? key,
    required this.quotationList,
    required this.openEditQuotationScreen,
  }) : super(key: key);
  @override
  State<QuotationListScreen> createState() => _QuotationListScreenState();
}

class _QuotationListScreenState extends State<QuotationListScreen> {
  List<Quotation> filteredQuotations = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  final MessagingService _messagingService = MessagingService();
  StreamSubscription<void>? _subscription;
  late QuotationState quotationState;
  List<DataState> quotationStates = [];
  DataState? selectedQuotationState;

  void filterQuotations(List<Quotation> quotations) {
    if (selectedQuotationState != null) {
      // Filtrar por estado seleccionado
      filteredQuotations = quotations
          .where((quotation) =>
              quotation.attributes.state.data.id == selectedQuotationState!.id)
          .toList();
    } else {
      // Si no hay estado seleccionado, muestra todas las cotizaciones
      filteredQuotations = quotations;
    }

    final String searchText = searchController.text.toUpperCase();
    if (searchText.isNotEmpty) {
      // Filtrar adicionalmente por el texto de búsqueda
      filteredQuotations = filteredQuotations.where((quotation) {
        final String code = quotation.id.toString();
        return code.contains(searchText);
      }).toList();
    }
  }

  void openEditQuotationScreen(Quotation quotation) async {
    final updatedQuotation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditQuotationScreen(
          quotation: quotation,
          onQuotationUpdated: (updatedQuotation) {},
        ),
      ),
    );

    if (updatedQuotation != null) {
      // --
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    final quotationState =
        provider.Provider.of<QuotationState>(context, listen: false);
    _subscription = _messagingService.onQuotationsUpdated.listen((_) {
      setState(() {
        filteredQuotations = quotationState.quotations;
      });
    });
    _loadQuotationStates();

    // Escuchar el Stream para actualizaciones de cotizaciones debido a notificaciones
    _subscription = _messagingService.onQuotationsUpdated.listen((_) {
      // Llamar a un método para resetear el estado seleccionado y recargar las cotizaciones
      resetToDefaultStateAndReload();
    });
  }

  void resetToDefaultStateAndReload() async {
    // Encuentra el estado con ID 1 y establece como seleccionado
    final defaultState = quotationStates.firstWhere(
      (s) => s.id == 1,
      orElse: () => DataState(
        id: 1, /* otros campos */
      ),
    );

    setState(() {
      selectedQuotationState = defaultState;
    });
    // Aquí también podrías recargar las cotizaciones basadas en el estado por defecto si es necesario
    // Por ejemplo, podría ser una llamada a un método que haga una petición de red para obtener las cotizaciones
  }

  void _loadQuotationStates() async {
    setState(() => isLoading = true); // Iniciar carga
    try {
      final stateModel = await StateService(context: context).getState();
      setState(() {
        quotationStates = stateModel.data;
        // Establece el estado por defecto al que tenga ID 1, si existe
        selectedQuotationState =
            quotationStates.firstWhere((state) => state.id == 1);
      });
    } catch (error) {
      print('Error cargando estados de cotizaciones: $error');
    } finally {
      setState(() => isLoading = false); // Finalizar carga
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                        final quotationState =
                            provider.Provider.of<QuotationState>(context,
                                listen: false);
                        filterQuotations(quotationState.quotations);
                      });
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Permitir solo dígitos
                    ],
                    keyboardType:
                        TextInputType.number, // Mostrar teclado numérico
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por código',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: DropdownButton<DataState>(
                  value: selectedQuotationState,
                  onChanged: (DataState? newValue) async {
                    if (newValue != null) {
                      setState(() {
                        selectedQuotationState = newValue;
                        isLoading =
                            true; // Suponiendo que tienes un indicador de carga.
                      });

                      try {
                        await updateQuotationsCache(context, newValue.id);

                        setState(() {
                          isLoading = false;
                        });
                      } catch (error) {
                        print(
                            "Error al filtrar cotizaciones por estado: $error");
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                  items: quotationStates
                      .map<DropdownMenuItem<DataState>>((DataState state) {
                    return DropdownMenuItem<DataState>(
                      value: state,
                      child: Text(state.attributes!.name),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator()) // Mostrar spinner
            : provider.Consumer<QuotationState>(
                builder: (context, quotationState, _) {
                  final quotations = quotationState.quotations;

                  filterQuotations(quotations);

                  if (quotationState.isNewNotificationAvailable()) {
                    filterQuotations(quotationState.quotations);
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredQuotations.length,
                          itemBuilder: (BuildContext context, int index) {
                            final quotation = filteredQuotations[index];
                            return QuotationItem(
                              openEditQuotationScreen:
                                  widget.openEditQuotationScreen,
                              quotation: quotation,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
