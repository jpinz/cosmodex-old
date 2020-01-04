import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/alien.dart';
import '../../../widgets/animated_fade.dart';
// import '../../../widgets/animated_rotation.dart';
// import '../../../widgets/animated_slide.dart';
// import '../../../widgets/alien_type.dart';
// import 'decoration_box.dart';

class AlienOverallInfo extends StatefulWidget {
  const AlienOverallInfo();

  @override
  _AlienOverallInfoState createState() => _AlienOverallInfoState();
}

class _AlienOverallInfoState extends State<AlienOverallInfo> with TickerProviderStateMixin {
  double textDiffLeft = 0.0;
  double textDiffTop = 0.0;

  static const double _appBarBottomPadding = 22.0;
  static const double _appBarHorizontalPadding = 28.0;
  static const double _appBarTopPadding = 60.0;

  GlobalKey _currentTextKey = GlobalKey();
  PageController _pageController;
  AnimationController _rotateController;
  AnimationController _slideController;
  GlobalKey _targetTextKey = GlobalKey();

  @override
  dispose() {
    _slideController?.dispose();
    _rotateController?.dispose();
    _pageController?.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _slideController = AnimationController(vsync: this, duration: Duration(milliseconds: 360));
    _slideController.forward();

    _rotateController = AnimationController(vsync: this, duration: Duration(milliseconds: 5000));
    _rotateController.repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox targetTextBox = _targetTextKey.currentContext.findRenderObject();
      final Offset targetTextPosition = targetTextBox.localToGlobal(Offset.zero);

      final RenderBox currentTextBox = _currentTextKey.currentContext.findRenderObject();
      final Offset currentTextPosition = currentTextBox.localToGlobal(Offset.zero);

      textDiffLeft = targetTextPosition.dx - currentTextPosition.dx;
      textDiffTop = targetTextPosition.dy - currentTextPosition.dy;
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_pageController == null) {
      AlienModel alienModel = AlienModel.of(context);

      _pageController = PageController(viewportFraction: 0.6, initialPage: alienModel.index);
      _pageController.addListener(() {
        int next = _pageController.page.round();

        if (alienModel.index != next) {
          alienModel.setSelectedIndex(next);
        }
      });
    }

    super.didChangeDependencies();
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.only(
        left: _appBarHorizontalPadding,
        right: _appBarHorizontalPadding,
        top: _appBarTopPadding,
        bottom: _appBarBottomPadding,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                child: Icon(Icons.arrow_back, color: Colors.white),
                onTap: Navigator.of(context).pop,
              ),
              Icon(Icons.favorite_border, color: Colors.white),
            ],
          ),
          // This widget just sit here for easily calculate the new position of
          // the alien name when the card scroll up
          Opacity(
            opacity: 0.0,
            child: Text(
              "Alien",
              key: _targetTextKey,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlienName(Alien alien) {
    final cardScrollController = Provider.of<AnimationController>(context);
    final fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(cardScrollController);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: cardScrollController,
            builder: (context, child) {
              final double value = cardScrollController.value ?? 0.0;

              return Transform.translate(
                offset: Offset(textDiffLeft * value, textDiffTop * value),
                child: Hero(
                  tag: alien.name,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      alien.name,
                      key: _currentTextKey,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 36 - (36 - 22) * value,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

    Widget _buildAlienExpansion(Alien alien) {
    final cardScrollController = Provider.of<AnimationController>(context);
    final fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(cardScrollController);

    return AnimatedFade(
      animation: fadeAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26),
        child: Column(children: <Widget>[
          Text(alien.expansion),
          Text("Alert Level: " + alien.alert_level)
        ],)
      ),
    );
  }

  Widget _buildAlienSlider(BuildContext context, Alien alien, List<Alien> aliens) {
    final screenSize = MediaQuery.of(context).size;
    final cardScrollController = Provider.of<AnimationController>(context);
    final fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: cardScrollController,
        curve: Interval(
          0.0,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );

    final selectedIndex = AlienModel.of(context).index;

    return AnimatedFade(
      animation: fadeAnimation,
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height * 0.24,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                  "assets/pokeball.png",
                  width: screenSize.height * 0.24,
                  height: screenSize.height * 0.24,
                  color: Colors.white.withOpacity(0.14),
                ),
            ),
            PageView.builder(
              physics: BouncingScrollPhysics(),
              controller: _pageController,
              itemCount: aliens.length,
              onPageChanged: (index) {
                AlienModel.of(context).setSelectedIndex(index);
              },
              itemBuilder: (context, index) => Hero(
                tag: aliens[index].image,
                child: AnimatedPadding(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeOutQuint,
                  padding: EdgeInsets.only(
                    top: selectedIndex == index ? 0 : screenSize.height * 0.04,
                    bottom: selectedIndex == index ? 0 : screenSize.height * 0.04,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: aliens[index].image,
                    imageBuilder: (context, image) => Image(
                      image: image,
                      width: screenSize.height * 0.28,
                      height: screenSize.height * 0.28,
                      alignment: Alignment.bottomCenter,
                      color: selectedIndex == index ? null : Colors.black26,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDecorations() {
    final screenSize = MediaQuery.of(context).size;

    final cardScrollController = Provider.of<AnimationController>(context);
    final dottedAnimation = Tween(begin: 1.0, end: 0.0).animate(cardScrollController);

    final pokeSize = screenSize.width * 0.448;
    final pokeTop = -(pokeSize / 2 - (IconTheme.of(context).size / 2 + _appBarTopPadding));
    final pokeRight = -(pokeSize / 2 - (IconTheme.of(context).size / 2 + _appBarHorizontalPadding));

    return [
      Positioned(
        top: pokeTop,
        right: pokeRight,
        child: AnimatedFade(
          animation: cardScrollController,
          child:Image.asset(
              "assets/pokeball.png",
              width: pokeSize,
              height: pokeSize,
              color: Colors.white.withOpacity(0.26),
            ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._buildDecorations(),
        Consumer<AlienModel>(
          builder: (_, model, child) => Column(
            children: <Widget>[
              _buildAppBar(),
              SizedBox(height: 9),
              _buildAlienName(model.alien),
              SizedBox(height: 9),
              _buildAlienExpansion(model.alien),
              SizedBox(height: 25),
              _buildAlienSlider(context, model.alien, model.aliens),
            ],
          ),
        ),
      ],
    );
  }
}