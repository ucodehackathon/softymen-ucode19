import 'package:flutter/material.dart';

class TargetReached extends StatelessWidget {
  final double width;
  TargetReached({Key key, this.width}) : super(key: key);
  
  static const GROSOR_MARCADOR = 0.05;
  static const GROSOR_BRUJULA = 0.1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: width*(1-GROSOR_BRUJULA)*0.95,
          height: width*(1-GROSOR_BRUJULA)*0.95,
          decoration: new BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: width*(1-GROSOR_BRUJULA)*0.90,
          height: width*(1-GROSOR_BRUJULA)*0.90,
          decoration: new BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        )        
      ],
    );
  }
}