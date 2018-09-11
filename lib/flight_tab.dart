import 'package:flutter/material.dart';
import 'animated_plane_icon.dart';
import 'dart:async';

class FlightTab extends StatefulWidget {
  final double height;

  FlightTab({
    this.height,
  });

  @override
  _FlightTabState createState() => _FlightTabState();
}

class _FlightTabState extends State<FlightTab> with TickerProviderStateMixin {
  final double _initialPlanePaddingBottom = 16.0;
  final double _minPlanePaddingTop = 16.0;
  AnimationController _planeSizeAnimationController;
  AnimationController _planeTravelController;
  Animation _planeSizeAnimation;
  Animation _planeTravelAnimation;

  double get _planeTopPadding =>
      _minPlanePaddingTop +
      (1 - _planeTravelAnimation.value) * _maxPlaneTopPadding;

  double get _maxPlaneTopPadding =>
      widget.height -
      _initialPlanePaddingBottom -
      _planeSize -
      _minPlanePaddingTop;

  double get _planeSize => 60.0;

  @override
  void initState() {
    super.initState();
    _initSizeAnimations();
    _initPlaneTravelAnimations();
    _planeSizeAnimationController.forward();
  }

  @override
  void dispose() {
    _planeSizeAnimationController.dispose();
    super.dispose();
  }

  _initSizeAnimations() {
    _planeSizeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 500),
              () => _planeTravelController.forward());
        }
      });

    _planeSizeAnimation =
        Tween<double>(begin: 60.0, end: 36.0).animate(CurvedAnimation(
      parent: _planeSizeAnimationController,
      curve: Curves.easeOut,
    ));
  }

  _initPlaneTravelAnimations() {
    _planeTravelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _planeTravelAnimation = CurvedAnimation(
      parent: _planeTravelController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[_buildPlane()],
      ),
    );
  }

  Widget _buildPlane() {
    return AnimatedBuilder(
      animation: _planeTravelAnimation,
      child: Column(
        children: <Widget>[
          AnimatedPlaneIcon(animation: _planeSizeAnimation),
          Container(
            width: 2.0,
            height: 240.0,
            color: Color.fromARGB(255, 200, 200, 200),
          )
        ],
      ),
      builder: (context, child) => Positioned(
            child: child,
            top: _planeTopPadding,
          ),
    );
  }
}
