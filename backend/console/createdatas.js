var firebase = require("firebase-admin");
var argv = require('minimist')(process.argv.slice(2));
//console.dir(argv);


// variables
var _branch = 'dev';
var _db = null;
var _serviceAccount = null;


// Init firebase
_serviceAccount = require('../../keys//ucode2019-firebase.json');
firebase.initializeApp({
  credential: firebase.credential.cert(_serviceAccount),
  databaseURL: "https://ucode2019-3ef7f.firebaseio.com/"
});
_db = firebase.database();



// Init program

// is dev?

if( argv['branch'] == null)
{
        _branch = 'dev'
    }else{
        _branch = "master";
    }

createUsers();
createGame();





function createUsers()
{
    var usersRef = _db.ref(_branch + "/users");
    usersRef.set({
        jugador1: {
        name: "jugador 1",
        country: "Spain",
        photo: "https://randomuser.me/api/portraits/men/38.jpg",
        location: {
            0: 41.631,
            1: -0.885
        },
        skill: 10
    },
        jugador2: {
        name: "jugador 3",
        country: "China",
        photo: "https://randomuser.me/api/portraits/men/30.jpg",
        location: {
            0: 35.561,
            1: 102.863
        },
        skill: 15
    },
        jugador3: {
        name: "jugador 3",
        country: "France",
        photo: "https://randomuser.me/api/portraits/men/22.jpg",
        location: {
            0: 47.075,
            1: 3.265
        },
        skill: 6
    }

    });
/*
var oUser = {
    name: "jugador 4",
    country: "Spain",
    photo: "https://randomuser.me/api/portraits/men/21.jpg",
    location: {
        0: 41.631,
        1: -0.885
    },
    skill: 4
}   

return new Promise(function(resolve, reject) {
    // Do async job
    usersRef.push(oUser);
    resolve(true);
    //reject(false);
})
*/
}

function createGame(_id)
{
    var gameRef = _db.ref(_branch + "/games");
    let game =
    {
        state: "ready",
        jugador1: {
            loc: {
                0: 41.631,
                1: -0.885
            },
            points: 2
        },
        jugador2: {
            loc: {
                0: 20.631,
                1: 10.885
            },
            points: 3
        },
        ball:
        {
            player_active: "jugador1",
            player_second: "jugador2",
            loc: {
                0: 20.631,
                1: 10.885,
                distance: 1
            },
            time_expire: 99999999,
            plassshh : 0.8 
        }
    
    }
    gameRef.push(game);
}

