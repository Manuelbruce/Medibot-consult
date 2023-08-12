import 'dart:async';

import 'package:dialog_flowtter/dialog_flowtter.dart';

import 'package:dice/firebase_options.dart';
import 'package:dice/threedots.dat.dart';
import 'package:dice/utilities/chat_message.dart';
import 'package:dice/views/login_view.dart';
import 'package:dice/views/register_view.dart';
import 'package:dice/views/verify_email_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;







import 'constants/routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
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
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  print('Email is Verified');
                } else {
                  return const VerifyEmailView();
                }
              } else {
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
class  _MainAppViewState extends State<MainAppView> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  //List<Map<String, dynamic>> messages = [];
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    // DialogAuthCredentials credentials = await DialogAuthCredentials.fromFile(path);
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }


bool _isTyping = false;




void _sendMessage() async{
  if(_controller.text.isEmpty) return;
  ChatMessage _message = ChatMessage(text: _controller.text, sender: "user");

  setState((){
    _messages.insert(0,_message);
    _isTyping= true;
  });

_controller.clear();

  DetectIntentResponse response = await dialogFlowtter.detectIntent(
         queryInput: QueryInput(text: TextInput(text:_message.text)));


  ChatMessage _botMessage = ChatMessage(text: response.text?? '', sender: "Medibot");
  setState(() {
    _messages.insert(0, _botMessage);
    _isTyping = false;
  });


}

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Medibot Consult'),
        actions: [
          PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(
                        context);
                    if (shouldLogout) {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                            (route) => false,
                      );
                    }
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<MenuAction>(
                      value: MenuAction.logout,
                      child: Text('Log out')
                  ),
                ];
              }
          )
        ],
      ),
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];

              },
            ),



          ),
          if(_isTyping) const ThreeDots(),
          Divider(height:1.0),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(

                    controller: _controller,

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
                    if(_controller.text.isEmpty){
                      print('Empty Message');
                    }else{
                      setState(() {
                        _sendMessage();
                      });
                    }

                  },
                  child: Icon(Icons.send)
                  , style: ElevatedButton.styleFrom(
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


  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text(
              'Sign out',
              style: TextStyle(
                color: Color(0xff008080),
              ),
            ),
            content: Text(
              'Are you sure you want to Log out ?',
              style: TextStyle(
                color: Color(0xff008080),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xff008080),
                  ),
                ),

              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  'Log out',
                  style: TextStyle(
                    color: Color(0xff008080),
                  ),

                ),

              )
            ]
        );
      },
    ).then((value) => value ?? false);
  }
}

