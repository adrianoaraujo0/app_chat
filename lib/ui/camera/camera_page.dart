import 'package:camera/camera.dart';
import 'package:chat/ui/tela_chat/tela_chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  final cameras;
  final CameraController controller;
  final User usuario;

  const MyWidget(this.cameras, this.controller, this.usuario,{super.key,});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  TelaChatController telaChatController = TelaChatController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraPreview(
        widget.controller,    
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
         XFile file = await widget.controller.takePicture();
         print(file.path);
        telaChatController.uploadImageFirebase(widget.usuario, file.path);
        },
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, 
    );
  }
}