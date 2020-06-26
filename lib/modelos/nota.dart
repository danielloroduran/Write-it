import 'dart:io';

class Nota{

  String id;
  String titulo;
  String mensaje;
  bool importante;
  DateTime fecha;
  File imagen;
  String pathImagen;
  String urlImagen;
  

  Nota({this.id, this.titulo, this.mensaje, this.importante, this.fecha, this.imagen, this.pathImagen, this.urlImagen});

  Nota.fromMap(Map snapshot,  String id) :
    id = id ?? '',
    titulo = snapshot['titulo'] ?? '',
    mensaje = snapshot['mensaje'] ?? '',
    importante = snapshot['importante'] ?? false,
    fecha = snapshot['fecha'].toDate() ?? DateTime.now(),
    pathImagen = snapshot['pathImagen'] ?? '',
    urlImagen = snapshot['urlImagen'] ?? '';

  toJson(){
    return{
      "titulo" : titulo,
      "mensaje" : mensaje,
      "importante" : importante,
      "fecha" : fecha,
      "pathImagen" : pathImagen,
      "urlImagen" : urlImagen,
    };
  }
 
  Map<String, dynamic> toMap() =>{
    "titulo" : titulo,
    "mensaje" : mensaje,
    "importante" : importante,
    "fecha" : fecha,
    "pathImagen" : pathImagen,
    "urlImagen" : urlImagen,
  };

}