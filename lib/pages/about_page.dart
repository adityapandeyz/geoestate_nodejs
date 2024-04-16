import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:geoestate/widgets/app_logo.dart';

class AboutPage extends StatelessWidget {
  static const String routeName = '/about';

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: Center(
        child: SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Positioned(
                top: 200,
                left: 10,
                child: GradientBall(
                  colors: [
                    Colors.deepOrange,
                    Colors.amber,
                  ],
                ),
              ),
              const Positioned(
                top: 400,
                right: 10,
                child: GradientBall(
                  size: Size.square(200),
                  colors: [Colors.blue, Colors.purple],
                ),
              ),
              BlurryContainer(
                color: Colors.white.withOpacity(0.15),
                blur: 8,
                elevation: 6,
                padding: const EdgeInsets.all(32),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/IconKitchen-Output/web/icon-512.png',
                        height: 80,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        width: 100,
                        child: AppLogo(),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Version: 0.0.5+1',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        //textAlign: TextAlign.,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'GeoEstate',
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Copyright © 2024. All Right Reserved.',
                        style: TextStyle(
                          color: Color.fromARGB(200, 177, 175, 175),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradientBall extends StatelessWidget {
  final List<Color> colors;
  final Size size;
  const GradientBall({
    Key? key,
    required this.colors,
    this.size = const Size.square(150),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors,
        ),
      ),
    );
  }
}
