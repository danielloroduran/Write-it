import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:notes_app/modelos/nota.dart';

class StorageService{

  FirebaseStorage _db = FirebaseStorage.instance;
  StorageReference reference;
  StorageUploadTask uploadTask;
  StorageTaskSnapshot taskSnapshot;
  final FirebaseUser user;


  StorageService(this.user);

  Future<String> subirFotoPerfil(File imagen) async{
    reference = _db.ref().child("/"+user.uid+"/perfil.jpg");
    uploadTask = reference.putFile(imagen);
    taskSnapshot = await uploadTask.onComplete;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future borrarFotoPerfil(String path) async{
    _db.ref().child(path).delete();
  }

  Future<String> subirFotoNota(File imagen, Nota nota) async{
    reference = _db.ref().child("/"+user.uid+"/"+nota.id+".jpg");
    uploadTask = reference.putFile(imagen);
    taskSnapshot = await uploadTask.onComplete;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future borrarFotoNota(String path) async{
    await _db.ref().child(path).delete();
  }

}