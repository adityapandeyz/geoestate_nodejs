import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';

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
                child: const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1584974292709-5c2f0619971b?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Version: 0.0.1+1',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        //textAlign: TextAlign.,
                      ),
                      // const Text(
                      //   'BETA Release',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w500,
                      //     fontSize: 11,
                      //   ),
                      //   //textAlign: TextAlign.,
                      // ),

                      // Container(
                      //   decoration: const BoxDecoration(
                      //     //borderRadius: BorderRadius.circular(10.0),
                      //     gradient: LinearGradient(
                      //       colors: [
                      //         Color.fromARGB(255, 57, 14, 177),
                      //         Color.fromARGB(255, 214, 9, 9),
                      //       ],
                      //     ),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Color.fromARGB(255, 0, 0, 0),
                      //       )
                      //     ],
                      //   ),
                      //   child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: SizedBox(
                      //         height: 100,
                      //         width: 100,
                      //         child: Image.asset(
                      //           'assets/logo/dot.-150x150.png',
                      //         ),
                      //       )),
                      // ),
                      SizedBox(height: 10),

                      Text(
                        'GeoEstate',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(height: 20),
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
