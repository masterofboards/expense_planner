import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextFields extends StatefulWidget {
  final Function newTx;

  TextFields(this.newTx);

  @override
  _TextFieldsState createState() => _TextFieldsState();
}

class _TextFieldsState extends State<TextFields> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  DateTime _selectedDate;

  submitData() {
    final inputTitle = _titleController.text;
    final inputAmount = double.parse(_amountController.text);

    if (inputTitle.isEmpty || inputAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.newTx(inputTitle, inputAmount, _selectedDate);
    //newTx was added before the createState was run, so in order to call it, you have to use widget.newTx. Try delete "widget." and read the error message.
    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000, 1, 1),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom +10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                autocorrect: true,
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) {
                  return submitData();
                },
              ),
              TextField(
                autocorrect: true,
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) {
                  return submitData();
                },
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                            'Selected Date: ${_selectedDate == null ? 'No Date Chosen!' : DateFormat.yMEd().format(_selectedDate)}')),
                    FlatButton(
                      child: const Text(
                        'Choose Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: presentDatePicker,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                color: Colors.grey[100],
                child: const Text(
                  'Add Transaction',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: submitData,
                textColor: Theme.of(context).textTheme.button.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
