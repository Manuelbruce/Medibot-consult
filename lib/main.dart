import 'package:dice/firebase_options.dart';
import 'package:dice/views/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(
    MaterialApp(
      home:HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title:const Text('Medibot Consult'),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
               final user= FirebaseAuth.instance.currentUser;
               if(user?.emailVerified?? false){}else{}
                  return const Text('Done');
              default:
                return const Text('Loading..');
            }
          }

      ),
    );
  }
}

