import 'dart:io';

import 'package:chat/ui/camera/list_image_controller.dart';
import 'package:chat/ui/camera/preview_image_page.dart';
import 'package:chat/ui/tela_chat/tela_chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListImagePage extends StatelessWidget {
  List<String> pathList;
  final User usuario;
  

  ListImagePage({required this.pathList, required this.usuario});
  ListImageController listImageController = ListImageController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ListImageController.updateGridView.stream,
      builder: (context, snapshot) { 
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Expanded(
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,),
                    itemCount: pathList.length,
                    itemBuilder: (context, index) { 
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: ()async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewImage(pathList: pathList ,image: pathList[index], index: index,)));
                            if(pathList.isEmpty){
                              Navigator.pop(context);
                            }   
                          },
                          child: Container( 
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(image: FileImage(File(pathList[index])),
                              fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                )
            ],
          ),
        );
      }
    );
  }
}