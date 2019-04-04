import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geo/geo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ucode2019/widgets/ball_finder.dart';

class Game extends StatefulWidget {
  final FirebaseApp app;
  final int id;
  final LatLng currentPosition;
  Game({Key key, this.app, this.currentPosition, this.id}) : super(key: key);

  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  
  LatLng _currentPosition;
  LatLng _ballPosition;
  double segundos = 0.0;
  bool esMiTurno = true;

  void initState() { 
    super.initState();
    _currentPosition = widget.currentPosition;
    _ballPosition = widget.currentPosition;
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    // database.reference().child('dev/games/partida1').once().then((event){
    //   if(event.value != null){
    //     setState((){
    //       esMiTurno = ('jugador' + widget.id.toString() == event.value['player_active']);
    //       segundos = event.value['time_expire']['seconds'];
    //       double lat = event.value['loc']['0'];
    //       double lng = event.value['loc']['1'];
    //       _ballPosition = LatLng(lat, lng);
    //     });
    //   }  
    // });

    database.reference().child('dev/games/partida1').onChildChanged.listen((event){
      if(event.snapshot != null){
        setState((){
          esMiTurno = ('jugador' + widget.id.toString() == event.snapshot.value['player_active']);
          segundos = event.snapshot.value['time_expire']['seconds'];
          double lat = event.snapshot.value['loc']['0'];
          double lng = event.snapshot.value['loc']['1'];
          _ballPosition = LatLng(lat, lng);
        });
      }  
    });

    var geolocator = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
    geolocator.getPositionStream(locationOptions).listen((Position position){
      database.reference().child('dev/users/jugador'+ widget.id.toString() +'/location').update({"0":position.latitude, "1":position.longitude});
      setState(() {
        _currentPosition =  LatLng(position.latitude, position.longitude);
      });
    });    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: BallFinder(
         currentPosition: _currentPosition, 
         ballPosition: _ballPosition, 
         id: widget.id, 
         segundos: segundos,
         esMiTurno:esMiTurno),
    );
  }
}