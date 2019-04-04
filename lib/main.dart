import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ucode2019/login.dart';



Future<void> main() async{
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: const FirebaseOptions(
            googleAppID: '1:986513539597:android:a75590251199063b',
            apiKey: 'AIzaSyDVaUmLAbxzpwi26yoEN6BCvF2vnZwPFGw',
            databaseURL: 'https://ucode2019-3ef7f.firebaseio.com',
          ),
);  
  runApp(MyApp(app: app));
}

class MyApp extends StatefulWidget {
  final FirebaseApp app;
  MyApp({Key key, this.app}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);    
    return MaterialApp(
          theme: ThemeData(
            brightness: Brightness.dark,
            unselectedWidgetColor:Colors.white
          ),      
          home: Scaffold(
            body: Login(app: widget.app)
        )
      );
  }
}

