import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  Anecdate anecdate;

  DetailsPage(this.anecdate, {Key? key}) : super(key: key);

  @override
  DetailsPageState createState() => DetailsPageState(this.anecdate);
}

class DetailsPageState extends State<DetailsPage> {
  Anecdate anecdate;

  DetailsPageState(this.anecdate);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text("Details : ${anecdate.title}"),
        ),
      ),
    );
  }
}
