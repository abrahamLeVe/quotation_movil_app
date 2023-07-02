// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation_model.dart';
import 'package:pract_01/services/network_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Quotation> quotations = [];

  bool isLoading = false;

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    final result = await NetworkManager().getAll();
    quotations = result.data;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Quotation"),
        actions: const [],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: quotations.length,
              physics: const ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(quotations[index].attributes.name),
                    subtitle: Text(quotations[index].attributes.email),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          formData();
        },
        child: const Icon(Icons.remove),
      ),
    );
  }

  void formData() async {
    bool confirm = false;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to add a quotation?'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              ),
              onPressed: () {
                confirm = true;
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    if (confirm) {
      print("Confirmed!");
    }
  }
}
