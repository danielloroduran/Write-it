import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/servicios/userservice.dart';
import 'package:notes_app/secciones/home.dart';
import 'package:notes_app/secciones/login.dart';

enum AuthStatus{
  NO_DETERMINADO,
  NO_LOGEADO,
  LOGEADO
}

class RootPage extends StatefulWidget{

  final UserService us;
  RootPage({this.us});

  @override
  _RootPageState createState() => new _RootPageState();

}

class _RootPageState extends State<RootPage>{
  AuthStatus authStatus = AuthStatus.NO_DETERMINADO;
  FirebaseUser _user;

  @override
  void initState(){
    super.initState();
    widget.us.getCurrentUser().then((user){
      setState(() {
        if(user!= null){
          _user = user;
        }
        authStatus = user == null ? AuthStatus.NO_LOGEADO : AuthStatus.LOGEADO; 
      });
    });
  }

  Widget build(BuildContext context){
    switch(authStatus){
      case AuthStatus.NO_DETERMINADO:
        return pantallaCarga();
        break;
      case AuthStatus.NO_LOGEADO:
        return new LoginPage(us: widget.us);
        break;
      case AuthStatus.LOGEADO:
        if(_user != null){
          return HomePage(user: _user, us: widget.us);
        }else{
          return pantallaCarga();
        }
        break;
      default:
        return pantallaCarga();
    }
  }

  Widget pantallaCarga(){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
    );
  }
}