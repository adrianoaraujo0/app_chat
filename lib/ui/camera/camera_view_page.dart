import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chat/ui/camera/camera_view_controller.dart';
import 'package:chat/ui/camera/list_images_page.dart';
import 'package:chat/ui/tela_chat/tela_chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CameraViewPage extends StatefulWidget {
  final cameras;
  final CameraController controller;
  final User usuario;

  const CameraViewPage(this.cameras, this.controller, this.usuario,{super.key,});

  @override
  State<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  TelaChatController telaChatController = TelaChatController();
  CameraViewController cameraViewController = CameraViewController();
  final List<String> pathList = [];
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<bool>(
        stream: telaChatController.controllerIsSendingFile.stream,
        builder: (context, snapshot) {
          return WillPopScope(
            onWillPop: ()async => snapshot.data != null && snapshot.data == true ? false
            : cameraViewController.showConfirmationDialogExitWithoutSaving(context, pathList.isNotEmpty),
            child:  Scaffold(
                  appBar: AppBar(
                    actions: [
                      pathList.isNotEmpty ? 
                      IconButton(onPressed: (() async {
                        for(String path in pathList){
                          await telaChatController.uploadImageFirebase(widget.usuario, path, context);
                         
                        }
                        pathList.clear();
                        telaChatController.controllerIsSendingFile.sink.add(false);
                      }), icon: const Icon(Icons.check))
                      : Container(),
                    ],
                  ),
                  body: Stack(
                    fit: StackFit.expand,
                    children: [
                       CameraPreview(widget.controller),
                        Positioned(
                          bottom: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    pathList.isNotEmpty ?
                                      previewImages()
                                      : const SizedBox(width: 70, height: 70),
                                      buttonTakePicture(snapshot),
                                      const SizedBox(width: 70, height: 70),
                                  ],
                                ),
                              ),
                            ),
                        ),
                    ],
                  ),
                )
              
           
          );
        }
      ),
    );
  }

  Widget previewImages(){
    return InkWell(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => ListImagePage(pathList: pathList, usuario: widget.usuario)));
        telaChatController.controllerIsSendingFile.sink.add(false);
      }, 
      child: Container(
        width: 70,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: FileImage(File(pathList.last)
            )
          )
        ),
      ),
    );
 }

 Widget buttonTakePicture(AsyncSnapshot snapshot){
  return Container(
    width: 70,
    height: 70,
    decoration: BoxDecoration(color: Colors.white ,borderRadius: BorderRadius.circular(100)),
    child: snapshot.data == null || snapshot.data == false ?
      IconButton(
        icon: const Icon(Icons.camera, color: Colors.grey, size: 50,),
        onPressed: () async {
          XFile file = await widget.controller.takePicture();
          pathList.add(file.path);
          telaChatController.controllerIsSendingFile.sink.add(false);
        },
      ) 
    : const Center(child: CircularProgressIndicator(strokeWidth: 5,))
    );
 }

}