import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import './models/transactions.dart';
import './widgets/transactions_list.dart';
import './widgets/text_fields.dart';
import './widgets/chart.dart';

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
    title: 'Expenses Planner',
    theme: ThemeData(
      primarySwatch: Colors.lightGreen,
      textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'ComicNeue',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            button: TextStyle(
              color: Colors.white,
            ),
          ),
      appBarTheme: AppBarTheme(
          elevation: 0,
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              )),
    ),
  ));
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> myList = [
    Transaction(
        id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
  ];

  void makeNewTx(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: txDate);
    setState(() {
      myList.add(newTx);
    });
  }

  void _deleteTx(txID) {
    setState(() {
      myList.removeWhere((element) => element.id == txID);
    });
  }

  void bottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return TextFields(makeNewTx);
      },
    );
  }

  List<Transaction> get _lastWeekList {
    return myList
        .where((element) =>
            element.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  bool _showChart = false;

  List<Widget> _buildLandscape(
      MediaQueryData mediaQuery, AppBar appBar, txListWidget) {
    return [
      Row(
        children: [
          Text('Show Chart?'),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.6,
              child: Chart(_lastWeekList),
            )
          : txListWidget,
    ];
  }

  List<Widget> _buildPortrait(
      MediaQueryData mediaQuery, AppBar appBar, txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) *0.3,
        child: Chart(_lastWeekList),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expense Planner'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => bottomSheet(context),
                  child: Icon(CupertinoIcons.add),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Expense Planner'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => bottomSheet(context),
              ),
            ],
          );

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(myList: myList, deleteTx: _deleteTx));

    final scaffoldBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLandscape)
              ..._buildLandscape(mediaQuery, appBar, txListWidget),
            if (!isLandscape)
              ..._buildPortrait(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: scaffoldBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: scaffoldBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => bottomSheet(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
