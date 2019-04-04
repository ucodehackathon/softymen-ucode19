import 'package:flutter/material.dart';
import 'package:geo/geo.dart';
import 'package:ucode2019/widgets/compass/compass_base.dart';
import 'package:ucode2019/widgets/compass/ball_compass.dart';
import 'package:ucode2019/widgets/compass/target_reached.dart';
import 'package:ucode2019/widgets/compass/launcher.dart';
import 'package:ucode2019/widgets/compass/mini_map.dart';

class Compass extends StatelessWidget {
  final LatLng currentPosition;
  final bool esMiTurno;
  final bool ballReached;
  final double distance;
  final double height;
  final double width;
  final double angleToBall;

  Compass({Key key, this.height, this.width, this.ballReached,
  this.angleToBall, this.distance, this.currentPosition, this.esMiTurno}) : super(key: key);

  @override
  Widget build(BuildContext context){   
    Size size = Size(width, height);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CompassBasePainter(width: width),
        CustomPaint(
          size: size,
          painter: BallCompassPainter(angleToBall),
        ),
        (distance < 3.0
        ? TargetReached(width: width)
        : Container()),
        MiniMap(width: width, currentPosition: currentPosition, fieldSize: 17.0, zoom: 15.0),
        (esMiTurno
        ? BallLauncher(width: width, currentPosition: currentPosition)
        : Container())
      ],
    );
  }
}