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

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
//        child: crudObj.getData().isEmpty

        child: StreamBuilder(
            stream: crudObj.getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: 100,
                        color: Colors.black38,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'No transactions added yet!',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.black38),
                      ),
                    ),
                  ],
                );
              }
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (ctx, index) {
                  return Card(
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
                  );
                },
              );
            }));
  }
}
