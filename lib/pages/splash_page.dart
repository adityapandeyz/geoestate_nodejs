import 'package:flutter/material.dart';
import 'package:geoestate/pages/login_page.dart';
import 'package:geoestate/provider/auth_provider.dart';
import 'package:geoestate/provider/dataset_provider.dart';
import 'package:geoestate/widgets/app_logo.dart';
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
    loadDataAndNavigate();
  }

  Future<void> loadDataAndNavigate() async {
    await context.read<MarkerProvider>().loadMarkers();
    await context.read<BankProvider>().loadBanks();
    await context.read<DatasetProvider>().loadDatasets();

    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.leftToRightWithFade,
        child: Provider.of<AuthProvider>(context, listen: false)
                .user
                .token
                .isNotEmpty
            ? const HomePage()
            : const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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
    );
  }
}
