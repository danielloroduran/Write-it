import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:notes_app/modelos/nota.dart';

class StorageService{

  FirebaseStorage _db = FirebaseStorage.instance;
  Reference reference;
  UploadTask uploadTask;
  TaskSnapshot taskSnapshot;
  final User user;


  StorageService(this.user);

  Future<String> subirFotoPerfil(File imagen) async{
    reference = _db.ref().child("/"+user.uid+"/perfil.jpg");
    uploadTask = reference.putFile(imagen);
    return await uploadTask.snapshot.ref.getDownloadURL();
  }

  Future borrarFotoPerfil(String path) async{
    _db.ref().child(path).delete();
  }

  Future<String> subirFotoNota(File imagen, Nota nota) async{
    reference = _db.ref().child("/"+user.uid+"/"+nota.id+".jpg");
    uploadTask = reference.putFile(imagen);
    return await uploadTask.snapshot.ref.getDownloadURL();
  }

  Future borrarFotoNota(String path) async{
    await _db.ref().child(path).delete();
  }

}