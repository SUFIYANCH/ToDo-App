import 'package:cloud_firestore/cloud_firestore.dart';

class TodoService {
  // CollectionReference for todo

  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("todo");

  // Read all todos as Stream

  Stream<QuerySnapshot> todoStream() {
    return _collectionReference.snapshots();
  }

  // add todo

  Future<DocumentReference<Object?>> addTodo(String title) {
    return _collectionReference.add({"title": title, "isDone": false});
  }

  // update todo by id

  Future<void> updateTodo(String id, bool isDone) {
    return _collectionReference.doc(id).update({"isDone": isDone});
  }

  // delete todo by id

  Future<void> deleteTodo(String id) {
    return _collectionReference.doc(id).delete();
  }
}
