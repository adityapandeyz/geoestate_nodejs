import 'package:flutter/material.dart';
import 'package:geoestate/pages/home_page.dart';
import 'package:geoestate/provider/bank_provider.dart';
import 'package:geoestate/provider/dataset_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';

import '../provider/auth_provider.dart';
import '../provider/marker_provider.dart';
import 'login_page.dart';

class LoadingPage extends StatefulWidget {
  static const routeName = 'loading-page';
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDataAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white, size: 200),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Loading Data! Please wait...'),
                ],
              )
            : Text('Data Loaded'),
      ),
    );
  }

  Future<void> loadDataAndNavigate() async {
    try {
      print('Loading markers...');
      await context.read<MarkerProvider>().loadMarkers();
      print('Markers loaded');

      print('Loading banks...');
      await context.read<BankProvider>().loadBanks();
      print('Banks loaded');

      print('Loading datasets...');
      await context.read<DatasetProvider>().loadDatasets();
      print('Datasets loaded');

      if (context.read<MarkerProvider>().markers!.isNotEmpty &&
          context.read<BankProvider>().banks!.isNotEmpty &&
          context.read<DatasetProvider>().datasets!.isNotEmpty) {
        setState(() {
          isLoading = false;
        });
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
    } catch (e) {
      showRetryWindow(e.toString());
    }
  }

  void showRetryWindow(String error) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error loading data'),
          content: Text('Error loading data: ${error}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                loadDataAndNavigate();
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
    return;
  }
}
