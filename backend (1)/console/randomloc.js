
var d = Date.now();
console.log(d);
console.log(new Date(d));

var _calidad = 1;
var _seg = 5;
var _seg_min = 1;

function getTimeBall()
{
    var d = Date.now();

    var seg = Number(_seg - _seg * _calidad);
    if(seg < _seg_min) seg = _seg_min;
    let add = d + Number(seg)*1000
    var obj = {
        plash: d,
        plash_add: add,
        seconds: Number(seg.toFixed(2))
    }
    return(obj);
}
console.log(getTimeBall())
process.exit();


console.log(randomGeo({latitude: "41.6854", longitude: -0.886969}, 20))

//Create random lat/long coordinates in a specified radius around a center point
function randomGeo(center, radius) {
    var y0 = Number(center.latitude);
    var x0 = center.longitude;
    var rd = radius / 111300; //about 111300 meters in one degree

    var u = Math.random();
    var v = Math.random();

    var w = rd * Math.sqrt(u);
    var t = 2 * Math.PI * v;
    var x = w * Math.cos(t);
    var y = w * Math.sin(t);

    //Adjust the x-coordinate for the shrinking of the east-west distances
    var xp = x / Math.cos(y0);

    var newlat = y + y0;
    var newlon = x + x0;
    var newlon2 = xp + x0;

    return {
        'latitude': newlat.toFixed(5),
        'longitude': newlon.toFixed(5),
        'longitude2': newlon2.toFixed(5),
        'distance': distance(center.latitude, center.longitude, newlat, newlon).toFixed(2),
        'distance2': distance(center.latitude, center.longitude, newlat, newlon2).toFixed(2),
    };
}

//Calc the distance between 2 coordinates as the crow flies
function distance(lat1, lon1, lat2, lon2) {
    var R = 6371000;
    var a = 0.5 - Math.cos((lat2 - lat1) * Math.PI / 180) / 2 + Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * (1 - Math.cos((lon2 - lon1) * Math.PI / 180)) / 2;
    return R * 2 * Math.asin(Math.sqrt(a));
}