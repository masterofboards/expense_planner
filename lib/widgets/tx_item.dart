import 'dart:math';

import 'package:flutter/material.dart';
import '../models/transactions.dart';
import 'package:intl/intl.dart';

class TxItem extends StatefulWidget {
  final Transaction myList;
  final Function deleteTx;
  const TxItem({Key key, this.myList, this.deleteTx,}) : super(key: key);

  @override
  _TxItemState createState() => _TxItemState();
}

class _TxItemState extends State<TxItem> {
  Color _bgColor;

  @override
  void initState() {
    const List availableColors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.cyan,
      Colors.blue,
      Colors.purple,
    ];


    _bgColor = availableColors[Random().nextInt(4)];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 70,
          child: CircleAvatar(
            backgroundColor: _bgColor,
            radius: 40,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: FittedBox(
                  child: Text('\$${widget.myList.amount.toStringAsFixed(2)}')),
            ),
          ),
        ),
        title: Text('${widget.myList.title}'),
        subtitle: Text('${DateFormat.yMMMMd().format(widget.myList.date)}'),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                onPressed: () => widget.deleteTx(widget.myList.id),
                icon: const Icon(Icons.delete),
                textColor: Theme.of(context).errorColor,
                label: const Text('Delete'))
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTx(widget.myList.id),
              ),
      ),
    );
  }
}
