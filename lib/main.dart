import 'package:flutter/material.dart';
import 'package:notes_app/secciones/root.dart';
import 'package:notes_app/servicios/userservice.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Notes App',
      initialRoute: '/',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        primaryColor: Colors.black,
        backgroundColor: Colors.redAccent,
        textTheme: TextTheme(
          
          headline1: TextStyle(
            color: Colors.white,
          ),
          subtitle1: TextStyle(
            fontWeight: FontWeight.w400,
          )
        )
        

      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.black,
          ),
          subtitle1: TextStyle(
            fontWeight: FontWeight.w400,
          )
        )
      ),
      home: new RootPage(us: new UserService()),
    );
  }
  
}


