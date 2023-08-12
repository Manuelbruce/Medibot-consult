import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
 enum ChatMessageType{user,bot}












class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.sender});

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(sender).
         text.
         subtitle1(context)
             .make()
             .box
             .color(sender=='user'?Vx. teal400 : Vx.teal800 )
         .p16
         .rounded
             .alignCenter.makeCentered(),
          Expanded(
              child: text.trim().text.bodyText1(context).make().px8()
          )
        ],
      ),
    );
  }
}
