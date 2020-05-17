import 'package:flutter/material.dart';
import '../models/transactions.dart';
import './tx_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> myList;
  final Function deleteTx;

  TransactionList({this.myList, this.deleteTx});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: ListView(
        children:
         myList.map((e) {
           return TxItem(key: ValueKey(e.id), myList: e, deleteTx: deleteTx);
         }).toList(),
      ),
    );
  }
}

