import 'dart:io';
import 'package:chat/ui/tela_chat/tela_chat_controller.dart';
import 'package:chat/ui/tela_login/tela_login_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TelaChat extends StatefulWidget {
  @override
  State<TelaChat> createState() => _TelaChatState();
  TelaChat({required this.usuario});

  User usuario;
}

class _TelaChatState extends State<TelaChat> {
  TelaChatController telaChatController = TelaChatController();
  TelaLoginController telaLoginController = TelaLoginController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Colors.black12,
        actions: [
          IconButton(onPressed: (){
            telaLoginController.fazerLogout(context);
          }, icon: const Icon(Icons.logout)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("chat").orderBy("time").snapshots(),
              builder: (context, snapshot) {
                
                if (snapshot.data == null) { 
                  return const Center(child: CircularProgressIndicator());
                }
                if(TelaLoginController.usuario!.email == snapshot.data!.docs.last["usuario"]){
                  telaChatController.ultimaMensagem();
                } 
                return Expanded(
                  child: listaMensagens(snapshot.data!.docs),
                );
              },
            ),
            enviarMensagem(context),
          ],
        ),
      ),
    );
  }

  Widget listaMensagens(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    return Scrollbar(
      thickness: 8,
      child: ListView.builder(
        controller: telaChatController.scrollListController,
        itemCount: docs.length,
        itemBuilder: (context, index) => itemMensagem(docs[index]),
      ),
    );
  }

  Widget itemMensagem(QueryDocumentSnapshot<Map<String, dynamic>> itemLista ){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(  
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                image: AssetImage("images/person.png") 
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [    
                Text.rich(
                  TextSpan(children: [
                    TextSpan(text: itemLista["usuario"], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const TextSpan(text: "   10:33 AM", style: TextStyle(color: Colors.white60, fontSize: 12))
                  ])
                  ),
                const SizedBox(height: 4,),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(itemLista["imagem"] != null)...{
                        Image.file(File(itemLista["imagem"]), height: 230),
                      },
                      if(itemLista["arquivo"] != null)...{
                        Image.file(File(itemLista["arquivo"]), height: 230),
                      },
                      if(itemLista["texto"] != null)...{
                        Text("${itemLista["texto"]}", style: const  TextStyle(color: Colors.white70, fontSize: 14)),
                      }
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget enviarMensagem(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Row(
        children: [
          PopupMenuButton( 
            icon: const Icon(Icons.add,  color: Colors.blue,  size: 30),
            itemBuilder: (context) => [
              PopupMenuItem(
                height: 40, 
                child:Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async => telaChatController.capturarImagem(context, widget.usuario),
                      icon: const Icon(Icons.photo_camera, size: 30)
                    ),
                    IconButton(
                      onPressed: () async => telaChatController.selecionarArquivo(context ,widget.usuario),
                      icon: const Icon(Icons.upload_file, size: 30)
                    ),
                  ],
                )
              )
            ]
          ),
          // IconButton(
          //   onPressed: () async => telaChatController.capturarImagem(widget.usuario),
          //   icon: const Icon(Icons.add,  color: Colors.blue,)
          // ),
          Expanded(
            child: TextField(
              onChanged: (value) => telaChatController.controllerMudarCorSinalEnviarMensagem.sink.add(value.isNotEmpty),
              controller: telaChatController.textoControllerEnviarMensagem,
              decoration: const InputDecoration.collapsed(hintText: "Enviar mensagem")
            ),
          ),
          StreamBuilder<bool>(
            stream: telaChatController.controllerMudarCorSinalEnviarMensagem.stream,
            builder: (context, snapshot) {
              return IconButton(
                onPressed:  snapshot.data == true ? () => telaChatController.salvarMensagemFirebase(widget.usuario) : null,
                icon: Icon(Icons.send, color: snapshot.data == true ? Colors.blue : Colors.grey,)
              );
            }
          ),
        ],
      ),
    );
  }
}