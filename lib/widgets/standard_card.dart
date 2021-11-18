import 'package:anecdate_app/model/anecdate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';

class StandardCard extends Card {

  final Anecdate anecdate;
  StandardCard(this.anecdate);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Swipable(
      onSwipeUp: (finalPosition) {
        print("Swipe Up ${anecdate.title}");
      },
      onSwipeDown: (finalPosition) {
        print("Swipe Down ${anecdate.title}");
      },
      onSwipeLeft: (finalPosition) {
        print("Swipe Left ${anecdate.title}");
      },
      onSwipeRight: (finalPosition) {
        print("Swipe Right ${anecdate.title}");
      },
      child: Padding(
        padding: EdgeInsets.all(26),
        child: SizedBox(
          height: size.height*0.7,
          width: size.width,
          child: Card(
            elevation: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    anecdate.date.day.toString() + " / "+ anecdate.date.month.toString(),
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
                    child: Text(anecdate.title), padding: EdgeInsets.all(20),
                ),
                const Divider(),Padding(
                  child: Text(anecdate.description), padding: EdgeInsets.all(16),
                ),
                Row(
                  children: [
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          print("report ${anecdate.title}");
                        },
                        icon: Icon(Icons.warning),
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


// Widget createStandardCard(Anecdate anecdate, double width, double height) {
//   return Container(
//     height: height,
//     width: width,
//     margin: const EdgeInsets.all(26),
//     child: Column(
//       children: [
//         Text(
//             anecdate.date.day.toString() + " / "+ anecdate.date.month.toString(),
//         ),
//         Stack(
//           alignment: Alignment.bottomLeft,
//           children: [
//             Center(
//               child: Image.asset(
//                 anecdate.image!,
//                 height: height * 0.4,
//                 width: width,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Text(anecdate.date.year.toString()),
//           ],
//         ),
//         Padding(
//             child: Text(anecdate.title), padding: EdgeInsets.all(20),
//         ),
//         const Divider(),Padding(
//           child: Text(anecdate.description), padding: EdgeInsets.all(16),
//         ),
//         Row(
//           children: [
//             Spacer(),
//             IconButton(
//                 onPressed: () {
//                   print("report ${anecdate.title}");
//                 },
//                 icon: Icon(Icons.warning),
//             )
//           ],
//         )
//       ],
//     ),
//   );
// }

