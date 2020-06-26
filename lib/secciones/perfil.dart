import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/servicios/firebaseservice.dart';
import 'package:notes_app/servicios/storageservice.dart';
import 'package:notes_app/servicios/userservice.dart';

class PerfilPage extends StatefulWidget{

  final StorageService ss;
  FirebaseUser user;
  final UserService us;
  final FirebaseService fs;

  PerfilPage(this.user, this.us, this.ss, this.fs);

  _PerfilPageState createState() => _PerfilPageState();

}

class _PerfilPageState extends State<PerfilPage>{

  bool _editar;
  bool _haCambiado;
  bool _passwordActualVisible;
  bool _passwordNuevaVisible;
  bool _validateEmail;
  bool _validatePasswordActual;
  bool _validatePasswordNueva;
  String _falloEmail;
  String _falloPasswordActual;
  String _falloPasswordNueva;
  File _fotoPerfil;
  //String _urlPerfil;
  TextEditingController _nombreController;
  TextEditingController _emailController;
  TextEditingController _passwordActualController;
  TextEditingController _passwordNuevaController;


  void initState(){
    super.initState();
    _editar = false;
    _haCambiado = false;
    _validateEmail = false;
    _validatePasswordActual = false;
    _validatePasswordNueva = false;  
    _passwordActualVisible = false;
    _passwordNuevaVisible = false;
    _nombreController = new TextEditingController();
    _nombreController.text = widget.user.displayName;
    _emailController = new TextEditingController();
    _emailController.text = widget.user.email;
    _passwordActualController = new TextEditingController();
    _passwordNuevaController = new TextEditingController();
    _falloPasswordActual = "";
    _falloPasswordNueva = "";
    _falloEmail = "";
//    _urlPerfil = widget.user.photoUrl;

    
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: _getAppbar(context),
      body: ListView(
        children: <Widget>[
          widget.user.photoUrl != "" && widget.user.photoUrl != null ? AnimatedContainer(
            duration: Duration(milliseconds: 100),
            margin: EdgeInsets.only(top: 50, right: 130, left: 130),
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: ExactAssetImage('imagenes/personagenerica.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(75.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 7.0,
                  color: Colors.black,
                )
              ],
            ),
          ) : _fotoPerfil != null ? AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: 150,
            height: 150,
            margin: EdgeInsets.only(top: 50, left: 130, right: 130),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: ExactAssetImage(_fotoPerfil.path),
                fit: BoxFit.cover,
              )
            ),
          ) : AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: 150,
            height: 150,
            margin: EdgeInsets.only(top: 50, left: 130, right: 130),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: ExactAssetImage('imagenes/personagenerica.png'),
                fit: BoxFit.cover,
              )
            ),
          ), 
          _editar == true ? Container(
            margin: EdgeInsets.symmetric(horizontal: 90),
            child: RaisedButton.icon(
              
              label: Text("Cambiar foto de perfil"),
              icon: Icon(Icons.camera_alt),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.title.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))
              ),
              onPressed: (){
                _usoDeCamara();
              }
            ),
          ) : SizedBox(),
          Container(
            margin: _editar == false ? EdgeInsets.fromLTRB(90, 100, 35, 10) : EdgeInsets.fromLTRB(35, 20, 35, 10),
            child: TextField(
              style: TextStyle(
                fontSize: 20
              ),
              controller: _nombreController,
              onChanged: (value){
                setState(() {
                  _haCambiado = true;
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: "NOMBRE",
                border: _editar ? OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(20)) : InputBorder.none,
                enabled: _editar,
              ),
            )
          ),
          Container(
            margin: _editar == false ? EdgeInsets.fromLTRB(90, 0, 35, 10) : EdgeInsets.fromLTRB(35, 0, 35, 10),
            child: TextField(
              style: TextStyle(
                fontSize: 20
              ),
              controller: _emailController,
              onChanged: (value){
                setState(() {
                  _haCambiado = true;
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: "EMAIL",
                border: _editar ? OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(20)) : InputBorder.none,
                enabled: _editar,
                errorText: _validateEmail == true ? _falloEmail : null,
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(20),
                )
              ),
              keyboardType: TextInputType.emailAddress,
            )
          ),
        ],
      ),
      floatingActionButton: _editar == false ? FloatingActionButton.extended(
        heroTag: "btnCerrar",
        backgroundColor: Colors.red,
        onPressed: () {
          widget.us.cerrarSesion();
          Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false); 
        },
        label: Text("Cerrar sesión"),
        icon: Icon(Icons.exit_to_app),
      ) : FloatingActionButton.extended(
        heroTag: "btnPassword",
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          _cambiarPassword(context);
        },
        label : Text("Cambiar contraseña"),
        icon: Icon(Icons.vpn_key),
      ),
    );
  }

  Widget _getAppbar(BuildContext context){
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: Container(
        alignment: Alignment.bottomCenter,
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: "Volver al inicio",
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if(_haCambiado){
                  _salirSinGuardar();
                }else{
                  setState(() {
                    _editar = false;
                  });
                  Navigator.pop(context);
                }
              },
            ),
            Spacer(flex: 1),
            Expanded(
              child: Text("Perfil",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                  fontSize: 30
                )
              )
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
                icon: _editar == false ? Icon(Icons.edit) : Icon(Icons.done),
                label: _editar == false ? Text("Editar") : Text("Guardar"),
                textColor: Theme.of(context).primaryColor,
                onPressed: _editar == false ? () {
                  setState(() {
                    _editar = !_editar;
                  });
                } : () {
                  _guardarDatos();
                },
              )
            )
          ],
        )
      )
    );
  }

  void _guardarDatos() async{

    String url;

    try{
      UserUpdateInfo userInfo = UserUpdateInfo();
      userInfo.displayName = _nombreController.text;

      if(_fotoPerfil != null){
        url = await widget.ss.subirFotoPerfil(_fotoPerfil);
        userInfo.photoUrl = url;
      }
      
      await widget.user.updateProfile(userInfo);
      await widget.user.updateEmail(_emailController.text);

      Map<String, dynamic> userMap = {"nombre" : _nombreController.text, "email" : _emailController.text, "fotoURL" : url};

      widget.fs.updateUser(userMap);

      FirebaseUser userAct = await widget.us.getCurrentUser();
      setState(() {
        widget.user = userAct;
        _editar = false;
        _haCambiado = false;
      });
    }catch(e){
      switch(e.code){
        case "ERROR_INVALID_EMAIL":
          setState(() {
            _validateEmail = true;
            _falloEmail = "Email incorrecto";
          });
          break;
        default:
          setState((){
            _validateEmail = false;
            _falloEmail = "";
          });
      }
    }
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
                  child: new Text("Salir"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                new FlatButton(
                  child: new Text("Seguir editando"),
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

  void _cambiarPassword(context){

    showDialog(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Text("Cambio de contraseña",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                )
              ),
              content: new Container(
                height: _validatePasswordActual == true ? 270 : 240,
                child: new Column(
                  children: <Widget>[
                    SizedBox(height: 5),
                    new TextField(
                      controller: _passwordActualController,
                      decoration: InputDecoration(
                        hintText: "CONTRASEÑA ACTUAL",
                        suffixIcon: IconButton(
                          icon: Icon(_passwordActualVisible == false ? Icons.visibility : Icons.visibility_off),
                          onPressed: (){
                            setState(() {
                              _passwordActualVisible = !_passwordActualVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black
                          ),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorText: _validatePasswordActual == true ? _falloPasswordActual : null,
                      ),
                      obscureText: _passwordActualVisible == true ? false : true,
                      autofocus: true,
                    ),
                    SizedBox(height: 15),
                    new TextField(
                      controller: _passwordNuevaController,
                      decoration: InputDecoration(
                        hintText: "NUEVA CONTRASEÑA",
                        suffixIcon: IconButton(
                          icon: Icon(_passwordActualVisible == false ? Icons.visibility : Icons.visibility_off),
                          onPressed: (){
                            setState(() {
                              _passwordNuevaVisible = !_passwordNuevaVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black
                          ),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        helperText: "Más de 6 caracteres, con letras y números",
                        errorText: _validatePasswordNueva == true ? _falloPasswordNueva : null,
                      ),
                      obscureText: _passwordNuevaVisible == true ? false : true,
                    ),
                    SizedBox(height: 20),
                    new Container(
                      height: 40,
                      width: 300,
                      child: new RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        color: Colors.blue,
                        child:  Text("Actualizar", style: TextStyle(color: Colors.white)),
                        onPressed: (){   
                          if(_passwordActualController.text == "" && _passwordNuevaController.text == ""){
                            setState(() {
                              _validatePasswordNueva = true;
                              _validatePasswordActual = true;
                              _falloPasswordActual = "Este campo no puede estar en blanco";
                              _falloPasswordNueva = "Este campo no puede estar en blanco";
                            });
                          }else if(_passwordActualController.text == ""){
                            setState(() {
                              _validatePasswordNueva = false;
                              _validatePasswordActual = true;
                              _falloPasswordActual = "Este campo no puede estar en blanco";
                              _falloPasswordNueva = "";
                            });
                          }else if(_passwordNuevaController.text == ""){
                            setState(() {
                              _validatePasswordActual = false;
                              _validatePasswordNueva = true;
                              _falloPasswordNueva = "Este campo no puede estar en blanco";
                              _falloPasswordActual = "";
                            });
                          }else{
                            setState(() {
                              _validatePasswordActual = false;
                              _validatePasswordNueva = false;
                              _falloPasswordNueva = "";
                              _falloPasswordActual = "";
                            });
                          }
                          _reautenticar();                                                           
                        },
                      )
                    )
                  ],
                )
              )

            );
          }
        );
      }
    );
  }

  void _reautenticar() async{
    try{
      
      AuthResult auth = await widget.user.reauthenticateWithCredential(
      EmailAuthProvider.getCredential(
        email: widget.user.email,
        password: _passwordActualController.text,
      )
    );
//      await auth.user.updatePassword(_passwordNuevaController.text);
      print("Contraseña actualizada");
    }catch(e){
      switch(e.code){
        case "ERROR_WRONG_PASSWORD":
          setState(() {
            _validatePasswordActual = false;
            _falloPasswordActual = "Contraseña incorrecta";
          });
          break;
        default:
          print(e.message);
          break;
      }
    }
  }

  void _usoDeCamara(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Cámara o galería",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            )),
          content: new Text("Seleccione desde donde se va a obtener la foto.",
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
                  child: new Text("Galería",
                    style: TextStyle(
                      color: Colors.blueAccent
                    )
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _getImagen(false);
                  },
                ),
                new FlatButton(
                  child: new Text("Cámara",
                    style: TextStyle(
                      color: Colors.blueAccent
                    )
                  ),
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

  Future _getImagen(bool usarCamara) async{

    var imagen;

    if(usarCamara){
      imagen = await ImagePicker().getImage(source: ImageSource.camera);
    }else{
      imagen = await ImagePicker().getImage(source: ImageSource.gallery);
    }

    if(imagen != null){
      setState(() {
        _haCambiado = true;
//        _urlPerfil = "";
        _fotoPerfil = File(imagen.path);
      });
    }
  }
}