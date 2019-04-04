var firebase = require("firebase-admin");
var argv = require('minimist')(process.argv.slice(2));



// variables
var _env = 'dev';
var _db = null;
var _serviceAccount = null;


// Init firebase
_serviceAccount = require('../../keys/ucode2019-firebase.json');
firebase.initializeApp({
  credential: firebase.credential.cert(_serviceAccount),
  databaseURL: "https://ucode2019-3ef7f.firebaseio.com/"
});
_db = firebase.database();

_db.ref("dev/games/partida1/ball/time_expire/seconds_remain").once("value").then((snapshot1) => {
    if(snapshot1.val() > 0)
    { 
        var t = snapshot1.val() - 0.01;
        _db.ref("dev/games/partida1/ball/time_expire/seconds_remain").set(Number(t)).then((snapshot1) => {
        });
    }
});
