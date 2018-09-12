import 'package:flutter/material.dart';
import 'animated_plane_icon.dart';
import 'dart:async';
import 'animated_dot.dart';

class FlightTab extends StatefulWidget {
  final double height;
  final VoidCallback onPlaneFlightStart;

  FlightTab({
    this.height,
    this.onPlaneFlightStart,
  });

  @override
  _FlightTabState createState() => _FlightTabState();
}

class _FlightTabState extends State<FlightTab> with TickerProviderStateMixin {
  final List<int> _flightStops = [1, 2, 3, 4];
  final double _cardHeight = 80.0;
  final double _initialPlanePaddingBottom = 16.0;
  final double _minPlanePaddingTop = 16.0;
  AnimationController _planeSizeAnimationController;
  AnimationController _planeTravelController;
  Animation _planeSizeAnimation;
  Animation _planeTravelAnimation;

  AnimationController _dotsAnimationController;
  List<Animation<double>> _dotPositions = [];

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
    _initDotAnimationController();
    _initDotAnimations();
    _planeSizeAnimationController.forward();
  }

  @override
  void dispose() {
    _planeSizeAnimationController.dispose();
    _planeTravelController.dispose();
    _dotsAnimationController.dispose();
    super.dispose();
  }

  _initSizeAnimations() {
    _planeSizeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 500), () {
            widget.onPlaneFlightStart();
            _planeTravelController.forward();
          });
          Future.delayed(Duration(milliseconds: 700), () {
            _dotsAnimationController.forward();
          });
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

  void _initDotAnimations() {
    final double slideDurationInterval = 0.4;
    final double slideDelayInterval = 0.2;
    double startingMarginTop = widget.height;
    double minMarginTop =
        _minPlanePaddingTop + _planeSize + 0.5 * (0.8 * _cardHeight);

    for (int i = 0; i < _flightStops.length; i++) {
      final start = slideDelayInterval * i;
      final end = start + slideDurationInterval;

      double finalMarginTop = minMarginTop + i * (0.8 * _cardHeight);
      Animation<double> animation = new Tween(
        begin: startingMarginTop,
        end: finalMarginTop,
      ).animate(
        new CurvedAnimation(
          parent: _dotsAnimationController,
          curve: new Interval(start, end, curve: Curves.easeOut),
        ),
      );
      _dotPositions.add(animation);
    }
  }

  void _initDotAnimationController() {
    _dotsAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[_buildPlane()]
          ..addAll(_flightStops.map(_mapFlightStopToDot)),
      ),
    );
  }

  Widget _mapFlightStopToDot(stop) {
    int index = _flightStops.indexOf(stop);
    bool isStartOrEnd = index == 0 || index == _flightStops.length - 1;
    Color color = isStartOrEnd ? Colors.red : Colors.green;
    return AnimatedDot(
      animation: _dotPositions[index],
      color: color,
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
            height: _flightStops.length * _cardHeight * 0.8,
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
