import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geo/geo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ucode2019/game.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
class Login extends StatefulWidget {
  final FirebaseApp app;
  Login({Key key, this.app}) : super(key: key);

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  double _fieldSize = 20.0;
  int jugadorSeleccionado = 1;
  LatLng _currentPosition;

  void initState() { 
    super.initState();
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
    geolocator.getPositionStream(locationOptions).listen((Position position){
      if(position != null){
        _currentPosition = LatLng(position.latitude, position.longitude);
      }
    });      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:ListView(
        children: <Widget>[
          Container(height: 200),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                activeColor: Colors.white,
                value: 1,
                groupValue: jugadorSeleccionado,
                onChanged: (value){
                  setState(() {
                    jugadorSeleccionado = value;
                  });
                },
              ),
              Text('Jugador 1', style: TextStyle(color: Colors.white))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Radio(
                activeColor: Colors.white,
                value: 2,
                groupValue: jugadorSeleccionado,
                onChanged: (value){
                  setState(() {
                    jugadorSeleccionado = value;
                  });
                },
              ),
              Text('Jugador 2', style: TextStyle(color: Colors.white))
            ],
          ),
          Container(height: 50.0),
          Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Text('Tamaño del campo', style: TextStyle(color: Colors.white, fontSize: 20.0))
            )
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Slider(
                  min: 10.0,
                  max: 30.0,
                  divisions: 20,
                  value: _fieldSize,
                  activeColor: Colors.white,
                  onChanged: (newValue){
                    setState(() {
                      _fieldSize = newValue;
                    });
                  },
                ),
                Text(_fieldSize.toStringAsFixed(1) + ' m', style: TextStyle(color: Colors.white),)
              ],
            ),
          ),
          Container(height: 50.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 100.0),
            child: FlatButton(
              child: Text('CONTINUAR'),
              color: Colors.green,
              onPressed: ()  async {
                if(_currentPosition != null){
                  await http.get("https://us-central1-ucode2019-3ef7f.cloudfunctions.net/reserveHall?iduser=jugador"+jugadorSeleccionado.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Game(
                      app: widget.app, 
                      currentPosition: _currentPosition,
                      id:jugadorSeleccionado
                      )
                    )
                  );
                }
              },
            ),
          )
        ],
      )
    );
  }
}