import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chat/ui/camera/view_image.dart';
import 'package:chat/ui/tela_chat/tela_chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';


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
  List<String> pathList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (() {}), icon: Icon(Icons.abc))
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
             CameraPreview(
               widget.controller,    
             ),
              Positioned(
                bottom: 0,
                child: StreamBuilder<bool>(
                stream: telaChatController.controllerIsSendingFile.stream,
                builder: (context, snapshot) {
           return SizedBox(
            width: MediaQuery.of(context).size.width,
             child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                pathList.isNotEmpty ?
                  Container(
                    width: 70,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: FileImage(File(pathList.last)
                        )
                      )
                    ),
                  )
                  : const SizedBox(width: 70, height: 70),
                 Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(color: Colors.white ,borderRadius: BorderRadius.circular(100)),
                      child: snapshot.data == null || snapshot.data == false ?
                       IconButton(
                           icon: const Icon(Icons.camera, color: Colors.grey, size: 50,),
                            onPressed: () async {
                            XFile file = await widget.controller.takePicture();
                            pathList.add(file.path);
                            print(pathList.where((element) => element.isNotEmpty));
                            telaChatController.controllerIsSendingFile.add(false);
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImage(image: file.path, usuario: widget.usuario,)));
                            },
                       ) 
                      : const Center(child: CircularProgressIndicator(strokeWidth: 5,))
                  ),
                  const SizedBox(width: 70, height: 70),
               ],
             ),
           );
         }
      ),
              ),
          ],
        ),
      ),
    );
  }
}