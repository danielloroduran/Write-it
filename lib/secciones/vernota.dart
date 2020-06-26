import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/modelos/nota.dart';
import 'package:notes_app/secciones/editarnota.dart';
import 'package:notes_app/servicios/firebaseservice.dart';
import 'package:notes_app/servicios/storageservice.dart';
import 'package:share/share.dart';

class VerNota extends StatefulWidget{

  Nota nota;
  FirebaseService fs;
  StorageService ss;
  String uid;

  VerNota(this.nota, this.fs, this.ss, this.uid);

  _VerNotaState createState() => _VerNotaState();

}

class _VerNotaState extends State<VerNota>{

  String _fecha;

  void initState(){
    super.initState();
    _fecha = widget.nota.fecha.day.toString() + "/" + widget.nota.fecha.month.toString() + "/" + widget.nota.fecha.year.toString() + ", "+ widget.nota.fecha.hour.toString() + ":" + widget.nota.fecha.minute.toString() + ":" + widget.nota.fecha.second.toString(); 

  }
  
  Widget build(BuildContext context){

    return Scaffold(
      body: new AnimatedContainer(
        duration: Duration(milliseconds: 100),
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.nota.importante = !widget.nota.importante;
                    });
                    guardarNota();
                  },
                  icon: Icon(widget.nota.importante ? Icons.flag : Icons.outlined_flag, color: widget.nota.importante ? Colors.red : Theme.of(context).primaryColor),
                  tooltip: "Marcar como importante",
                ),
                IconButton(
                  onPressed: () {
                    _mostrarDialogo();
                  },
                  icon: Icon(Icons.delete),
                  tooltip: "Eliminar nota",
                ),
                IconButton(
                  onPressed: () {
                    Share.share('${widget.nota.titulo.trim()}\n(On: ${widget.nota.fecha.toIso8601String().substring(0, 10)})\n\n${widget.nota.mensaje}');
                  },
                  icon: Icon(Icons.share),
                  tooltip: "Compartir",
                ),
                AnimatedContainer(
                  margin: EdgeInsets.only(left: 10),
                  duration: Duration(milliseconds: 100),
                  child: RaisedButton.icon(
                    color: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                      )
                    ),
                    icon: Icon(Icons.edit),
                    label: Text("Editar"),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => EditarNota(nota: widget.nota, fs: widget.fs, ss: widget.ss, uid: widget.uid)));
                    },
                  )
                )
              ],
            ),
            Container(
              height: 90,
              margin: EdgeInsets.only(right: 15),
              padding: EdgeInsets.only(left: 15, top: 20),
              child: Text(widget.nota.titulo,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                ),
                softWrap: true,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15),
              child: Text("Última edición: " + _fecha,
                style: TextStyle(
                  fontSize: 16,
                )
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 15),
              padding: EdgeInsets.only(left: 15, top: 15),
              height: 100,
              child: Text(widget.nota.mensaje,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'OpenSans'
                )),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              margin: EdgeInsets.fromLTRB(15, 0, 10, 15),
              color: Colors.transparent,
              child: widget.nota.urlImagen != "" && widget.nota.urlImagen != null ? Image(image: NetworkImage(widget.nota.urlImagen)) : null,
/*              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: widget.nota.urlImagen != "" && widget.nota.urlImagen != null ? Image(image: NetworkImage(widget.nota.urlImagen)) : null,
//                child: widget.nota.imagen != null ? Image.file(widget.nota.imagen) : null
              )*/
            ),
          ],
        )
      )
    );

  }

    void guardarNota(){

      widget.fs.updateDocument(widget.nota.toMap(), widget.nota.id);

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
          content: new Text("Estás a punto de eliminar esta nota. ¿Continuar?"),
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
                  }
                )
              ],
            )
          ],
        );
      }
    );
  }


}