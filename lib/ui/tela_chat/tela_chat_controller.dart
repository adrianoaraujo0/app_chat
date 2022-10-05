import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chat/ui/camera/camera_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

class TelaChatController {
  final TextEditingController textoControllerEnviarMensagem = TextEditingController();
  final BehaviorSubject<bool> controllerMudarCorSinalEnviarMensagem = BehaviorSubject<bool>();
  final BehaviorSubject<bool> controllerIsSendingFile = BehaviorSubject<bool>();

  ScrollController scrollListController = ScrollController();
  List<CameraDescription>? cameras;

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

    convertTimeStampToData(Timestamp.now());

    limparCampoMensagem();
    controllerMudarCorSinalEnviarMensagem.sink.add(false);
  }

  String convertTimeStampToData(Timestamp timestamp){ 
    return "   ${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}";
  }

   void abrirCamera(BuildContext context, User usuario){
    // Navigator.pop(context);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => CameraCamera(onFile: (file){
    //         uploadImageFirebase(usuario, file);
    //         Navigator.pop(context);
    //     })
    //   ),
    // );
   }
  
  void newAbrirCamera(BuildContext context, User usuario) async{
    Navigator.pop(context);
    var cameras = await availableCameras();
    var controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller.initialize();
    await Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage(cameras, controller, usuario)));
    Navigator.pop(context);
    await controller.dispose();
  }

  

  void uploadImageFirebase(User usuario, String path, BuildContext context) async{
    controllerIsSendingFile.sink.add(true);

    //salvar no storage
    UploadTask uploadImage = FirebaseStorage.instance.ref().child(
    DateTime.now().millisecondsSinceEpoch.toString()
    ).putFile(File(path));
     
     final TaskSnapshot taskSnapshot = await uploadImage.whenComplete(() => {
      controllerIsSendingFile.sink.add(false),
     });
    
    //pega link da image no storage
    final urlImageDownload = await taskSnapshot.ref.getDownloadURL();

    //add o link na collection
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

    controllerIsSendingFile.sink.add(true);

    pickedFile = result.files.first;

    file = File(result.files.single.path!);    

    final path = 'files/${pickedFile!.name}';
    final files = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    uploadTask = ref.putFile(files);

    final snapshot = await uploadTask.whenComplete(() => {
      controllerIsSendingFile.sink.add(false),
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


  Future abrirArquivo({required url, required String? fileName}) async{
     final file = await downloadFile(url, fileName!);
     if(file == null) return;

     print('Path: ${file.path}');

     OpenFile.open(file.path);
  }      

  Future<File?> downloadFile(String url, String name) async{
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    final response = await Dio().get(
      url, options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false, 
        receiveTimeout: 0,
      ));

    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();

    return file;
  }



}
