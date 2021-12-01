import 'package:flutter/material.dart';

class TutoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.2),
      body: InkWell(
        child: Container(
          child: Text("Tuto1"),
          width: _size.width,
          height: _size.height,
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context,
              TransparentRoute(builder: (context) => TutoSecondPage())
          );
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
      backgroundColor: Colors.black.withOpacity(0.2),
      body: InkWell(
        child: Container(
          child: Text("Tuto2"),
          width: _size.width,
          height: _size.height,
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context,
              TransparentRoute(builder: (context) => TutoThirdPage())
          );
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
      backgroundColor: Colors.black.withOpacity(0.2),
      body: InkWell(
        child: Container(
          child: Text("Tuto3"),
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
