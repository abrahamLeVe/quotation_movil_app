import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:provider/provider.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productCounts =
        Provider.of<QuotationState>(context).getProductCounts();
    int totalProducts = productCounts.values
        .map((e) => e['quantity']
            as int) // Asegura que los valores sean tratados como enteros
        .fold(0, (a, b) => a + b); // Usa fold con 0 como valor inicial

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text("Productos Más Cotizados"),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<QuotationState>(context, listen: false)
                  .loadFullQuotations(context);
            },
          ),
        ],
      ),
      body: productCounts.isEmpty
          ? const Center(
              child: Text('No hay productos más cotizados.',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: PieChart(
                      PieChartData(
                        sections: _getSections(productCounts),
                        centerSpaceRadius: 70,
                        sectionsSpace: 4,
                        centerSpaceColor: Colors
                            .black87, // Si quieres un color específico en el centro
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total de productos cotizados: ${productCounts.length}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total de unidades cotizados: $totalProducts',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: productCounts.length,
                    itemBuilder: (context, index) {
                      var sortedKeys = productCounts.keys.toList()
                        ..sort((a, b) => productCounts[b]?['quantity']
                            .compareTo(productCounts[a]?['quantity']));
                      var key = sortedKeys[index];
                      return ListTile(
                        leading: Image.network(
                            productCounts[key]?['picture_url'],
                            width: 50,
                            height: 50),
                        title: Text(
                          productCounts[key]?['name'],
                          style: const TextStyle(
                            color: Colors.white, // Texto en blanco
                          ),
                        ),
                        subtitle: Text(
                          'Cantidad: ${productCounts[key]?['quantity']}',
                          style: const TextStyle(
                            color:
                                Colors.white70, // Texto en blanco con opacidad
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  List<PieChartSectionData> _getSections(
      Map<String, Map<String, dynamic>> productCounts) {
    if (productCounts.isEmpty) {
      return [];
    }
    int total =
        productCounts.values.map((e) => e['quantity']).reduce((a, b) => a + b);

    if (total == 0) {
      return [];
    }

    List<PieChartSectionData> sections = [];
    var sortedEntries = productCounts.entries.toList()
      ..sort((a, b) => b.value['quantity'].compareTo(a.value['quantity']));

    sortedEntries = sortedEntries.take(5).toList();

    for (var entry in sortedEntries) {
      final percentage = (entry.value['quantity'] / total) * 100;
      sections.add(
        PieChartSectionData(
          color: Colors.primaries[sections.length % Colors.primaries.length],
          value: percentage,
          title:
              '${entry.value['name']} ${percentage.toStringAsFixed(1)}% (${entry.value['quantity']})',
          titleStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color:
                Colors.white, // Asegúrate de que el texto del gráfico es blanco
          ),
          radius: 70,
        ),
      );
    }

    return sections;
  }
}
