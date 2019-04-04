import 'package:flutter/material.dart';

class CompassBasePainter extends StatelessWidget {
  final double width;
  static const GROSOR_BRUJULA = 0.1;
  CompassBasePainter({Key key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: width,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: width*(1-GROSOR_BRUJULA),
          height: width*(1-GROSOR_BRUJULA),
          decoration: new BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        )        
      ],
    );
  }
}