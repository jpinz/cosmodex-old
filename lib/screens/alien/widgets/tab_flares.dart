import 'package:cosmodex/models/flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../configs/AppColors.dart';
import '../../../models/alien.dart';

class AlienFlares extends StatelessWidget {
  Widget _buildSection(String text, {bool larger = false, List<Widget> children, Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          style:
              TextStyle(fontSize: larger ? 20 : 16, height: larger ? 1.2 : 0.8, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 22),
        if (child != null) child,
        if (children != null) ...children
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.black.withOpacity(0.6),
        height: 0.8,
      ),
    );
  }

  Widget _buildWildFlare(Flare wild) {
    return _buildSection("Wild", children: [
      Text(
        wild.description,
        style: TextStyle(height: 1.3),
      ),
      Row(children: <Widget>[
        Chip(label: Text(wild.player)),
        SizedBox(width: 5),
        Chip(label: Text(wild.phase)),
      ]),
      SizedBox(height: 15)
    ]);
  }

  Widget _buildSuperFlare(Flare super_flare) {
    return _buildSection("Super", children: [
      Text(
        super_flare.description,
        style: TextStyle(height: 1.3),
      ),
      Row(children: <Widget>[
        Chip(label: Text(super_flare.player)),
        SizedBox(width: 5),
        Chip(label: Text(super_flare.phase)),
      ]),
      SizedBox(height: 15)
    ]);
  }

  Widget _buildClassicFlares(List<Flare> flares) {
    if (flares.length > 0) {
      return _buildSection("Classic Edition", larger: true, children: [
        _buildSection("Wild", children: [
          Text(
            flares[0].description,
            style: TextStyle(height: 1.3),
          ),
          Row(children: <Widget>[
            Chip(label: Text(flares[0].player)),
            SizedBox(width: 5),
            Chip(label: Text(flares[0].phase)),
          ]),
          SizedBox(height: 15)
        ]),
        _buildSection("Super", children: [
          Text(
            flares[1].description,
            style: TextStyle(height: 1.3),
          ),
          Row(children: <Widget>[
            Chip(label: Text(flares[1].player)),
            SizedBox(width: 5),
            Chip(label: Text(flares[1].phase)),
          ]),
          SizedBox(height: 15)
        ]),
      ]);
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final cardController = Provider.of<AnimationController>(context);

    return AnimatedBuilder(
      animation: cardController,
      child: Consumer<AlienModel>(
        builder: (_, model, child) => Column(
          children: <Widget>[
            _buildWildFlare(model.alien.wild),
            _buildSuperFlare(model.alien.super_flare),
            _buildClassicFlares(model.alien.classic_flare)
          ],
        ),
      ),
      builder: (context, child) {
        final scrollable = cardController.value.floor() == 1;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 19, horizontal: 27),
          physics: scrollable
              ? BouncingScrollPhysics()
              : NeverScrollableScrollPhysics(),
          child: child,
        );
      },
    );
  }
}
