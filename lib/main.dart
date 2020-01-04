import 'package:cosmodex/screens/alien/alien.dart';
import 'package:flutter/material.dart';
import 'package:cosmodex/models/alien.dart';
import 'package:provider/provider.dart';

import 'configs/AppColors.dart';
import 'screens/aliensdex/aliensdex.dart';
import 'widgets/fade_page_route.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(builder: (context) => AlienModel()),
          // ... other provider(s)
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  Route _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return FadeRoute(page: AliensDex());

      case '/aliensdex':
        return FadeRoute(page: AliensDex());

      case '/alien-info':
        return FadeRoute(page: AlienInfo());

      default:
        return null;
    }
  }

  void preloadAssets(BuildContext context) {
    precacheImage(AssetImage('assets/pokeball.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    preloadAssets(context);

    return MaterialApp(
      color: Colors.white,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'CircularStd',
        textTheme: Theme.of(context).textTheme.apply(displayColor: AppColors.black),
        scaffoldBackgroundColor: AppColors.lightGrey,
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: _getRoute,
    );
  }
}