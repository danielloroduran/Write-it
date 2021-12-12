import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userID;
  CollectionReference ref;

  FirebaseService(this.userID){
  //  ref = _db.collection('usuarios').doc(userID).collection('notas');
    ref = _db.collection('usuarios');
  }

  Future<QuerySnapshot> getDataCollection(){
    return ref.doc(userID).collection('notas').get();
  }

  Stream<QuerySnapshot> streamDataCollection(){
    return ref.doc(userID).collection('notas').orderBy('fecha', descending: true).snapshots();
  }

  Stream<QuerySnapshot> streamDataImportant(){
    return ref.doc(userID).collection('notas').where('importante', isEqualTo: true).orderBy('fecha', descending: true).snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) async{
    return await ref.doc(userID).collection('notas').doc(id).get();
  }

  Future<void> removeDocument(String id) async{
    return await ref.doc(userID).collection('notas').doc(id).delete();
  }

  Future<DocumentSnapshot> addDocument(Map data) async{
    String id = ref.doc(userID).collection('notas').doc().id; // Crea documento nuevo sin datos, pero con ID aleatorio
    await ref.doc(userID).collection('notas').doc(id).set(data); // Sobreescribe todos los datos
    return await getDocumentById(id); // Devuelve el Snapshot con los datos actualizados
  }

  Future<void> updateDocument(Map data, String id) async{
    return await ref.doc(userID).collection('notas').doc(id).update(data);
  }

  Future<DocumentSnapshot> getUserById() async {
    return await ref.doc(userID).get();
  }

  Future<void> addUser(Map data) async{
    await ref.doc(userID).set(data); // Crea el usuario con su ID
  }

  Future <void> removeUser() async{
    return await ref.doc(userID).delete();
  }

  Future<void> updateUser(Map data) async{
    return await ref.doc(userID).update(data);
  }

  void addCollection() async{
    ref.doc(userID).collection("notas");
  }
}