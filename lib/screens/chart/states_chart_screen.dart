import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:provider/provider.dart';

class ChartsStatesScreen extends StatelessWidget {
  const ChartsStatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productCounts =
        Provider.of<QuotationState>(context).getProductStatesCounts();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text("Productos Más Vendidos"),
        backgroundColor: Colors.white,
      ),
      body: Column(
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
                  leading: Image.network(productCounts[key]?['picture_url'],
                      width: 50, height: 50),
                  title: Text(
                    productCounts[key]?['name'],
                    style: const TextStyle(
                      color: Colors.white, // Texto en blanco
                    ),
                  ),
                  subtitle: Text(
                    'Cantidad: ${productCounts[key]?['quantity']}',
                    style: const TextStyle(
                      color: Colors.white70, // Texto en blanco con opacidad
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
