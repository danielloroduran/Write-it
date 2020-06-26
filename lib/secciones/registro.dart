import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/secciones/home.dart';
import 'package:notes_app/servicios/firebaseservice.dart';
import 'package:notes_app/servicios/storageservice.dart';
import 'package:notes_app/servicios/userservice.dart';

class RegistroPage extends StatefulWidget{

  final UserService us;

  RegistroPage(this.us);

  _RegistroPageState createState() => _RegistroPageState();

}

class _RegistroPageState extends State<RegistroPage>{

  bool _estaCargando;
  bool _passwordVisible;
  bool _validateNombre;
  bool _validateEmail;
  bool _validatePassword;
  String _falloNombre;
  String _falloEmail;
  String _falloPassword;
  File _fotoPerfil;
  TextEditingController _nombreController;
  TextEditingController _emailController;
  TextEditingController _passwordController;


  void initState(){
    super.initState();
    _estaCargando = false;
    _validateNombre = false;
    _validateEmail = false;
    _validatePassword = false;
    _passwordVisible = false;
    _nombreController = new TextEditingController();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _emailController.text = "";
    _falloNombre = "";
    _falloPassword = "";
    _falloEmail = "";
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: _getAppbar(context),
      body: ListView(
        children: <Widget>[
         AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: 150,
            height: 150,
            margin: EdgeInsets.only(top: 50, left: 130, right: 130),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: _fotoPerfil != null ? ExactAssetImage(_fotoPerfil.path) : ExactAssetImage('imagenes/personagenerica.png'),
                fit: BoxFit.cover,
              )
            ),
          ), 
          Container(
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
          ),
          Container(
            margin:EdgeInsets.fromLTRB(35, 20, 35, 10),
            child: TextField(
              style: TextStyle(
                fontSize: 20
              ),
              controller: _nombreController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: "NOMBRE",
                border:OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black
                  ), 
                  borderRadius: BorderRadius.circular(20)
                ),
                errorText: _validateNombre == true  ? _falloNombre : null,
                enabled: true,
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(20),
                )

              ),
            )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(35, 0, 35, 10),
            child: TextField(
              style: TextStyle(
                fontSize: 20
              ),
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: "EMAIL",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black
                  ), 
                  borderRadius: BorderRadius.circular(20)
                ),
                enabled: true,
                errorText: _validateEmail == true ? _falloEmail : null,
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(35, 0, 35, 10),
            child: TextField(
              style: TextStyle(
                fontSize: 20
              ),
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                hintText: "CONTRASEÑA",
                suffixIcon: IconButton(
                  icon: Icon(_passwordVisible == false ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
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
                    color: Colors.red
                  ),
                  borderRadius: BorderRadius.circular(20)
                ),
                errorText: _validatePassword == true ? _falloPassword : null,
                helperText:  "Más de 6 caracteres, con al menos número, una letra mayúscula, una minúscula y un caracter especial",  
                helperMaxLines: 2,
              ),
              obscureText: _passwordVisible == true ? false : true,
            )
          )
        ],
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
                Navigator.pop(context);  
              },
            ),
            SizedBox(width: 100),
            Expanded(
              child: Text("Registro",
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
              child: _estaCargando == false ?RaisedButton.icon(
                color: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                  )
                ),
                icon: Icon(Icons.done),
                label: Text("Registrarse"),
                textColor: Theme.of(context).primaryColor,
                onPressed: () {

                  setState(() {
                    _estaCargando = true;
                  });

                  Pattern patron = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                  RegExp regex = new RegExp(patron);
                  if(_passwordController.text.isEmpty && _nombreController.text.isEmpty){
                    setState(() {
                      _validateNombre = true;
                      _falloNombre = "Este campo no puede estar en blanco";
                      _validatePassword = true;
                      _falloPassword = "Este campo no puede estar en blanco";
                      _estaCargando = false;
                    });
                  }else if(_nombreController.text.isEmpty){
                    setState(() {
                      _validateNombre = true;
                      _falloNombre = "Este campo no puede estar en blanco";
                      _validatePassword = false;
                      _falloPassword = "";
                      _estaCargando = false;
                    });  
                  }else if(_passwordController.text.isEmpty){
                    setState(() {
                      _validateNombre = false;
                      _falloNombre = "";
                      _validatePassword = true;
                      _falloPassword = "Este campo no puede estar en blanco";
                      _estaCargando = false;
                    });
                  }else if(!regex.hasMatch(_passwordController.text) ||  _passwordController.text.length < 6){
                    setState(() {
                      _validateNombre = false;
                      _falloNombre = "";
                      _validatePassword = true;
                      _falloPassword = "La contraseña no cumple con la seguridad requerida";
                      _estaCargando = false;
                    });                    
                  }else{
                    setState(() {
                      _validateNombre = false;
                      _falloNombre = "";
                      _validatePassword = false;
                      _falloPassword = "";
                      _estaCargando = true;
                    });
                    _registrarse();
                  }
                }
              ) : CircularProgressIndicator(),
            )
          ],
        )
      )
    );
  }

  void _registrarse() async{

    try{
      FirebaseUser user = await widget.us.createUser(_emailController.text, _passwordController.text);
      _actualizarDatos(user);

    }catch(e){
      print(e);
      switch(e.code){
        case "ERROR_INVALID_EMAIL":
          setState(() {
            _validateEmail = true;
            _falloEmail = "Email no válido";
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

  void _actualizarDatos(FirebaseUser user) async{

    String url = "";

    try{
      print("Antes de UserInfo");
      UserUpdateInfo userInfo = UserUpdateInfo();
      print("Después de userInfo");
      userInfo.displayName = _nombreController.text;
      print("Antes de SS");
      StorageService ss = new StorageService(user);
      print("Antes de la URL");

      if(_fotoPerfil != null){
        url = await ss.subirFotoPerfil(_fotoPerfil);
        print("Ya tengo la URL");
        userInfo.photoUrl = url;
        print("He asignado la URL");        
      }

      await user.updateProfile(userInfo);
      print("Uso updateProfile");

      FirebaseService fs = new FirebaseService(user.uid);

      Map<String, dynamic> userMap = {"nombre" : _nombreController.text, "email" : _emailController.text, "fotoURL" : url};
      fs.addUser(userMap);
      print("Antes de updateUser");
      fs.updateUser(userMap);
      print("Después de updateUser");

      setState(() {
        _estaCargando = false;
      });

      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => HomePage(user: user, us: widget.us)),
      );
    }catch(e){
      print(e);
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
        _fotoPerfil = File(imagen.path);
      });
    }
  }

}