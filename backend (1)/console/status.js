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

_db.ref("dev/games").once("value").then((snapshot1) => {
    // Hay games

    var points_a = 0;
    var points_i = 0;
    var points_win = 5;

     if(snapshot1.val() != null)
     { 
            // Check points 
            console.log(snapshot1.val());
            snapshot1.forEach(function(item) {
                console.log(item.key);
                var pa = item.val().ball.player_active
                var pi = item.val().ball.player_second
                console.log(pa);

                points_a = item.val()[pa].points;
                points_i = item.val()[pi].points;
                
                console.log(points_a);
                console.log(points_i);

                if(points_a >= points_win) 
                if(points_b >= points_win)
            });
        }else{

     }
});

switch(argv['state'])
{
    case 'finish':
        break;
    default: 
        break;
}

function 