
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

checkgame("jugador1");


function checkgame(fiduser)
{

    _db.ref("dev/halls").once("value").then((snapshot1) => {
       // Hay hall
        if(snapshot1.val() != null)
        { 
            var u = snapshot1.val();
            snapshot1.forEach(function(item) {
                //console.log(item.key);
                var usr = item.val().users;
                usr.forEach(function(item2){
                   // console.log(item2);
                    if(fiduser != item2)
                    {
                        //console.log("A lanzar!");
                        createGame(item.key, item2, fiduser);
                        _db.ref("dev/halls/" + item.key).remove();
                    } 
                });
                //console.log(item.val());
            });
 
        }else{
            var hall = {
                users: [fiduser]
            }
            _db.ref("dev/halls").push(hall).then((snapshot) => {
            });
            
    }
});
}

function createGame(fkey, fuser1, fuser2)
{
    console.log("entra");
    var gameRef = _db.ref("dev/newgames/");
    let game =
    {
        state: "ready",
        [fuser1]: {
            loc: {
                0: 0.00,
                1: 0.00
            },
            points: 0
        },
        [fuser2]: {
            loc: {
                0: 0.00,
                1: 0.00
            },
            points: 0
        },
        ball:
        {
            player_active: fuser1,
            player_second: fuser2,
            loc: {
                0: 0.00,
                1: 0.00,
                distance: 0
            }
        }
    
    }
    gameRef.push(game);
}

