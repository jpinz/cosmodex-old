import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../configs/AppColors.dart';
import '../../../models/alien.dart';

class AlienNotes extends StatelessWidget {
  Widget _buildSection(String text, {List<Widget> children, Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
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
        height: 1,
      ),
    );
  }

  Widget _buildEdits(String edits) {
    if (edits != null) {
      return _buildSection(
        "Edits",
        child: Text(edits),
      );
    }
  }

  Widget _buildTips(Alien alien) {
    if (alien.tips.length > 0) {
      return _buildSection("Tips", children: [
        Column(
          children: alien.tips.map((tip) => Text(tip)).toList(),
        ),
      ]);
    }
  }

  Widget _buildRetooledGameplay(String retooled_gameplay) {
    if (retooled_gameplay != null) {
      return _buildSection(
        "Retooled Gameplay",
        child: Text(retooled_gameplay),
      );
    }
  }

  List<Widget> _buildNotes(Alien alien) {
    List<Widget> widgets = List<Widget>();
    if (alien.tips.length == 0 &&
        alien.retooled_gameplay == null &&
        alien.edits == null) {
      return [Text("No Notes")];
    }
    if (alien.tips.length > 0) {
      widgets.add(_buildTips(alien));
      widgets.add(SizedBox(height: 15));
    }
    if (alien.retooled_gameplay != null) {
      widgets.add(_buildRetooledGameplay(alien.retooled_gameplay));
      widgets.add(SizedBox(height: 15));
    }
    if (alien.edits != null) {
      widgets.add(_buildEdits(alien.edits));
      widgets.add(SizedBox(height: 15));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final cardController = Provider.of<AnimationController>(context);

    return AnimatedBuilder(
      animation: cardController,
      child: Consumer<AlienModel>(
        builder: (_, model, child) => Column(
          children: _buildNotes(model.alien),
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
