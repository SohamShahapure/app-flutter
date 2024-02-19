import 'package:flutter/material.dart';
import 'package:veritas/pages/signupdetails_client.dart';
import 'package:veritas/pages/splash.dart';
import 'package:veritas/pages/imlawyer.dart';
import 'package:veritas/pages/client/clientfeature.dart';
import 'package:veritas/pages/loginpage.dart';
import 'package:veritas/pages/client/clientdashboard.dart';
import 'package:veritas/pages/chatscreen.dart';

import "package:firebase_core/firebase_core.dart";
import 'package:veritas/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veritas/pages/registercase.dart';
import "package:veritas/pages/lawyer/lawyerfeat.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veritas/pages/lawyer/lawyerdashboard.dart';

// import 'package:veritas/pages/.dart'

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late final Future<String> _initialRoute;

  MyApp() {
    _initialRoute = _determineInitialRoute();
  }

  Future<String> _determineInitialRoute() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return '/first';
    } else {
      try {
        final snapshot = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
        if (snapshot.exists) {
          return '/cldashboard';
        } else {
          return '/lawyerdashboard';
        }
      } catch (error) {
        print("Error fetching user document: $error");
        return '/first'; // Handle error condition
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _initialRoute,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator or splash screen while determining initial route
          // return CircularProgressIndicator();
          return MaterialApp();
        } else {
          if (snapshot.hasError) {
            // Handle error if any
            return Text('Error: ${snapshot.error}');
          } else {
            return MaterialApp(
              initialRoute: snapshot.data ?? '/first', // Use initialRoute when available, otherwise fallback to '/first'
              routes: {
                "/": (context) => splash(),
                "/first": (context) => firstpg(),
                "/lawyerfeat": (context) => lawfeat(),
                "/clientfeature": (context) => clfeat(),
                "/loginclient": (context) => login(usertype: "client"),
                "/loginlawyer": (context) => login(usertype: "lawyer"),
                "/cldashboard": (context) => cldashboard(),
                "/lawyerdashboard": (context) => lawyerdashboard(),
                "/signupdetails": (context) => signInDetails(),
                "/reg": (context) => regcase(),
                "/chat": (context) => chatsection()
              },
            );
          }
        }
      },
    );
  }
}
