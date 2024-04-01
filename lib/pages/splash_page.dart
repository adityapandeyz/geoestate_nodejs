import 'package:flutter/material.dart';
import 'package:geoestate/pages/login_page.dart';
import 'package:geoestate/provider/auth_provider.dart';
import 'package:geoestate/provider/dataset_provider.dart';
import 'package:geoestate/widgets/app_logo.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../provider/bank_provider.dart';
import '../provider/marker_provider.dart';
import '../services/auth_services.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    context.read<MarkerProvider>().loadMarkers();
    context.read<AuthProvider>().user;
    context.read<BankProvider>().loadBanks(context);
    context.read<DatasetProvider>().loadDatasets();
    return AnimatedSplashScreen(
      duration: 4000,
      splash: const Scaffold(
        body: Center(
          child: Card(
            child: SizedBox(
              height: 300,
              width: 300,
              child: AppLogo(
                size: 48,
              ),
            ),
          ),
        ),
      ),
      nextScreen: Provider.of<AuthProvider>(context).user.token.isNotEmpty
          ? const HomePage()
          : const LoginPage(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    );
  }
}
