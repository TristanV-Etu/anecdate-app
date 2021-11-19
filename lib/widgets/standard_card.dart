import 'dart:async';
import 'dart:math' as math;

import 'package:anecdate_app/model/anecdate.dart';
import 'package:anecdate_app/widgets/details_page.dart';
import 'package:flutter/material.dart';

class StandardCard extends Card {
  final Anecdate anecdate;

  StandardCard(this.anecdate);

  final StreamController<double> _controller = StreamController<double>();

  @override
  Widget build(BuildContext context) {
    double swipeAngle = math.pi / 4;
    _controller.add(swipeAngle);
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailsPage(anecdate)));
      },
      child: Padding(
        padding: EdgeInsets.all(26),
        child: SizedBox(
          height: size.height * 0.7,
          width: size.width,
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
                      child: Image.asset(
                        anecdate.image!,
                        height: size.height * 0.2,
                        width: size.width,
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
                        print("report ${anecdate.title}");
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
}
