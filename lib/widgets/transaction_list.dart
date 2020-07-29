import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'package:flutter_complete_guide/services/firestore-crud.dart';

class TransactionList extends StatefulWidget {
//  final List<Transactions> transactions;
//  TransactionList(this.transactions);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final titleController = TextEditingController();
  final commentController = TextEditingController();
  final amountController = TextEditingController();
  DateTime selectedDate;
  CrudMethods crudObj = CrudMethods();
  @override
  void initState() {
    // TODO: implement initState
    getInitialData();
    super.initState();
  }

  getInitialData() {
    crudObj.getData();
    setState(() {});
  }

  void submitData(docID) {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);
    final enteredComment = commentController.text;

    if (selectedDate == null) {
      selectedDate = DateTime.now();
    }

    dynamic txData = {
      'amount': enteredAmount,
      'name': enteredTitle,
      'date': selectedDate
    };

    crudObj.updateData(docID, txData);
    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  updateDialog(BuildContext context, docID) {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          child: Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: titleController,
                    onSubmitted: (_) => submitData(docID),
                    // onChanged: (val) {
                    //   titleInput = val;
                    // },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => submitData(docID),
                    // onChanged: (val) => amountInput = val,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Comment'),
                    controller: commentController,
                    onSubmitted: (_) => submitData(docID),
                    // onChanged: (val) {
                    //   titleInput = val;
                    // },
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? 'Today'
                                : 'Picked Date: ${DateFormat.yMd().format(selectedDate)}',
                          ),
                        ),
                        FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            'Choose Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: presentDatePicker,
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    child: Text('Update Transaction'),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.button.color,
                    onPressed: () => submitData(docID),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
//        child: crudObj.getData().isEmpty

        child: StreamBuilder(
            stream: crudObj.getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Icon(
                      Icons.account_balance_wallet,
                      size: 100,
                      color: Colors.black38,
                    ),
                    Text(
                      'No transactions added yet!',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.black38),
                    ),
                  ],
                );
              }
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    child: InkWell(
                      splashColor: Colors.pink.withAlpha(30),
                      onTap: () {
                        updateDialog(
                            context, snapshot.data.documents[index].documentID);
                      },
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              '₹${snapshot.data.documents[index].data['amount'].toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                snapshot.data.documents[index].data['name'],
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(
                                DateFormat.yMMMd().format(snapshot
                                    .data.documents[index].data['date']
                                    .toDate()),
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              crudObj.deleteData(
                                  snapshot.data.documents[index].documentID);
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
