import 'package:camera/camera.dart';
import 'package:chat/ui/camera/view_image.dart';
import 'package:chat/ui/tela_chat/tela_chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  final cameras;
  final CameraController controller;
  final User usuario;

  const CameraPage(this.cameras, this.controller, this.usuario,{super.key,});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  TelaChatController telaChatController = TelaChatController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Stack(
              children: [
                 CameraPreview(
                   widget.controller,    
                 ),
              ],
            ),
           const SizedBox(height: 0,),
           StreamBuilder<bool>(
             stream: telaChatController.controllerIsSendingFile.stream,
             builder: (context, snapshot) {
               return Container(
                  width: 0,
                  height: 0,
                  decoration: BoxDecoration(color: Colors.white ,borderRadius: BorderRadius.circular(100)),
                  child: snapshot.data == null || snapshot.data == false ?
                   IconButton(
                       icon: const Icon(Icons.camera, color: Colors.grey, size: 50,),
                        onPressed: () async {
                        XFile file = await widget.controller.takePicture();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImage(image: file.path, usuario: widget.usuario,)));
                        },
                   ) 
                 : const Center(child: CircularProgressIndicator(strokeWidth: 5,))
               );
             }
           ),
          ],
        ),
      ),
    );
  }
}