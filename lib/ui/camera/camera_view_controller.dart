import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraViewController{
  

  Future<bool> showConfirmationDialogExitWithoutSaving(BuildContext context, bool condition){
    
  if(condition){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Deseja sair sem salvar as fotos"),
            actions: [
              TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('Cancelar')),
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  }, child: const Text('Sair')),
            ],
           );
         },
      );
    return Future.value(false);
    }
    return Future.value(true);

  }



}