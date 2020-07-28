import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  final _firestore = Firestore.instance;
  Future<void> addData(txData) async {
    _firestore.collection('transactions').add(txData);
  }

  getData() {
    return _firestore
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots();
  }

  deleteData(docID) {
    _firestore.collection('transactions').document(docID).delete();
  }
}
