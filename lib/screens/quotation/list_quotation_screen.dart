import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/screens/quotation/edit_quotation_screen.dart';
import 'package:pract_01/utils/quotation_utils.dart' as utils;
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
  String filter = 'Todos';
  String selectedFilter = 'Todos';
  TextEditingController searchController = TextEditingController();
  final MessagingService _messagingService = MessagingService();
  StreamSubscription<void>? _subscription;
  late QuotationState quotationState;

  void filterQuotations(List<Quotation> quotations) {
    filteredQuotations = utils.filterQuotations(quotations, selectedFilter);
    final String searchText = searchController.text;

    if (searchText.isNotEmpty) {
      filteredQuotations = filteredQuotations.where((quotation) {
        final String code = quotation.attributes.codeQuotation!.toUpperCase();
        return code.contains(searchText.toUpperCase());
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
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por código',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: DropdownButton<String>(
                  value: selectedFilter,
                  onChanged: (String? value) {
                    setState(() {
                      selectedFilter = value!;
                      final quotationState =
                          provider.Provider.of<QuotationState>(context,
                              listen: false);
                      filterQuotations(quotationState.quotations);
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
          automaticallyImplyLeading: false,
        ),
        body: provider.Consumer<QuotationState>(
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
                        openEditQuotationScreen: widget.openEditQuotationScreen,
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
