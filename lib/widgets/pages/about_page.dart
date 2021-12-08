import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A propos"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Anec'Date est une application de culture générale vous proposant de petites anecdotes journalières " +
                    "classées par catégorie et liées à la date du jour. Tel un wiki(Application web qui permet la création, la modification et " +
                    "l'illustration collaboratives de pages à l'intérieur d'un site web), les informations et les " +
                    "données sont proposées par les utilisateurs pour les utilisateurs. \n\n\n\n" +
                    "Cette application a été réalisée par des étudiants dans le cadre du projet Platine " +
                    "du Master E-Services du pôle Informatique de l'Université de Lille.\n\n" +
                    "PERSEVAL Alexandre\nVALET Tristan\n\n\n" +
                    "Merci infiniment pour l'aide de Romain Hembert qui nous a aiguillé dans la conception et la réalisation de notre " +
                    "projet, ainsi que notre directeur d'études Jean-Claude Tarby et de toute l'équipe pédagogique du FIL (" +
                    "Formation en Informatique de Lille).",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
