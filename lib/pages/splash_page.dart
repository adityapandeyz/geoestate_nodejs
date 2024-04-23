import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geoestate/pages/loading_page.dart';
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
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 6), () {
      navigateUser();
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   timer = Timer(const Duration(seconds: 10), () {
  //     showRetryWindow(
  //         "Process aborted due to timeout. Please check your internet connection and try again.");
  //   });
  //   loadDataAndNavigate();
  // }

  // void showRetryWindow(String error) async {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Error loading data'),
  //         content: Text('Error loading data: ${error}'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               loadDataAndNavigate();
  //             },
  //             child: const Text('Retry'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //   return;
  // }

  // Future<void> loadDataAndNavigate() async {
  //   try {
  //     await context.read<MarkerProvider>().loadMarkers();
  //     await context.read<BankProvider>().loadBanks();
  //     await context.read<DatasetProvider>().loadDatasets();

  //     if (context.read<MarkerProvider>().markers!.isNotEmpty &&
  //         context.read<BankProvider>().banks!.isNotEmpty &&
  //         context.read<DatasetProvider>().datasets!.isNotEmpty) {
  //       timer.cancel();
  //       Navigator.pushReplacement(
  //         context,
  //         PageTransition(
  //           type: PageTransitionType.leftToRightWithFade,
  //           child: Provider.of<AuthProvider>(context, listen: false)
  //                   .user
  //                   .token
  //                   .isNotEmpty
  //               ? const HomePage()
  //               : const LoginPage(),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     timer.cancel();
  //     showRetryWindow(e.toString());
  //   }
  // }

  Future<void> navigateUser() async {
    await Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.leftToRightWithFade,
        child: Provider.of<AuthProvider>(context, listen: false)
                .user
                .token
                .isNotEmpty
            ? LoadingPage()
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
