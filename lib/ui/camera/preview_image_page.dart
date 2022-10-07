import 'dart:io';

import 'package:chat/ui/camera/list_image_controller.dart';
import 'package:flutter/material.dart';

class PreviewImage extends StatelessWidget {
  String image;
  int index;
  List<String> pathList;

  PreviewImage({required this.pathList ,required this.image, required this.index});
  ListImageController listImageController = ListImageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(image)),
          Positioned(
            bottom: -5,
            left: 180,
            child: IconButton(
            onPressed: () { 
              pathList.removeAt(index);
              ListImageController.updateGridView.sink.add(true); 
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
              ),
          ),
        ],
      ),
    );
  }
}