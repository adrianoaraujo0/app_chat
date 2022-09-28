import 'package:chat/ui/tela_login/tela_login_controller.dart';
import 'package:flutter/material.dart';

class TelaLogin extends StatelessWidget {
   TelaLogin({super.key});
  TelaLoginController telaLoginController = TelaLoginController();
  

   @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children:  [
                  TextField(
                    controller: telaLoginController.emailController ,
                    decoration: const InputDecoration(hintText: "Insira seu email" ,border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: telaLoginController.senhaController ,
                    decoration: const InputDecoration(hintText: "Insira sua senha" ,border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: (){
                    telaLoginController.fazerLoginEmailSenha(context);
                  },child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60.0),
                      child: Text("Entrar", style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                   const SizedBox(height: 10),
                  TextButton(onPressed: (() {
                    telaLoginController.fazerLoginGoogle(context);
                    
                  }), child: const Text("Entrar com google", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}