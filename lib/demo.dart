import 'package:flutter/material.dart';
import 'package:health_fitness/StepCounter.dart';
import 'package:health_fitness/ui/app_scroll_behavior.dart';

import 'Screen/home.dart';
import 'Screen/account.dart';
import 'Screen/news.dart';
import './fluid_nav_bar.dart';

class FluidNavBarDemo extends StatefulWidget {
  @override
  State createState() {
    return _FluidNavBarDemoState();
  }
}

class _FluidNavBarDemoState extends State {
  Widget _child = HomeContent();

  @override
  Widget build(context) {
    // Build a simple container that switches content based of off the selected navigation item
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 212, 241, 247),
        extendBody: true,
        body: _child,
        bottomNavigationBar: _child is StepCounter
            ? null
            : FluidNavBar(
                onChange:
                    _handleNavigationChange), // Ẩn thanh điều hướng nếu đang ở trang StepCounter
      ),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = HomeContent();
          break;
        case 1:
          _child = NewsList();
          break;
        case 2:
          _child = AccountContent();
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,
      );
    });
  }
}
