import 'dart:convert' as json;

import 'package:flutter/material.dart';

import '../configs/AppColors.dart';
import '../models/alien.dart';

// Parses aliens.json File
Future<List<Alien>> getAliensList(BuildContext context) async {
  String jsonString = await DefaultAssetBundle.of(context).loadString("assets/aliens.json");
  List<dynamic> jsonData = json.jsonDecode(jsonString);

  List<Alien> aliens = jsonData.map((json) => Alien.fromJson(json)).toList();

  return aliens;
}

// A function to get Color for the alien
Color getAlienColor(String color) {
  switch (color.toLowerCase()) {
    case 'red':
      return AppColors.red;
    case 'yellow':
      return AppColors.yellow;
    case 'green':
      return AppColors.green;
    default:
      return AppColors.green;
  }
}