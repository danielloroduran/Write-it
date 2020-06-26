import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/modelos/nota.dart';
import 'package:notes_app/servicios/firebaseservice.dart';
import 'package:notes_app/servicios/storageservice.dart';

class EditarNota extends StatefulWidget{

  Nota nota;
  FirebaseService fs;
  StorageService ss;
  String uid;

  EditarNota({this.nota, this.fs, this.ss, this.uid});

  _EditarNotaState createState() => _EditarNotaState();

}

class _EditarNotaState extends State<EditarNota>{

  TextEditingController _tituloController;
  TextEditingController _mensajeController;
  bool _esNotaNueva;
  bool _haCambiado;
  bool _estaCargando;
  Nota _nota;
  File _imagen;
  void initState(){
    super.initState();

    if(widget.nota == null){
      _nota = Nota(titulo: "", mensaje: "", fecha: DateTime.now(), importante: false, pathImagen: "", urlImagen: "");
      _esNotaNueva = true;
    }else{
      _nota = widget.nota;
      _esNotaNueva = false;
    }

    _tituloController = new TextEditingController(text: _nota.titulo);
    _mensajeController = new TextEditingController(text: _nota.mensaje);

    _haCambiado = false;
    _estaCargando = false;
    _imagen = null;

  }
  
  Widget build(BuildContext context){

    return Scaffold(
      appBar: _getAppbar(),
      body: new ListView(
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              height: 118,
              padding: EdgeInsets.only(left: 15, top: 20),
              margin: EdgeInsets.only(right: 10),
              child: TextField(
                controller: _tituloController,
                style: TextStyle(
                  fontFamily: 'Opensans',
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (value){
                  setState(() {
                    _haCambiado = true;
                  });
                },
                decoration: InputDecoration(                  
                  hintText: "Título",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black
                    ),
                    borderRadius: BorderRadius.circular(20),
                  )
                )
              )
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.only(left: 15, top: 15, bottom: 15,),
              child: TextField(
                controller: _mensajeController,
                maxLines: null,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'OpenSans'
                ),
                onChanged: (value){
                  setState(() {
                    _haCambiado = true;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Mensaje",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black
                    ),
                    borderRadius: BorderRadius.circular(20),
                  )
                )
              )
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              margin: EdgeInsets.fromLTRB(15, 15, 10, 15),
              child: _nota.urlImagen != "" || _nota.urlImagen != null ? Image(image: NetworkImage(_nota.urlImagen)) : _imagen != null ? Image.file(_imagen) : null

/*              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _nota.urlImagen != "" || _nota.urlImagen != null ? Image(image: NetworkImage(_nota.urlImagen)) : _imagen != null ? Image.file(_imagen) : null
              )*/
            ),
          ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _imagen != null || _nota.urlImagen != "" ? Spacer(flex: 1): SizedBox(),
          _imagen != null || _nota.urlImagen != "" ? FloatingActionButton.extended(
            onPressed: (){
              _eliminarImagen();
            },
            tooltip: "Eliminar foto",
            heroTag: "btnEliminarFoto",
            label: Text("Eliminar foto"),
            icon: Icon(Icons.delete),
            backgroundColor: Colors.red,
          ): SizedBox(),
          _imagen != null || _nota.urlImagen != "" ? Spacer(flex: 1): SizedBox(),
          FloatingActionButton.extended(
            onPressed: (){
              _usoDeCamara();
            },
            tooltip: _imagen != null || _nota.urlImagen != "" ? "Modificar foto" : "Añadir foto",
            label: _imagen != null || _nota.urlImagen != "" ? Text("Modificar foto") : Text("Añadir foto"),
            heroTag: "btnCambiarFoto",
            icon: Icon(Icons.photo_camera),
            backgroundColor: Theme.of(context).primaryColor,
          )
        ],
      ),
    );

  }

  Widget _getAppbar(){
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: Container(
        alignment: Alignment.bottomCenter,
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: "Volver atrás",
              onPressed: () {
                if(_haCambiado){
                  _salirSinGuardar();
                }else{
                  Navigator.pop(context);
                }
              },
            ),
            Spacer(),
            IconButton(
              icon: Icon(_nota.importante == true ? Icons.flag : Icons.outlined_flag, color: _nota.importante == true ? Colors.red : Theme.of(context).primaryColor),
              tooltip: "Marcar como importante",
              onPressed: () {
                _nota.importante = !_nota.importante;
                _haCambiado = true;
              },
            ),
            _esNotaNueva == false ? IconButton(
              icon: Icon(Icons.delete),
              tooltip: "Eliminar nota",
              onPressed: (){
                _mostrarDialogo();
              },
            ) : SizedBox(),
            _estaCargando == false ? AnimatedContainer(
              margin: EdgeInsets.only(left: 10),
              duration: Duration(milliseconds: 100),
              width: _haCambiado ? 117 : 0,
              child: RaisedButton.icon(
                color: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                  )
                ),
                icon: Icon(Icons.done),
                label: Text("Guardar"),
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() {
                    _estaCargando = true;
                  });
                  _guardarNota();
                  setState(() {
                    _estaCargando = false;
                  });
                },
              )
            ) : CircularProgressIndicator(),
          ],
        ),
      )
    );
  }

  void _salirSinGuardar(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: new Text("Salir sin guardar", 
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            )
          ),
          content: new Text("Hay cambios sin guardar. ¿Seguro que quieres salir?",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            )
          ),
          actions: <Widget>[
            new Row(
              children: <Widget>[
                new FlatButton(
                  child: new Text("Salir",
                    style: TextStyle(
                      color: Colors.blueAccent
                    )
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                new FlatButton(
                  child: new Text("Seguir editando",
                    style: TextStyle(
                      color: Colors.blueAccent
                    )
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  }
                )
              ],
            )
          ],
        );
      }
    );
  }

  void _mostrarDialogo(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: new Text("Eliminar nota", 
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            )
          ),
          content: new Text("Estás a punto de eliminar esta nota. ¿Continuar?",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            )
          ),
          actions: <Widget>[
            new Row(
              children: <Widget>[
                new FlatButton(
                  child: new Text("Cancelar",
                    style: TextStyle(
                      color: Colors.blueAccent
                    )
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                new FlatButton(
                  child: new Text("Eliminar",
                    style: TextStyle(
                      color: Colors.blueAccent
                    )
                  ),
                  onPressed: (){
                    widget.fs.removeDocument(widget.nota.id);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                )
              ],
            )
          ],
        );
      }
    );
  }

  void _usoDeCamara(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: new Text("Cámara o galería",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          )),
          content: new Text("Seleccione desde donde se va a obtener la foto.",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            )),
          actions: <Widget>[
            new Row(
              children: <Widget>[
                new FlatButton(
                  child: new Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                new FlatButton(
                  child: new Text("Galería"),
                  onPressed: () {
                    Navigator.pop(context);
                    _getImagen(false);
                  },
                ),
                new FlatButton(
                  child: new Text("Cámara"),
                  onPressed: (){
                    Navigator.pop(context);
                    _getImagen(true);
                  }
                )
              ],
            )
          ],
        );
      }
    );
  }

  void _eliminarImagen(){
    if(_esNotaNueva){
      setState(() {
        _imagen = null;
        _haCambiado = true;
      });
    }else{
      setState(() {
//        _nota.urlImagen = "";
//        _nota.pathImagen = "";
        _imagen = null;
        _haCambiado = true;
      });
    }
  }

  Future _getImagen(bool usarCamara) async{

    var imagen;

    if(usarCamara){
      imagen = await ImagePicker().getImage(source: ImageSource.camera);
    }else{
      imagen = await ImagePicker().getImage(source: ImageSource.gallery);
    }

    setState(() {
      _haCambiado = true;

      if(imagen != null){
        _imagen = File(imagen.path);
      }

    });
  }

  void _guardarNota() async{

    String url;

    setState(() {
      _nota.titulo = _tituloController.text;
      _nota.mensaje = _mensajeController.text;
      _nota.fecha = DateTime.now();
      _nota.imagen = _imagen;
    });

    if(_esNotaNueva){

      var notaNueva = widget.fs.addDocument(_nota.toMap());

      notaNueva.then((valor){
        setState(() {
          _nota = Nota.fromMap(valor.data, valor.documentID);
        });
      });

      if(_imagen != null){
        url = await widget.ss.subirFotoNota(_imagen, _nota);
        _nota.urlImagen = url;
        _nota.pathImagen = widget.uid + "/" + _nota.id + ".jpg"; 
        widget.fs.updateDocument(_nota.toMap(), _nota.id);        
      }
      
    }else{

      if(_nota.pathImagen == "" && _nota.urlImagen == "" && _imagen != null){
        url = await widget.ss.subirFotoNota(_imagen, _nota);
        _nota.urlImagen = url;
        _nota.pathImagen = widget.uid + "/" + _nota.id + ".jpg";
      }else if(_nota.pathImagen != ""  && _nota.urlImagen != "" && _imagen != null){
        widget.ss.borrarFotoNota(_nota.pathImagen);
        url = await widget.ss.subirFotoNota(_imagen, _nota);
        _nota.urlImagen = url;
      }else if((_nota.pathImagen == "" || _nota.pathImagen != "") && _imagen == null){
        widget.ss.borrarFotoNota(_nota.pathImagen);
        _nota.pathImagen = "";
        _nota.urlImagen = "";
      }

      widget.fs.updateDocument(_nota.toMap(), _nota.id);
    }

    setState(() {
      _esNotaNueva = false;
      _haCambiado = false;
    });

  }


}