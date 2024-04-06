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
import 'home_page.dart';

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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final _loginFormKey = GlobalKey<FormState>();

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
                      child: Image.network(
                        'https://images.unsplash.com/photo-1522678073884-26b1b87526e4?q=80&w=2135&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
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
                      const AppLogo(),
                      const Text(
                        "Geo tagging platform.",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
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
                                    ontap: () async {
                                      HapticFeedback.vibrate();

                                      if (_loginFormKey.currentState!
                                          .validate()) {
                                        try {
                                          await AuthService.login(
                                            context: context,
                                            email: emailController.text.trim(),
                                            password:
                                                passwordController.text.trim(),
                                          );
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            HomePage.routeName,
                                            (route) => false,
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '$e',
                                              ),
                                            ),
                                          );
                                        }
                                      }
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
