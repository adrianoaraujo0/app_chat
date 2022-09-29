import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/subjects.dart';

class TelaChatController {
  final TextEditingController textoControllerEnviarMensagem = TextEditingController();
  final BehaviorSubject<bool> controllerMudarCorSinalEnviarMensagem = BehaviorSubject<bool>();
  ScrollController scrollListController = ScrollController();
  bool carregandoImagem = false;
  User? user;
  String? imagemPath;
  File? file;
  

  ultimaMensagem() async{
    WidgetsBinding.instance.addPostFrameCallback((_){
     scrollListController.jumpTo(scrollListController.position.maxScrollExtent);
    });
  }

  void salvarMensagemFirebase(User usuario) async{
    FirebaseFirestore.instance.collection("chat").add({
    "usuario": usuario.email,
    "texto": textoControllerEnviarMensagem.text,
    "imagem": imagemPath,
    "time": Timestamp.now(),
    });

    textoControllerEnviarMensagem.clear();
    imagemPath = null;
    controllerMudarCorSinalEnviarMensagem.sink.add(false);
  }

   capturarImagem(User usuario) async {
    final XFile? imgfile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (imgfile == null) return;

    imagemPath = imgfile.path;
    
     if (imagemPath != null) {
      //uploadtask: Uma classe que indica uma tarefa de upload em andamento.
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(File(imagemPath!));

      //Um [TaskSnapshot] é retornado como resultado ou processo em andamento de um [Task].
      // TaskSnapshot taskSnapshot = await task;
      // String url = await taskSnapshot.ref.getDownloadURL();
    }

     FirebaseFirestore.instance.collection("chat").add({
      "usuario": usuario.email,
      "texto": textoControllerEnviarMensagem.text,
      "imagem": imagemPath,
      "time": Timestamp.now(),
     });
  }

  void capturarArquivo() async{

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'pdf', 'doc']);

    if (result != null) {
      File path = File(result.files.single.path!);
    
    } else {
      // User canceled the picker
    }

  }


}

