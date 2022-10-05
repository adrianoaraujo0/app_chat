import 'dart:io';

import 'package:chat/ui/tela_chat/tela_chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewImage extends StatelessWidget {
  String image;
  final User usuario;

  ViewImage({required this.image, required this.usuario});
  TelaChatController telaChatController = TelaChatController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            child: Image.file(File(image)
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(100)
                  ),
                  child: IconButton(onPressed: (() {
                    Navigator.pop(context);
                  }), icon: const Icon(Icons.close))
                ),
                 Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(100)
                  ),
                  child: IconButton(onPressed: (() {
                    telaChatController.uploadImageFirebase(usuario, image, context);
                    Navigator.pop(context);
                  }), icon: const Icon(Icons.check))
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}