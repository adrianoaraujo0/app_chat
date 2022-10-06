import 'package:camera/camera.dart';

class CameraViewController{
  final List<String> pathList = [];


  void addImage(String path)async{
    pathList.add(path);
  }

}