const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();

// Take the text parameter passed to this HTTP endpoint and insert it into the
// Realtime Database under the path /messages/:pushId/original
/*
exports.addMessage = functions.https.onRequest((req, res) => {
    // Grab the text parameter.
    const original = req.query.text;
    // Push the new message into the Realtime Database using the Firebase Admin SDK.
    return admin.database().ref('/messages').push({original: original}).then((snapshot) => {
      // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
      return res.redirect(303, snapshot.ref.toString());
    });
  });

  // Listens for new messages added to /messages/:pushId/original and creates an
// uppercase version of the message to /messages/:pushId/uppercase
exports.makeUppercase = functions.database.ref('/messages/{pushId}/original')
.onCreate((snapshot, context) => {
  // Grab the current value of what was written to the Realtime Database.
  const original = snapshot.val();
  console.log('Uppercasing', context.params.pushId, original);
  const uppercase = original.toUpperCase();
  // You must return a Promise when performing asynchronous tasks inside a Functions such as
  // writing to the Firebase Realtime Database.
  // Setting an "uppercase" sibling in the Realtime Database returns a Promise.
  return snapshot.ref.parent.child('uppercase').set(uppercase);
});

exports.status = functions.https.onRequest((req, res) => {
    // Grab the text parameter.
    let env = req.query.env;
    const idgame = req.query.idgame;
    const iduser = req.query.iduser;
    
    
    if(env == null)
    {
        env = "dev";
    }else{
        env = "master";
    } 
     
    // Push the new message into the Realtime Database using the Firebase Admin SDK.
    return admin.database().ref(env + "/games/" + idgame).child('state').set('change').then((snapshot) => {
      // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
      return res.redirect(303, snapshot.ref.toString());
    });
  });
*/

exports.getUser = functions.https.onRequest((req, res) => {
    // Grab the text parameter.
    let env = req.query.env;

    
    if(env == null)
    {
        env = "dev";
    }else{
        env = "master";
    } 

    const idgame = req.query.idgame;
    const iduser = req.query.iduser;
    
    admin.database().ref(env + "/games/" + idgame + "/ball/player_active").once("value").then((snapshot) => {
        var p1 = snapshot.val();
        admin.database().ref(env + "/games/" + idgame + "/ball/player_second").once("value").then((snapshot2) => {
            var p2 = snapshot2.val();
            admin.database().ref(env + "/games/" + idgame  + "/ball/player_active").set(p2).then((snapshot3) => {
            });
            admin.database().ref(env + "/games/" + idgame +  "/ball/player_second").set(p1).then((snapshot4) => {
            });
            return admin.database().ref(env + "/games/" + idgame + "/" + iduser + "/points").once("value").then((snapshot5) => {
                var point = snapshot5.val();
                point++;
                admin.database().ref(env + "/games/" + idgame + "/" + iduser + "/points").set(point).then((snapshot6) => {
                });
                return res.status(200).send('okis');
              });
        });
    });

    
    });
  


  exports.splasshh = functions.https.onRequest((req, res) => {
    // Grab the text parameter.
    let env = req.query.env;
    
    if(env == null)
    {
        env = "dev";
    }else{
        env = "master";
    } 

    const idgame = req.query.idgame;
    const iduser = req.query.iduser;
    const calidad = req.query.calidad;
    const campo = req.query.campo;
    var lat = Number(req.query.lat);
    var long = Number(req.query.long);

    admin.database().ref(env + "/games/" + idgame + "/ball").child('plassshh').set(calidad).then((snapshot) => {
    });
    admin.database().ref(env + "/games/" + idgame + "/ball").child('time_expire').set(11111).then((snapshot) => {
    });

    /*
    admin.database().ref(env + "/games/" + idgame + "/ball/loc2/0").set(1).then((snapshot) => {
    });
    

    admin.database().ref(env + "/games/" + idgame + "/" + iduser + "/loc2/0").once('value').then((snapshot) => {
        lat = snapshot.val();
        admin.database().ref(env + "/games/" + idgame + "/ball/loc3/0").set(lat).then((snapshot) => {
        });
    });
*/
    /*
    admin.database().ref(env + "/games/" + idgame + "/ball/loc/0").once('value').then(function(snapshot) {
        lat = snapshot.val() || '-1';
  
    admin.database().ref(env + "/games/" + idgame + "/" + iduser + "/loc2/1").once('value').then((snapshot) => {
        long = snapshot.val();
    });

    lat = lat + 1000;

  */  
    if(campo === 0) campo = 200; 
    

    var state2 = getState(lat, long, campo);
    
    /*
    admin.database().ref(env + "/games/" + idgame + "/ball/loc2").child('0').set(1).then((snapshot) => {
    });
    admin.database().ref(env + "/games/" + idgame + "/ball/loc2").child('1').set(2).then((snapshot) => {
    });
    admin.database().ref(env + "/games/" + idgame + "/ball/loc2").child('distance').set(state.distance2).then((snapshot) => {
    });
    */

   admin.database().ref(env + "/games/" + idgame + "/ball/loc/0").set(Number(state2.latitude)).then((snapshot) => {
   });
   admin.database().ref(env + "/games/" + idgame + "/ball/loc/1").set(Number(state2.longitude2)).then((snapshot) => {
   });
   admin.database().ref(env + "/games/" + idgame + "/ball/loc/distance2").set(Number(state2.distance2)).then((snapshot) => {
    });

    return admin.database().ref(env + "/games/" + idgame + '/state').set("running").then((snapshot) => {
      // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
      //return res.redirect(303, snapshot.ref.toString());
      return res.status(200).send('okis');
    });
  });

  function getState(flat, flong, fcampo)
  {
    return randomGeo({latitude: flat, longitude: flong}, fcampo);
  }



//Create random lat/long coordinates in a specified radius around a center point
function randomGeo(center, radius) {
    var y0 = center.latitude;
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


