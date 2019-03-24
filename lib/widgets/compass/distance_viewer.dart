import 'package:flutter/material.dart';

class DistanceViewer extends StatelessWidget {
  final double distance;

  DistanceViewer({Key key, this.distance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String output = "";
    if(distance >= 1000 && distance <= 20000){
      output = (distance/1000).toStringAsFixed(2) + " km";
    }else if(distance < 1000){
      output = distance.toStringAsFixed(2) + " m";
    }else{
      output = (distance/1000).toStringAsFixed(0) + " km";
    }
    
    return Container(
      child: Text(
        output,
        style: TextStyle(
          fontSize: 50.0,
          fontWeight: FontWeight.w300,
          color: Colors.white
        ) ,
      ),
    );
  }
}