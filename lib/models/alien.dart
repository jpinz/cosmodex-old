import 'dart:collection';

import 'package:cosmodex/models/flare.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/aliens.dart';

class Alien {
  const Alien({
    @required this.name,
    this.image,
    this.expansion,
    this.alert_level,
    this.short_desc,
    this.game_setup,
    this.description,
    this.player,
    this.mandatory,
    this.phases,
    this.lore,
    // this.wild,
    // this.super_flare,
    this.retooled_gameplay,
    this.edits,
    this.tips,
    // this.classic_flare,    
  });

  Alien.fromJson(dynamic json)
      : name = json["name"],
        image = json["imageurl"],
        expansion = json["expansion"],
        alert_level = json["color"],
        short_desc = json["short_desc"],
        game_setup = json["game_setup"],
        description = json["description"],
        player = json["player"],
        mandatory = json["mandatory"],
        phases = json["phases"].cast<String>(),
        lore = json["lore"],
        // wild = json["wild"].cast<Flare>(),
        // super_flare = json["super_flare"].cast<Flare>(),
        retooled_gameplay = json["retooled_gameplay"],
        edits = json["edits"],
        tips = json["tips"] != null ? json["tips"].cast<String>() : [];
        // classic_flare = json["classic_flare"];

  final String name;
  final String image;
  final String expansion;
  final String alert_level;
  final String short_desc;
  final String game_setup;
  final String description;
  final String player;
  final bool mandatory;
  final List<String> phases;
  final String lore;
  // final Flare wild;
  // final Flare super_flare;
  final String retooled_gameplay;
  final String edits;
  final List<String> tips;
  // final List<Flare> classic_flare;

  Color get color => getAlienColor(alert_level);
}

class AlienModel extends ChangeNotifier {
  final List<Alien> _aliens = [];
  int _selectedIndex = 0;

  UnmodifiableListView<Alien> get aliens => UnmodifiableListView(_aliens);

  bool get hasData => _aliens.length > 0;

  Alien get alien => _aliens[_selectedIndex];

  int get index => _selectedIndex;

  static AlienModel of(BuildContext context, {bool listen = false}) =>
      Provider.of<AlienModel>(context, listen: listen);

  void setAliens(List<Alien> aliens) {
    _aliens.clear();
    _aliens.addAll(aliens);

    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;

    notifyListeners();
  }
}