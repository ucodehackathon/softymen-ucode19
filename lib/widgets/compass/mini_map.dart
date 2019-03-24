import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart' as fmll;
import 'package:geo/geo.dart';

class MiniMap extends StatelessWidget {

  final double width;
  final LatLng currentPosition;
  final double fieldSize;
  final double zoom;
  MiniMap({Key key, this.width, this.currentPosition, this.fieldSize, this.zoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width*0.75,
      height: width*0.75,
      child: ClipOval(
        child: FlutterMap(
          options: MapOptions(
            center: fmll.LatLng(currentPosition.lat, currentPosition.lng),
            zoom: zoom
          ),
          layers: [
            TileLayerOptions(
              urlTemplate:"https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
              CircleLayerOptions(
                circles: [
                  CircleMarker(
                    point: fmll.LatLng(currentPosition.lat, currentPosition.lng),
                    color: Colors.black.withOpacity(0.7),
                    useRadiusInMeter: true,
                    radius: fieldSize
                  )
                ]
              )
          ]
        ),
      ),
    );
  }
}
