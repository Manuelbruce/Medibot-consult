import 'package:dice/firebase_options.dart';
import 'package:dice/views/login_view.dart';
import 'package:dice/views/register_view.dart';
import 'package:dice/views/verify_email_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'constants/routes.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(
    MaterialApp(
      home:HomePage(),
      routes: {

        loginRoute:(context) => LoginView(),
        signupRoute :(context)=>  SignInView(),
        mainAppRoute:(context) => MainAppView(),
        verifyEmailRoute:(context) => VerifyEmailView(),
    },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
               final user= FirebaseAuth.instance.currentUser;
                if(user !=null){
                   if(user.emailVerified){
                     print('Email is Verified');
                   }else{
                     return const VerifyEmailView();
                   }
               }else{
                return LoginView();
                }
                return const MainAppView();
                default:
                return const CircularProgressIndicator();
            }
          }

      );

  }
}

enum MenuAction{ logout}

class MainAppView extends StatefulWidget {
  const MainAppView({super.key});

  @override
  State<MainAppView> createState() => _MainAppViewState();
}

class _MainAppViewState extends State<MainAppView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Color(0xffFFFFFF),
    appBar: AppBar(
    backgroundColor: Colors.teal,
    title:const Text('Medibot Consult'),
      actions: [
        PopupMenuButton<MenuAction>(
          onSelected: (value) async{
            switch(value){
              case MenuAction.logout:
               final shouldLogout = await showLogOutDialog(context);
              if(shouldLogout){
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                        (route) => false,
                );
              }
            }
          },
            itemBuilder: (context){
            return[
              const PopupMenuItem<MenuAction>(
                value:MenuAction.logout,
                child:Text('Log out')
              ),
            ];
            }
        )
      ],
    ),
    body: Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              // Display previous chat messages
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                     // userSymptoms = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your symptoms...',
                    filled: true,
                    fillColor: Colors.teal.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4,),
              ElevatedButton(
                onPressed: () {
                 // fetchDiagnosis();
                },
                child:Icon(Icons.send) //Text('Enter')
                ,style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Color(0xff008080),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    );

  }
}
 Future<bool>showLogOutDialog(BuildContext context){
  return showDialog<bool>(
      context: context,
      builder:(context) {
        return AlertDialog(
          title: const Text(
            'Sign out',
            style:TextStyle(
              color: Color(0xff008080),
            ),
          ),
          content:  Text(
              'Are you sure you want to Log out ?',
            style: TextStyle(
              color: Color(0xff008080),
            ),
          ),
          actions:[
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                    'Cancel',
                  style:TextStyle(
                    color:Color(0xff008080),
                  ),
                ),

            ),
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                    'Log out',
                    style:TextStyle(
                      color:Color(0xff008080),
                    ),

                ),

            )
          ]
        );
      },
  ).then((value) => value ?? false);
 }