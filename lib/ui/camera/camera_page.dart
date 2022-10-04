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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                 CameraPreview(
                   widget.controller,    
                 ),
              ],
            ),
           const SizedBox(height: 30,),
           Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(color: Colors.white ,borderRadius: BorderRadius.circular(100)),
              child:  IconButton(
                   icon: const Icon(Icons.camera, color: Colors.grey, size: 50,),
                    onPressed: ()async {
                    XFile file = await widget.controller.takePicture();
                    print(file.path);
                    telaChatController.uploadImageFirebase(widget.usuario, file.path);
                },
             ),
           ),
          ],
        ),
      ),
    );
  }
}