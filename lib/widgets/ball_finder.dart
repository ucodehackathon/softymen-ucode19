import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geo/geo.dart';
import 'package:ucode2019/widgets/compass/distance_viewer.dart';
import 'package:ucode2019/widgets/compass/compass.dart';
import 'dart:async';


class BallFinder extends StatefulWidget{

  final LatLng currentPosition;
  final LatLng ballPosition;
  final int id;
  final double segundos;
  final bool esMiTurno;
  BallFinder({Key key, this.currentPosition, this.ballPosition, this.id, this.segundos, this.esMiTurno}) : super(key: key);

  @override
  _BallFinderState createState() => _BallFinderState();
}

class _BallFinderState extends State<BallFinder> with TickerProviderStateMixin{
  double _angleToBall = 0.0;
  double _angleToNorth = 0.0;
  double _distance;
  bool ballReached = true;

  AnimationController _animationController;
  Animation<double> _animation;
   Timer t;
  double seconds = 10;
  String tiempoRest ="";

// user defined function
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Has perdido"),
          content: new Text("Ooops, parece que te han marcado un gol"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
}
  void startTimer(){
    Duration oneSec = const Duration(milliseconds: 100);
    t = new Timer.periodic(
      oneSec, (Timer time) => setState((){
        if(seconds < 0.1){
          _showDialog();
          
        }else{
          seconds = seconds - 0.1;
          tiempoRest = seconds.toStringAsFixed(1);
        }
      }));
  }


  @override
  void initState() {
    super.initState();
    startTimer();
    _animationController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);


    FlutterCompass.events.listen((double direction) {
      if(_animationController != null){
        _animationController.reset();
      }
      double destination;
      if(_angleToNorth - direction > 180){
        destination = direction + 360;
      }else if(_angleToNorth - direction < -180){
        destination = direction - 360;
      }else{
        destination = direction;
      }
      _animation = Tween<double>(begin: _angleToNorth, end: destination).animate(_animationController)
          ..addListener(() {
              setState(() {
                _angleToBall = (computeHeading(widget.currentPosition != null
                                                  ? widget.currentPosition
                                                  : LatLng(0.0, 0.0),
                                  widget.ballPosition) - _animation.value)%360;
              });
          });
      _animationController.forward();
      _angleToNorth = direction;           
    });
  }
  
  @override
  Widget build(BuildContext context){
  _distance = computeDistanceBetween(
              widget.currentPosition != null
                ? widget.currentPosition
                : LatLng(0.0, 0.0),
              widget.ballPosition != null
                ? widget.ballPosition
                : LatLng(100.0, 100.0));
    if(_distance < 3.0 && !ballReached){
      ballReached = true;
    }else if(ballReached){
      ballReached = false;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'JUGADOR  ' + widget.id.toString(),
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w200
                ),
              ),
            ),
            Compass(height: 370.0, width: 370.0, angleToBall: _angleToBall, distance: _distance, currentPosition: widget.currentPosition, esMiTurno: widget.esMiTurno, ballReached: ballReached,),
            Container(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'DISTANCIA\nOBJETIVOS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w200
                      ),
                    ),
                    DistanceViewer(distance: _distance)
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('TIEMPO\nRESTANTE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w200
                    ),
                  ),
                    (widget.esMiTurno
                    ? Text( tiempoRest,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w200
                      ),
                    )
                    : Text(
                        'TURNO\nOPONENTE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.white
                        ) ,
                      )),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  @override
  void dispose(){
    _animationController.dispose();
    super.dispose();
  }  
}