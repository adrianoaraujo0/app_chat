
import 'package:chat/ui/tela_chat/tela_chat_view.dart';
import 'package:chat/ui/tela_login/tela_login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TelaLoginController{

  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  final firebaseAuth = FirebaseAuth.instance;
  static User? usuario;
  
  final GoogleSignIn googleSignIn = GoogleSignIn();

  fazerLoginEmailSenha(BuildContext context) async{
    
    try{
          UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: emailController.text,
          password: senhaController.text
      );
      usuario = userCredential.user;
      if(userCredential != null){
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => TelaChat(usuario: usuario!,)));
      }
    }on FirebaseAuthException catch(e){
      if(e.code == "user-not-found"){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário não encontrado"),
          backgroundColor: Colors.redAccent, 
          )
        );
      }else if(e.code == "wrong-password"){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sua senha esta errada"),
          backgroundColor: Colors.redAccent, 
          )
        );
      }
    }
  }

  fazerLogout(BuildContext context){
      
        Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => TelaLogin()));
  }

  void fazerLoginGoogle(BuildContext context) async{
        try{
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
          

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      usuario = userCredential.user;
      
    if(usuario != null){
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => TelaChat(usuario: usuario!)));
      } 
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login falhou"),
          backgroundColor: Colors.redAccent, 
          )
        );
    }
  }  

}