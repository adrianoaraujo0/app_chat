import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CameraViewController{
  
    final BehaviorSubject<bool> controllerIsSendingFile = BehaviorSubject<bool>();


  bool showConfirmationDialogExitWithoutSaving(BuildContext context, bool condition){
    
  if(condition){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Deseja sair sem salvar as fotos"),
            actions: [
              TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('Cancelar')),
              TextButton(
                onPressed: (){Navigator.pop(context); Navigator.pop(context);}, 
                child: const Text('Sair')
              ),
            ],
           );
        },
    );
  return false;
  }
  return true;
  }

}