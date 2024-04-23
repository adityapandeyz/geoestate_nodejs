import 'package:flutter/material.dart';

class CustomPage extends StatefulWidget {
  final String pageTitle;
  final bool showBack;
  final bool showLogout;
  final Widget sidebar;
  final Widget content;
  final bool changeContent;
  final List<Widget> actions;

  const CustomPage({
    super.key,
    required this.sidebar,
    this.pageTitle = 'GeoEstate (DEMO)',
    this.showLogout = false,
    this.showBack = true,
    this.content = const SizedBox(),
    this.changeContent = false,
    this.actions = const [],
  });

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 6,
        toolbarHeight: 50,
        // backgroundColor: Colors.white,
        title: Text(widget.pageTitle),
        actions: widget.actions,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.changeContent == false
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple,
                            Colors.blue,
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                    ),
                    Container(
                      height: 600,
                      width: 600,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/egor-myznik-hyUnY1oXthA-unsplash.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )
              : widget.content,
          // widget.showBack == true
          //     ? Align(
          //         alignment: Alignment.topLeft,
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: CustomButton(
          //             text: 'Back',
          //             onClick: () {
          //               Navigator.of(context).pop();
          //             },
          //           ),
          //         ),
          //       )
          //     : const SizedBox(),
          Expanded(child: widget.sidebar),
        ],
      ),
    );
  }
}
