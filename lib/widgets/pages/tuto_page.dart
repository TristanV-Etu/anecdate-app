import 'package:flutter/material.dart';

class TutoPageFirstUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: InkWell(
        child: Container(
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Commençons d'abord par un petit tutoriel de l'application",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          width: _size.width,
          height: _size.height,
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context, TransparentRoute(builder: (context) => TutoPage()));
        },
      ),
    );
  }
}

class TutoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: InkWell(
        child: Container(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app_outlined,
                    size: 100,
                    color: Colors.white,
                  ),
                  Text(
                    "Selectionne pour en savoir plus",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          width: _size.width,
          height: _size.height,
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context,
              TransparentRoute(builder: (context) => TutoSecondPage()));
        },
      ),
    );
  }
}

class TutoSecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: InkWell(
        child: Container(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Glisse ton doigt vers ...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: _size.width * 0.3,
                        child: Text(
                          "La gauche pour désapprouver",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Icon(
                        Icons.swipe_outlined,
                        size: 100,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: _size.width * 0.3,
                        child: Text(
                          "La droite pour approuver",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          width: _size.width,
          height: _size.height,
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context, TransparentRoute(builder: (context) => TutoThirdPage()));
        },
      ),
    );
  }
}

class TutoThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: InkWell(
        child: Container(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: _size.width * 0.6,
                    child: Text(
                      "Le haut pour passer à l'Anec'Date précédente",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: _size.height*0.16,),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Glisse ton doigt vers ...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(
                    Icons.swipe_outlined,
                    size: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: _size.height*0.16,),
                  SizedBox(
                    width: _size.width * 0.6,
                    child: Text(
                      "Le bas pour passer à l'Anec'Date suivante",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          width: _size.width,
          height: _size.height,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
    required this.builder,
    RouteSettings? settings,
  })  : assert(builder != null),
        super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
  }
}
