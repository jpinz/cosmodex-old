import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/alien.dart';


String _formattedExpansionInitials(String expansion) {
  List<String> initials = List<String>();
  initials = expansion.split(" ");
  return "${initials[0][0] + initials[1][0]}";
}

String capitalizeFirstChar(String text) {
  if (text == null || text.length <= 1) {
    return text.toUpperCase();
  }

  return text[0].toUpperCase() + text.substring(1);
}

class AlienCard extends StatelessWidget {
  const AlienCard(
    this.alien, {
    @required this.index,
    Key key,
    this.onPress,
  }) : super(key: key);

  final int index;
  final Function onPress;
  final Alien alien;

  Widget _buildCardContent() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: alien.name,
              child: Material(
                color: Colors.transparent,
                child: Text(
                  alien.name,
                  style: TextStyle(
                    fontSize: 14,
                    height: 0.7,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDecorations(double itemHeight) {
    return [
      Positioned(
        bottom: -itemHeight * 0.136,
        right: -itemHeight * 0.034,
        child: Image.asset(
          "assets/pokeball.png",
          width: itemHeight * 0.754,
          height: itemHeight * 0.754,
          color: Colors.white.withOpacity(0.14),
        ),
      ),
      Positioned(
        bottom: 8,
        right: 12,
        child: Hero(
          tag: alien.image,
          child: CachedNetworkImage(
            imageUrl: alien.image,
            imageBuilder: (context, imageProvider) => Image(
              image: imageProvider,
              fit: BoxFit.contain,
              width: itemHeight * 0.6,
              height: itemHeight * 0.6,
              alignment: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      Positioned(
        top: 10,
        right: 14,
        child: Text(
          _formattedExpansionInitials(alien.expansion),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.52),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        final itemHeight = constrains.maxHeight;

        return Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: alien.color.withOpacity(0.12),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Material(
              color: alien.color,
              child: InkWell(
                onTap: onPress,
                splashColor: Colors.white10,
                highlightColor: Colors.white10,
                child: Stack(
                  children: [
                    _buildCardContent(),
                    ..._buildDecorations(itemHeight),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}