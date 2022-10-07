import 'package:camera/camera.dart';

class CameraViewController{
  final List<String> pathList = [];


  void addImage(String path){
    pathList.add(path);
  }

  void removeImage(int index){
    pathList.removeAt(index);
  }

}