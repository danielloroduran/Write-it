import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{

  final Firestore _db = Firestore.instance;
  final String userID;
  CollectionReference ref;

  FirebaseService(this.userID){
  //  ref = _db.collection('usuarios').document(userID).collection('notas');
    ref = _db.collection('usuarios');
  }

  Future<QuerySnapshot> getDataCollection(){
    return ref.document(userID).collection('notas').getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection(){
    return ref.document(userID).collection('notas').orderBy('fecha', descending: true).snapshots();
  }

  Stream<QuerySnapshot> streamDataImportant(){
    return ref.document(userID).collection('notas').where('importante', isEqualTo: true).orderBy('fecha', descending: true).snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) async{
    return await ref.document(userID).collection('notas').document(id).get();
  }

  Future<void> removeDocument(String id) async{
    return await ref.document(userID).collection('notas').document(id).delete();
  }

  Future<DocumentSnapshot> addDocument(Map data) async{
    String id = ref.document(userID).collection('notas').document().documentID; // Crea documento nuevo sin datos, pero con ID aleatorio
    await ref.document(userID).collection('notas').document(id).setData(data); // Sobreescribe todos los datos
    return await getDocumentById(id); // Devuelve el Snapshot con los datos actualizados
  }

  Future<void> updateDocument(Map data, String id) async{
    return await ref.document(userID).collection('notas').document(id).updateData(data);
  }

  Future<DocumentSnapshot> getUserById() async {
    return await ref.document(userID).get();
  }

  Future<void> addUser(Map data) async{
    await ref.document(userID).setData(data); // Crea el usuario con su ID
  }

  Future <void> removeUser() async{
    return await ref.document(userID).delete();
  }

  Future<void> updateUser(Map data) async{
    return await ref.document(userID).updateData(data);
  }

  void addCollection() async{
    ref.document(userID).collection("notas");
  }
}