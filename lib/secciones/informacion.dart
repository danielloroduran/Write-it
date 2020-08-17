import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InformacionPage extends StatelessWidget{

  Widget build(BuildContext context){

    return Scaffold(
      body: new AnimatedContainer(
        duration: Duration(milliseconds: 100),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    tooltip: "Volver al inicio",
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  Text("Información",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    )
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 120),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            _info(context),
          ],
        )
      ),
    );
  }

  Widget _info(BuildContext context){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: EdgeInsets.all(24),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 15, top: 5, bottom: 20),
                child: Center(
                  child: Image.asset('imagenes/logo.png', height: 80, width: 80),
                )
              ),
              Center(
                child: Text("Desarrollado por",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  )
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Text("Daniel Loro",
                    style: TextStyle(
                      fontSize: 24,
                    )
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: OutlineButton.icon(
                  icon: Icon(Icons.link),
                  label: Text("Github",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    )
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: _goGithub
                )
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text("Usando",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlutterLogo(
                        size: 40
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Flutter",
                          style: TextStyle(
                            fontSize: 24
                          )
                        ),
                      ),
                    ],
                  )
                )
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset('imagenes/logofirebase.png', height: 40, width: 40),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Firebase",
                          style: TextStyle(
                            fontSize: 24
                          )
                        ),
                      )
                    ],
                  )
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  void _goGithub() async{
    if(await(canLaunch('https://www.github.com/daniloro5'))){
      await launch('https://www.github.com/daniloro5');
    }else{
      throw 'Imposible abrir el sitio web';
    }
  }
}