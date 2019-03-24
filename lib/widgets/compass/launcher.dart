import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geo/geo.dart';
import 'package:sensors/sensors.dart';


class BallLauncher extends StatefulWidget {
  final double width;
  final LatLng currentPosition;
  BallLauncher({Key key, this.width, this.currentPosition}) : super(key: key);

  _BallLauncherState createState() => _BallLauncherState();
}

class _BallLauncherState extends State<BallLauncher> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  Animation<double> _animation;
  double compassWidth = 0.0;
  String splash = "";
  bool finLanzamiento = false;

	DateTime dt1 =DateTime.now(), dt2 = DateTime.now();
	double ultX = 0, ultY = 0, ultZ = 0, ultSuma = 0;
	bool capturando = false;
  double dis;



		double distancia(double aceleracion, Duration t){	
			double vVertical = 0;
			double vHorizontal = 0;
			if (t.inMilliseconds > 1000) {
				vVertical = aceleracion; //calculo velocidad vertical
				vHorizontal = aceleracion; //calculo velocidad horizontal
			}
			else {
				vVertical = aceleracion * (t.inMilliseconds/1000); //calculo velocidad vertical
				vHorizontal = aceleracion * (t.inMilliseconds/1000); //calculo velocidad horizontal
			}
			
		double tVuelo = (2 * vVertical * 0.8509) / 9.8; //calculo tiempo de vuelo, utilizando seno de 45 grados
		return vHorizontal * tVuelo;//+ 0.5 * aceleracion * tVuelo * tVuelo; //formula de movimiento x(t) para calcular distancia pelota
	}

	double fuerzaDelTiro(double dist, double maxRadioCampo) {
		return ((dist * maxRadioCampo/ distancia(130, Duration(milliseconds: 1000))) / maxRadioCampo);
	}

  Future<void> notificarHttp() async{
    setState(() {
      splash = dis.toString();
    });
    Random rnd = new Random();
    double r = rnd.nextDouble();
    await http.get('https://us-central1-ucode2019-3ef7f.cloudfunctions.net/splasshh?idgame=partida1&calidad=' + r.toString() 
    + '&iduser=jugador1&lat='
    + widget.currentPosition.lat.toString() +'&long=' + widget.currentPosition.lng.toString() +'&campo=20');
   /* setState(() {
      splash = "";
    });*/
  }
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _animation = Tween<double>(begin: 0, end: 0.80).animate(_animationController)..addListener(() async{
      if(_animation.status ==AnimationStatus.completed || (_animation.status == AnimationStatus.forward && finLanzamiento)){
          _animationController.stop();
          capturando = false;
          finLanzamiento = false;
          dt2 = DateTime.now();
          dis =  fuerzaDelTiro(distancia(sqrt(ultSuma), Duration(milliseconds: 1000)), 20);        
         await notificarHttp();
        _animationController.reset();
      }else{
        setState(() {
          compassWidth = widget.width*_animation.value;
        });
      }
    });
		accelerometerEvents.listen((AccelerometerEvent event) {
			 if(capturando){
				ultX = event.x * event.x;
				ultZ = (event.z - 9.8) * (event.z - 9.8);
				ultY = event.y * event.y;
				ultSuma = ultX + ultY + ultZ;
			 }
		});	

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Opacity(
          opacity: 0.5,
          child: Container(
            width: compassWidth,
            height: compassWidth,
            decoration: new BoxDecoration(
              color: Colors.green[700],
              shape: BoxShape.circle,
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            width: widget.width,
            height: widget.width,
            color: Colors.transparent,
          ),
          onTapUp: (state){
            finLanzamiento = true;
          },
          onTapDown: (state){
            _animationController.forward();
              capturando = true;
							dt1 = DateTime.now();
              //Cacelar Timer t de ball_finder
          },
        ),
        Text(splash.toString(), style: TextStyle(color: Colors.white))
      ],
    );
  }
  @override
  void dispose(){
    _animationController.dispose();
    super.dispose();
  }    
}