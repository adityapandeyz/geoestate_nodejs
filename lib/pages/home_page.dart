import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoestate/constants/global_variables.dart';
import 'package:geoestate/pages/dateset_page.dart';
import 'package:geoestate/pages/export_page.dart';
import 'package:geoestate/pages/login_page.dart';
import 'package:geoestate/pages/map_page.dart';
import 'package:geoestate/provider/auth_provider.dart';
import 'package:geoestate/services/auth_services.dart';
import 'package:geoestate/widgets/app_logo.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();

  @override
  void initState() {
    authService.getUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0, top: 8, bottom: 8, right: 0),
          child: CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage(
              'assets/IconKitchen-Output/web/icon-512.png',
            ),
          ),
        ),
        title: const AppLogo(
          size: 26,
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     // Navigator.of(context).push(
          //     //   MaterialPageRoute(
          //     //     builder: (_) => const QrScannerScreen(),
          //     //   ),
          //     // );
          //   },
          //   icon: const Icon(
          //     FontAwesomeIcons.qrcode,
          //     size: 16,
          //   ),
          // ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/about');
            },
            icon: const Icon(
              FontAwesomeIcons.info,
              size: 16,
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<AuthProvider>().user.token;
              Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
            },
            icon: const Icon(
              FontAwesomeIcons.signOut,
              size: 16,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                width: double.infinity,
                height: 300,
                child: Image(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(
                    'assets/images/egor-myznik-hyUnY1oXthA-unsplash.jpg',
                  ),
                ),
              ),

              SizedBox(
                width: 600,
                //MediaQuery.of(context).size.width * 0.40,
                child: Column(
                  children: [
                    GridView.count(
                      primary: false,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              MapPage.routeName,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: AppColors.primaryColor,
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Icon(
                                  FontAwesomeIcons.earthAsia,
                                  size: 50,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Map'),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              DatasetPage.routeName,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: AppColors.primaryColor,
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Icon(
                                  FontAwesomeIcons.database,
                                  size: 50,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Datasets'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ExportExcelPage.routeName,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        padding: const EdgeInsets.all(8),
                        color: AppColors.primaryColor,
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Icon(
                              FontAwesomeIcons.fileExport,
                              size: 50,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Export Datasets'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const AppLogo(
                color: Color.fromARGB(110, 99, 99, 99),
              ),
              const Text(
                'Copyright © 2024. All Right Reserved.',
                style: TextStyle(
                  color: Color.fromARGB(179, 99, 99, 99),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //           Container(
              //             padding: const EdgeInsets.all(8),
              //             color: Colors.teal[400],
              //             child: const Padding(
              //               padding: EdgeInsets.all(8.0),
              //               child: Column(
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   Text("""
              // As our phone moves through the world, ARCore uses a process called simultaneous localization and mapping, or SLAM, to understand where the phone is relative to the world around it. ARCore detects visually distinct features in the captured camera image called feature points and uses these points to compute its change in location. The visual information is combined with inertial measurements from the device's IMU to estimate the pose (position and orientation) of the camera relative to the world over time.
              //             """)
              //                 ],
              //               ),
              //             ),
              //           ),
              //           const SizedBox(
              //             height: 10,
              //           ),
              //           Container(
              //             padding: const EdgeInsets.all(8),
              //             color: Colors.teal[400],
              //             child: const Padding(
              //               padding: EdgeInsets.all(8.0),
              //               child: Column(
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   Text("""
              // An inertial measurement unit (IMU) is an electronic device that measures and reports a body's specific force, angular rate, and sometimes the orientation of the body, using a combination of accelerometers, gyroscopes, and sometimes magnetometers. When the magnetometer is included, IMUs are referred to as IMMUs.
              //             """)
              //                 ],
              //               ),
              //             ),
              //           ),
            ],
          ),
        ),
      ),
    );
  }
}
