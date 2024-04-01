import 'package:flutter/material.dart';
import 'package:geoestate/pages/about_page.dart';
import 'package:geoestate/pages/dateset_page.dart';
import 'package:geoestate/pages/home_page.dart';
import 'package:geoestate/pages/login_page.dart';
import 'package:geoestate/pages/map_page.dart';
import 'package:geoestate/pages/splash_page.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const LoginPage(),
      );

    case HomePage.routeName:
      return MaterialPageRoute(
        builder: (_) => const HomePage(),
      );

    case SplashPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const SplashPage(),
      );

    case AboutPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const AboutPage(),
      );

    case MapPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const MapPage(),
      );

    case DatasetPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const DatasetPage(),
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Error 404!'),
          ),
        ),
      );
  }
}
