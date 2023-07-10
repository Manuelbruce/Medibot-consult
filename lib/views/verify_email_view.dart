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
        body: Column(
            children: [
              Center(
                child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage(
                        'images/medilogo.png')
                ),
              ),
              SizedBox(height: 30,),
              const Text(
                'Please Verify Your email address',
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
                ),)
            ]
        ),
      ),
    );
  }
}
