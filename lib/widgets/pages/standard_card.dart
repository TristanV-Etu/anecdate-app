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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: _size.width * 0.45,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  child: Center(
                    child: Container(
                      width: _size.width * 0.45,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Center(
                        child: Text(
                          anecdate.date.day.toString() +
                              " / " +
                              anecdate.date.month.toString(),
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Center(
                      child: Image.network(
                        anecdate.image!,
                        height: _size.height * 0.25,
                        width: _size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: _size.height * 0.202),
                      child: Text(
                        anecdate.date.year.toString(),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    child: Text(
                      anecdate.title,
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                  ),
                ),
                const Divider(),
                Padding(
                  child: Text(
                    anecdate.description,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 8,
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
