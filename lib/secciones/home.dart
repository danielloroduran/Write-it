import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/modelos/nota.dart';
import 'package:notes_app/secciones/informacion.dart';
import 'package:notes_app/secciones/editarnota.dart';
import 'package:notes_app/secciones/perfil.dart';
import 'package:notes_app/secciones/vernota.dart';
import 'package:notes_app/servicios/firebaseservice.dart';
import 'package:notes_app/servicios/storageservice.dart';
import 'package:notes_app/servicios/userservice.dart';

class HomePage extends StatefulWidget{

  final FirebaseUser user;
  final UserService us;
  HomePage({Key key, this.user, this.us}) : super(key:  key);

  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  TextEditingController _busquedaController = new TextEditingController();
  bool _bandera;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  Stream _peticion;
  FirebaseService _fs;
  StorageService _ss;

  void initState(){
    super.initState();
    _bandera = false;
    _fs = new FirebaseService(widget.user.uid);
    _peticion = _fs.streamDataCollection();
    _ss = new StorageService(widget.user);
    
  }

  Widget build(BuildContext context){

    return Scaffold(
      key:  _key,
      body: new AnimatedContainer(
        duration: Duration(milliseconds: 100),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    var userN = widget.us.getCurrentUser();
                    userN.then((userC){
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => PerfilPage(userC, widget.us, _ss, _fs)),
                      );                      
                    });
                    /*Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => PerfilPage(, widget.us, _ss)),
                    );*/
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.centerRight,
                    child: CircleAvatar(
                      backgroundImage: widget.user.photoUrl != null && widget.user.photoUrl != "" ? NetworkImage(widget.user.photoUrl) : ExactAssetImage('imagenes/personagenerica.png'),
                      backgroundColor: Colors.transparent,
                      radius: 27,
                    ),
                  ),
                ),
                Text("Notas",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  )),
                Tooltip(
                  message: "Ir a Información",
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => InformacionPage()));
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.info)
                    ),
                  ),
                ),
              ],
            ),
            _busqueda(context),
            SizedBox(height: 10),
            _notas(context),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditarNota(fs: _fs, ss: _ss, uid: widget.user.uid)));
        },
        label: Text("Añadir nota"),
        icon: Icon(Icons.add),
      ),
    );
  }

  Widget _busqueda(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 8, right: 10),
              padding: EdgeInsets.only(left: 18),
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _busquedaController,
                      maxLines: 1,
                      onChanged: (valor){

                      },
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration.collapsed(
                        hintText: "Búsqueda",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                      ),
                    )
                  ),
                  IconButton(
                    tooltip: "Buscar",
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  )
                ],
              ),
            )
          ),
          Tooltip(
            message: _bandera ? "Mostrar todas las notas" : "Mostrar notas importantes",
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _bandera = !_bandera;
                  if(_bandera){
                    _peticion = _fs.streamDataImportant();
                  }else{
                    _peticion = _fs.streamDataCollection();
                  }
                });

              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                height: 50,
                width: 50,
                curve: Curves.slowMiddle,
                child: Icon(_bandera ? Icons.flag : Icons.outlined_flag, color: _bandera ? Colors.red : Theme.of(context).primaryColor),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  border: Border.all(
                    width: 2,
                    color: Colors.grey[400],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          )
        ],
      )
    );
  }

  Widget _crearNota(DocumentSnapshot document){

    Nota nota = new Nota(titulo: document['titulo'], mensaje: document['mensaje'], fecha: document['fecha'].toDate(), importante: document['importante'], id: document.documentID, urlImagen: document['urlImagen'], pathImagen: document['pathImagen']);

    String fecha = nota.fecha.day.toString() + "/" + nota.fecha.month.toString() + "/" + nota.fecha.year.toString() + ", " + nota.fecha.hour.toString() + ":" + nota.fecha.minute.toString();
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: nota.importante ? BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0,2),
            blurRadius: 6.0,
          )
        ]
      ) : null,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(nota.titulo.trim().length <= 20 ? nota.titulo.trim() : nota.titulo.trim().substring(0, 20) + "...",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  )
                ),
                Text(nota.mensaje.trim().split('\n').first.length <= 65 ? nota.mensaje.trim().split('\n').first : nota.mensaje.trim().split('\n').first.substring(0,65) + "...",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Icon(nota.importante ? Icons.flag : Icons.outlined_flag, color: nota.importante ? Colors.red : Theme.of(context).primaryColor),
                      Text(" "),
                      nota.urlImagen != "" && nota.urlImagen != null ? Icon(Icons.photo_camera) : Container(),
                      Spacer(),
                      Text(fecha),
                    ],
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => VerNota(nota, _fs, _ss, widget.user.uid)));
          },
        )
          
      ),
    );
    

  }

  Widget _notas(BuildContext context){
    return Center(
      child: StreamBuilder(
        stream: _peticion,
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator()
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) => _crearNota(snapshot.data.documents[index])
          );
        }

      ),
    );
  }

}