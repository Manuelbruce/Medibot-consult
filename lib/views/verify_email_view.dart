import 'package:dice/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
        backgroundColor: Color(0xff008080),
        appBar: AppBar(
          backgroundColor: Color(0xff008080),
          title: Text(
              'Verify email',
          ),
        ),
        body: Center(
          child: Column(
              children: [
                SizedBox(height:40),
                CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage(
                        'images/medilogo.png')
                ),
                 Text(
                   'Medibot Consult',
                   style:TextStyle(
                     fontSize:30,
                     fontWeight: FontWeight.bold,
                     color: Color(0xffFFFFFF),
                   ),
                 ),
                SizedBox(height: 30,),
                const Text(
                 "We've sent you an email for verification of your account. please open it to verify your account.If you haven't received verification email yet, please press the button below.",
                  style:TextStyle(
                    fontSize:20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffFFFFFF),
                  ),
                ),

                SizedBox(height: 20.0,),
                ElevatedButton(
                  onPressed: () async{
                    final user = FirebaseAuth.instance.currentUser;
                    await user?.sendEmailVerification();

                  },
                  child: Text(
                      'Send Email Verification',
                      style: TextStyle(
                          color:Color(0xff008080),
                          fontWeight: FontWeight.bold
                      )
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )
                  ),),
                SizedBox(height: 5,),
                ElevatedButton(
                  onPressed: () async{
                 await   FirebaseAuth.instance.signOut();
                 await
                 Navigator.of(context).pushNamedAndRemoveUntil(signupRoute, (route) => false);
                  },
                  child: Text(
                      'Restart',
                      style: TextStyle(
                          color:Color(0xff008080),
                          fontWeight: FontWeight.bold
                      )
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )
                  ),)
              ]
          ),
        ),
      ),
    );
  }
}
