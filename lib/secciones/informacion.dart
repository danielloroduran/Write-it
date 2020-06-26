import 'package:flutter/material.dart';

class InformacionPage extends StatefulWidget{

  _InformacionPageState createState() => _InformacionPageState();

}

class _InformacionPageState extends State<InformacionPage>{

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
          ],
        )
      ),
    );
  }
}