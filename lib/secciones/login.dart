import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/secciones/home.dart';
import 'package:notes_app/secciones/registro.dart';
import 'package:notes_app/servicios/userservice.dart';

class LoginPage extends StatefulWidget{

  UserService us;
  LoginPage({this.us});
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  User _user;
  String _falloEmail;
  String _falloPassword;
  bool _validateEmail;
  bool _validatePassword;
  bool _passwordVisible;

  void initState(){
    super.initState();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _validateEmail = false;
    _validatePassword = false;
    _passwordVisible = false;
    _falloEmail = "";
    _falloPassword = "";
  }

  Widget build(BuildContext context){

    return Form(
      key: _formKey,
      child: new Scaffold(
        key: _scaffoldKey,
        body: new Container(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 30, bottom: 30),
                  child: Center(
                    child: new Text("Notas",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans'
                      )
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 35, top: 10, bottom: 20),
                  child: Center(
                    child: Image.asset('imagenes/logo.png', height: 120, width: 120)
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25, 20, 10, 10),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: "EMAIL",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      errorText: _validateEmail ? _falloEmail : null,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25, 10, 10, 0),
                  child: TextField(
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
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      errorText: _validatePassword ? _falloPassword : null,
                    ),
                    obscureText: _passwordVisible == true ? false : true,
                  )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(200, 0, 10, 10),
                  child: TextButton(
                    style: ButtonStyle(
                      //textStyle: MaterialStateProperty.all(Theme.of(context).buttonTheme.textTheme),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    ),
                    onPressed: () {},
                    child: Text("¿Contraseña olvidada?"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25, 0, 10, 10),
                  child: ElevatedButton(
                    child: Text("Iniciar sesión",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      )
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).buttonTheme.colorScheme.background)
                    ),
                    onPressed: (){
                      if(_emailController.text == "" && _passwordController.text == ""){
                        setState(() {
                          _validateEmail = true;
                          _validatePassword = true;
                          _falloEmail = "Introduzca un email";
                          _falloPassword = "Introduzca una contraseña";
                        });                      
                      }else if(_emailController.text == ""){
                        setState(() {
                          _validateEmail = true;
                          _validatePassword = false;
                          _falloEmail = "Introduzca un email";
                          _falloPassword = "";
                        });
                      }else if(_passwordController.text == ""){
                        setState(() {
                          _validateEmail = false;
                          _validatePassword = true;
                          _falloEmail = "";
                          _falloPassword = "Introduzca una contraseña";
                        });
                      }else{
                        setState(() {
                          _validateEmail = false;
                          _validatePassword = false;
                          _falloEmail = "";
                          _falloPassword = "";
                        });
                        iniciarSesion();
                      }
                    },
                    
                  )
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(25, 10, 10, 10),
                    child: Text("O inicie sesión con",
                      style: Theme.of(context).textTheme.subtitle1)
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage("imagenes/logofb.png"),
                              fit: BoxFit.cover,
                            )
                          )
                        ),
                        onTap: () {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Función por implementar. Stay tune!"),));
                        },
                      ),
                      InkWell(
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage("imagenes/logogoogle.png"),
                              fit: BoxFit.fill,
                            )
                          )
                        ),
                        onTap: () {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Función por implementar. Stay tune!"),));
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => RegistroPage(widget.us)),
                      );                       
                    },
                    child: Text("Registrarse"),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),)
                    ),
                    //textTheme: Theme.of(context).buttonTheme.textTheme,

                  ),
                ),
              ],
            ),
          )
        )
      )
    );

  }

  void iniciarSesion() async {
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        _user = await widget.us.signInEmail(_emailController.text, _passwordController.text);
        //FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)).user;
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user: _user, us: widget.us)));
      }catch(e){
        switch(e.code){
          case "ERROR_INVALID_EMAIL":
          setState(() {
            _falloEmail = "Email incorrecto";
            _validateEmail = true;
          });
          break;
          case "ERROR_USER_NOT_FOUND":
          setState(() {
            _falloEmail = "Email no encontrado";
            _validateEmail = true;
          });
          break;
          case "ERROR_WRONG_PASSWORD":
          setState(() {
            _falloPassword = "Contraseña incorrecta";
            _validatePassword = true;
          });
          break;
        }
      }
    }
  }

}