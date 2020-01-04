import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AlienContainer extends StatelessWidget {
  const AlienContainer({
    Key key,
    @required this.children,
    this.height,
    this.decoration,
    this.appBar = false,
  }) : super(key: key);

  final bool appBar;
  final List<Widget> children;
  final Decoration decoration;
  final double height;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final alienSize = screenSize.width * 0.66;
    final alienTop = -(screenSize.width * 0.154);
    final alienRight = -(screenSize.width * 0.23);
    final appBarTop = alienSize / 2 + alienTop - IconTheme.of(context).size / 2;

    return Container(
      width: screenSize.width,
      decoration: decoration,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: alienTop,
            right: alienRight,
            child: Image.asset(
              "assets/pokeball.png",
              width: alienSize,
              height: alienSize,
              color: Color(0xFF303943).withOpacity(0.05),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (appBar)
                Padding(
                  padding: EdgeInsets.only(left: 26, right: 26, top: appBarTop),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Icon(Icons.arrow_back),
                        onTap: Navigator.of(context).pop,
                      ),
                      Icon(Icons.menu),
                    ],
                  ),
                ),
              if (children != null) ...children,
            ],
          ),
        ],
      ),
    );
  }
}