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
  final BehaviorSubject<bool> controllerLinearProgress = BehaviorSubject<bool>();
  
  ScrollController scrollListController = ScrollController();

  User? user;
  String? imagemPath;
  File? file;
  PlatformFile? pickedFile;
  
 
  


  ultimaMensagem() async{
    WidgetsBinding.instance.addPostFrameCallback((_){
     scrollListController.jumpTo(scrollListController.position.maxScrollExtent);
    });
  }

  void limparCampoMensagem(){
    textoControllerEnviarMensagem.clear();
    imagemPath = null;
  }

  void salvarTextoFirebase(User usuario) async{
    FirebaseFirestore.instance.collection("chat").add({
      "usuario": usuario.email,
      "texto": textoControllerEnviarMensagem.text,
      "imagem": null,
      "arquivo": null,
      "time": Timestamp.now(),
      });
      
    limparCampoMensagem();

    controllerMudarCorSinalEnviarMensagem.sink.add(false);
  }


   capturarImagem(BuildContext context ,User usuario) async {
    Navigator.pop(context);
    
    //capturar imagem
    final XFile? imgfile = await ImagePicker().pickImage(source: ImageSource.camera);
    
    if (imgfile == null) return;
    
    controllerLinearProgress.sink.add(false);
    //salvar no storage
    UploadTask uploadImage = FirebaseStorage.instance.ref().child(
    DateTime.now().millisecondsSinceEpoch.toString()
    ).putFile(File(imgfile.path));
     
  
     final TaskSnapshot taskSnapshot = await uploadImage.whenComplete(() => {
      controllerLinearProgress.sink.add(true),
      print("UPLOAD DO ARQUIVO COMPLETO")
     });

      final urlImageDownload = await taskSnapshot.ref.getDownloadURL();
      print("Download Link: $urlImageDownload");

      FirebaseFirestore.instance.collection("chat").add({
      "usuario": usuario.email,
      "texto": textoControllerEnviarMensagem.text,
      "imagem": urlImageDownload,
      "arquivo": null,
      "time": Timestamp.now(),
      });
      limparCampoMensagem();
  }



  void selecionarArquivo(BuildContext context ,User usuario) async{
    Navigator.pop(context);

    UploadTask? uploadTask;
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'pdf', 'doc']);
    
    if (result == null) return;

    controllerLinearProgress.sink.add(false);

    pickedFile = result.files.first;

    file = File(result.files.single.path!);    

    final path = 'files/${pickedFile!.name}';
    final files = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    uploadTask = ref.putFile(files);

    final snapshot = await uploadTask.whenComplete(() => {
      controllerLinearProgress.sink.add(true),
      print("UPLOAD DO ARQUIVO COMPLETO")
    });

    final urlArquivoDownload = await snapshot.ref.getDownloadURL();
    print("Download Link: $urlArquivoDownload");

    FirebaseFirestore.instance.collection("chat").add({
      "usuario": usuario.email,
      "texto": textoControllerEnviarMensagem.text,
      "imagem": null,
      "arquivo": urlArquivoDownload,
      "time": Timestamp.now(),
      });
  }      



}

