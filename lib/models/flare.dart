import 'package:flutter/material.dart';

// import '../data/flares.dart';

class Flare {
  const Flare({
    @required this.description,
    this.player,
    this.phase,
  });

  Flare.fromJson(dynamic json)
      : description = json["description"],
        player = json["player"],
        phase = json["phase"];

  final String description;
  final String player;
  final String phase;
}