import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoestate/pages/splash_page.dart';
import 'package:geoestate/provider/auth_provider.dart';
import 'package:geoestate/router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'provider/bank_provider.dart';
import 'provider/dataset_provider.dart';
import 'provider/marker_provider.dart';
import 'constants/global_variables.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MarkerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DatasetProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BankProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GeoEstate',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.backgroundColor,
          primaryColor: AppColors.primaryColor,
          textTheme: TextTheme(
            bodyLarge: GoogleFonts.getFont('Montserrat'),
            bodyMedium: GoogleFonts.getFont('Montserrat'),
            bodySmall: GoogleFonts.getFont('Montserrat'),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color.fromARGB(255, 0, 0, 0),
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light,
            ),
            elevation: 0,
            centerTitle: false,
            // color: secondaryColor,
            titleTextStyle: GoogleFonts.getFont(
              'Montserrat',
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        scaffoldMessengerKey: _scaffoldMessengerKey,
        onGenerateRoute: (settings) => generateRoute(settings),
        home: const SplashPage(),
      ),
    );
  }
}
