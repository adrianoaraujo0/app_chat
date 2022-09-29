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
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  
  

  ultimaMensagem() async{
    WidgetsBinding.instance.addPostFrameCallback((_){
     scrollListController.jumpTo(scrollListController.position.maxScrollExtent);
    });
  }

  void salvarMensagemFirebase(User usuario) async{
    FirebaseFirestore.instance.collection("chat").add({
      "usuario": usuario.email,
      "texto": textoControllerEnviarMensagem.text,
      "imagem": null,
      "arquivo": file,
      "time": Timestamp.now(),
      });
      
      limparCampoMensagem();
    
    controllerMudarCorSinalEnviarMensagem.sink.add(false);
  }

  void limparCampoMensagem(){
    textoControllerEnviarMensagem.clear();
    imagemPath = null;
  }

   capturarImagem(BuildContext context ,User usuario) async {
     Navigator.pop(context);

    final XFile? imgfile = await ImagePicker().pickImage(source: ImageSource.camera);
 
    if (imgfile == null) return;
    
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(File(imgfile.path));
     
        FirebaseFirestore.instance.collection("chat").add({
        "usuario": usuario.email,
        "texto": textoControllerEnviarMensagem.text,
        "imagem": imgfile.path,
        "arquivo": null,
        "time": Timestamp.now(),
        });
  
      limparCampoMensagem();
  }

  void selecionarArquivo(BuildContext context ,User usuario) async{
     Navigator.pop(context);

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'pdf', 'doc']);
    
    if (result == null) return;
      pickedFile = result.files.first;

      file = File(result.files.single.path!);

      

      final path = 'files/${pickedFile!.name}';
      final files = File(pickedFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      
      uploadTask = ref.putFile(files);

      FirebaseFirestore.instance.collection("chat").add({
        "usuario": usuario.email,
        "texto": textoControllerEnviarMensagem.text,
        "imagem": null,
        "arquivo": files.path,
        "time": Timestamp.now(),
        });

      final snapshot = await uploadTask!.whenComplete(() => {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      print("Download Link: $urlDownload");
  }      



}

