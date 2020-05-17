import 'package:expenseplanner/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './bars.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTx;

  Chart(this.recentTx);

  List<Map<String, Object>> get barList {
    return List.generate(7, (index) {
      final indexDate = DateTime.now().subtract(Duration(days: index));
      double indexSum = 0.0;

      for (int i = 0; i < recentTx.length; i++) {
        if (recentTx[i].date.day == indexDate.day &&
            recentTx[i].date.month == indexDate.month &&
            recentTx[i].date.year == indexDate.year) {
          indexSum += recentTx[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(indexDate).substring(0, 1),
        'amount': indexSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return barList.fold(0.0, (previousValue, element) {
      return previousValue + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: barList.map((index) {
            return Flexible(
              fit: FlexFit.tight,
              child: Bars(
                  label: index['day'],
                  amount: index['amount'],
                  amountPct: totalSpending == 0.0
                      ? 0.0
                      : (index['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
