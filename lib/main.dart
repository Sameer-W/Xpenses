import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/popupmenuitems.dart';
import 'package:flutter_complete_guide/widgets/history-transactions.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        MyHomePage.id: (context) => MyHomePage(),
        HistoryPage.id: (context) => HistoryPage(),
      },
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          )),
      initialRoute: MyHomePage.id,
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const id = 'home-page';
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transactions> userTransactions = [];
  double bal = 0;

  updateBalance(enteredAmount) {
    bal = bal - enteredAmount;
  }

  void _addNewTransaction(String txTitle, double txAmount, String txComment) {
    final newTx = Transactions(
      name: txTitle,
      amount: txAmount,
      comment: txComment,
      date: DateTime.now(),
      id: DateTime.now().toString(),
    );

    setState(() {
      userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

//TODO: Test this first
  void _startAddMoney(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    onSubmitted: (balance) {
                      Navigator.pop(context);
                      bal = bal + double.parse(balance);
                    },
                  ),
                ],
              ),
            ),
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void choiceAction(String choice) {
    if (choice == PopupMenuItems.debit) {
      _startAddNewTransaction(context);
    }
    if (choice == PopupMenuItems.credit) {
      _startAddMoney(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.pink,
                ),
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('History'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width / 3,
          child: Expanded(
            child: ListTile(
              title: Text(
                'Balance',
                style: TextStyle(fontSize: 20.0),
              ),
              subtitle: Text(
                '₹$bal',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Xpenses',
          ),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: choiceAction,
              itemBuilder: (context) {
                return PopupMenuItems.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
//          IconButton(
//            icon: Icon(Icons.add),
//            onPressed: () => _startAddNewTransaction(context),
//          ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TransactionList(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ),
    );
  }
}
