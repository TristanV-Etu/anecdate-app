import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("A propos"),),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Cette application a été réalisé par des étudiants dans le cadre du projet Platine du Master E-Services du pôle Informatique de l'Université de Lille.\n\n" +
                    "PERSEVAL Alexandre\nVALET Tristan",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
