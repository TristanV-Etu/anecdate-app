import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/utils/globals.dart';
import 'package:anecdate_app/widgets/pages/details_page.dart';
import 'package:anecdate_app/widgets/pages/report_page.dart';
import 'package:flutter/material.dart';

import '../connection.dart';

class StandardCard extends Card {
  final Anecdate anecdate;
  late BuildContext _ctx;
  late Size _size;

  StandardCard(this.anecdate);

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    _size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailsPage(anecdate)));
      },
      child: Padding(
        padding: EdgeInsets.all(26),
        child: SizedBox(
          height: _size.height * 0.7,
          width: _size.width,
          child: Card(
            elevation: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  anecdate.date.day.toString() +
                      " / " +
                      anecdate.date.month.toString(),
                ),
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Center(
                      child: Image.network(
                        anecdate.image!,
                        height: _size.height * 0.2,
                        width: _size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(anecdate.date.year.toString()),
                  ],
                ),
                Padding(
                  child: Text(anecdate.title),
                  padding: const EdgeInsets.all(20),
                ),
                const Divider(),
                Padding(
                  child: Text(
                    anecdate.description,
                    overflow: TextOverflow.ellipsis,
                  ),
                  padding: const EdgeInsets.all(16),
                ),
                Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        _goToReportPage();
                      },
                      icon: const Icon(Icons.warning),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToReportPage() {
    if (Globals.isConnect) {
      Navigator.push(_ctx,
          MaterialPageRoute(builder: (context) => ReportPage(anecdate.id)));
    } else {
      Navigator.push(
          _ctx, MaterialPageRoute(builder: (context) => SignUpPage()));
    }
  }
}
