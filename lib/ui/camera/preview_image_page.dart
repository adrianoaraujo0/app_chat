import 'dart:io';

import 'package:chat/ui/camera/list_images_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PreviewImage extends StatelessWidget {
  String image;

  PreviewImage({required this.image});

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
            onPressed: () { },
            icon: Icon(Icons.delete),
              ),
          ),
        ],
      ),
    );
  }
}