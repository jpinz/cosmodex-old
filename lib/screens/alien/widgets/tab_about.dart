import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../configs/AppColors.dart';
import '../../../models/alien.dart';

class AlienAbout extends StatelessWidget {
  Widget _buildSection(String text, {List<Widget> children, Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
            text,
            style: TextStyle(
                fontSize: 16, height: 0.8, fontWeight: FontWeight.bold),
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

  Widget _buildPlayerAndMandatory(String player, bool mandatory) {
    String mo = mandatory ? "Mandatory" : "Optional";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: Offset(0, 8),
            blurRadius: 23,
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildLabel("Player"),
                SizedBox(height: 11),
                Text("$player", style: TextStyle(height: 0.8))
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildLabel("Is Mandatory?"),
                SizedBox(height: 11),
                Text("$mo", style: TextStyle(height: 0.8))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String description) {
    return _buildSection("Power",
        child: Text(
          description,
          style: TextStyle(height: 1.3),
        ));
  }

  Widget _buildGameSetup(String setup) {
    if (setup != null) {
      return _buildSection("Game Setup", children: [
        Text(setup),
        SizedBox(height: 28),
      ]);
    }
    return SizedBox.shrink();
  }

  Widget _buildPhases(Alien alien) {
    return _buildSection("Phases",
        child: Wrap(
          spacing: 5.0,
          runSpacing: 1,
          children:
              alien.phases.map((phase) => Chip(label: Text(phase))).toList(),
        ));
  }

  Widget _buildLore(String lore) {
    return _buildSection(
      "Lore",
      child: Text(lore),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardController = Provider.of<AnimationController>(context);

    return AnimatedBuilder(
      animation: cardController,
      child: Consumer<AlienModel>(
        builder: (_, model, child) => Column(
          children: <Widget>[
            _buildGameSetup(model.alien.game_setup),
            _buildDescription(model.alien.description),
            SizedBox(height: 28),
            _buildLore(model.alien.lore),
            SizedBox(height: 28),
            _buildPlayerAndMandatory(model.alien.player, model.alien.mandatory),
            SizedBox(height: 31),
            _buildPhases(model.alien),
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
