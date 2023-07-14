import 'package:dice/constants/routes.dart';
import 'package:dice/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xffFFFFFF),
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Center(
                            child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage: AssetImage(
                                    'images/medilogo2.png')
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, left: 40.0),
                          child: Text(
                            'Welcome back to',
                            style: TextStyle(
                              color: Color(0xff008080),
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Text(
                            'Medibot Consult',
                            style: TextStyle(
                              color:Color(0xff008080),
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xff008080),
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height:20),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                controller: _email,
                                enableSuggestions: false,
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.teal),
                                  filled: true,
                                  fillColor: Colors.teal.withOpacity(0.5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 20.0),
                              TextField(
                                controller: _password,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.teal),
                                  filled: true,
                                  fillColor: Colors.teal.withOpacity(0.5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 40.0),
                              ElevatedButton(
                                onPressed: () async {
                                  final email = _email.text;
                                  final password = _password.text;
                                  try{
                                 await FirebaseAuth.instance.signInWithEmailAndPassword(
                                      email: email,
                                      password: password,
                                    );
                                   Navigator.of(context).pushNamedAndRemoveUntil(
                                     mainAppRoute,
                                         (route) => false,
                                   );
                                  } on FirebaseAuthException catch(e){
                                   if(e.code == 'user-not-found'){
                                     print('User Not Found');
                                   }else if(e.code =='wrong-password'){
                                     print('Wrong Password');
                                   }
                                 }
                                },
                                child: Text('Login'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Colors.teal,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text(
                                    'Dont have an account?',
                                    style: TextStyle(
                                      color:Color(0xff008080),
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  SizedBox(width: 10),
                                  ElevatedButton(onPressed: () {
                                     Navigator.of(context).pushNamedAndRemoveUntil(
                                         signupRoute,
                                             (route) => false
                                     );
                                  },
                                      child: Text('Sign Up'),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0),
                                          )
                                      )
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],

                    ),
                  ),
                );
              default:
                return const Text('Loading..');
            }
          }

      ),
    );
  }
}