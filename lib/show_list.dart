import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customer.dart';
import 'dbhelper.dart';

class ShowList extends StatefulWidget {
  const ShowList({Key? key}) : super(key: key);

  @override
  _ShowListState createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {

  final dbHelper = DatabaseHelper.instance;
  List<Customer> customers = [];

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    customers.clear();
    // ignore: avoid_function_literals_in_foreach_calls
    allRows.forEach((row) => customers.add(Customer.fromMap(row)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show List'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: customers.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == customers.length) {
            return RaisedButton(
              child: const Text('Refresh'),
              onPressed: () {
                setState(() {
                  _queryAll();
                });
              },
            );
          }
          return SizedBox(
            height: 40,
            child: Center(
              child: Text(
                '[${customers[index].surveyNo}] ${customers[index].zoneNo} - ${customers[index].wardNo}',
              ),
            ),
          );
        },
      ),
    );
  }
}
