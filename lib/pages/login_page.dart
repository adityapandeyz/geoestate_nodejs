import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoestate/services/auth_services.dart';
import 'package:geoestate/widgets/custom_icon_button.dart';
import 'package:geoestate/widgets/custom_textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../constants/global_variables.dart';
import '../widgets/app_logo.dart';
import '../widgets/inner_shadow_mod.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login-page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final dio = Dio();

  var isSignInButtonClicked = false;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final _loginFormKey = GlobalKey<FormState>();

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    HapticFeedback.vibrate();

    if (_loginFormKey.currentState!.validate()) {
      try {
        await AuthService.login(
          context: context,
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$e',
            ),
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(builder: (context, provider, child) {
        return Stack(
          alignment: screenWidth < MediaQuery.of(context).size.width
              ? AlignmentDirectional.center
              : AlignmentDirectional.bottomCenter,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    InnerShadowMod(
                      child: Image.asset(
                        'assets/images/egor-myznik-hyUnY1oXthA-unsplash.jpg',
                        fit: BoxFit.cover,
                        //  height: double.infinity,
                        height: screenWidth < MediaQuery.of(context).size.width
                            ? MediaQuery.of(context).size.height * 1
                            : MediaQuery.of(context).size.height * 0.6,
                        width: double.infinity,
                      ),
                    ),
                    const SafeArea(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 20.0,
                          top: 20,
                        ),
                        child: AppLogo(),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.width * 1,
              // screenWidth < MediaQuery.of(context).size.width ? 500 : 480,
              width: screenWidth < MediaQuery.of(context).size.width
                  ? 600
                  : double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.greyBackColor,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/IconKitchen-Output/web/icon-512.png',
                        height: 80,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const AppLogo(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      const Text(
                        'Copyright © 2024. All Right Reserved.',
                        style: TextStyle(
                          color: Color.fromARGB(200, 177, 175, 175),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      isSignInButtonClicked == false
                          ? CustomIconButton(
                              icon: FontAwesomeIcons.arrowRight,
                              ontap: () {
                                HapticFeedback.vibrate();
                                setState(() {
                                  isSignInButtonClicked = true;
                                });
                              },
                              text: 'Continue',
                            )
                          : Form(
                              key: _loginFormKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextfield(
                                    title: 'Email',
                                    controller: emailController,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomTextfield(
                                    title: 'Password',
                                    isPass: true,
                                    controller: passwordController,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomIconButton(
                                    icon: FontAwesomeIcons.user,
                                    isLoading: _isLoading,
                                    ontap: () async {
                                      loginUser();
                                    },
                                    text: 'Login',
                                  ),
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  // CustomIconButton(
                                  //   icon: FontAwesomeIcons.userPlus,
                                  //   ontap: () async {
                                  //     HapticFeedback.vibrate();
                                  //     if (_loginFormKey.currentState!
                                  //         .validate()) {
                                  //       try {
                                  //         // await provider.createUser(
                                  //         //   context,
                                  //         //   emailController.text.trim(),
                                  //         //   passwordController.text.trim(),
                                  //         // );
                                  //         Navigator.of(context)
                                  //             .pushNamedAndRemoveUntil(
                                  //           HomePage.routeName,
                                  //           (route) => false,
                                  //         );
                                  //       } catch (e) {
                                  //         ScaffoldMessenger.of(context)
                                  //             .showSnackBar(
                                  //           SnackBar(
                                  //             content: Text(
                                  //               '$e',
                                  //             ),
                                  //           ),
                                  //         );
                                  //       }
                                  //     }
                                  //   },
                                  //   text: 'Create User',
                                  // )
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      isSignInButtonClicked
                          ? const SizedBox()
                          : Text(
                              'By signing in, you agree to our Privacy Policy and Terms of Service.',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
