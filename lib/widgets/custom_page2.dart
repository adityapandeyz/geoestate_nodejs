import 'package:flutter/material.dart';

class CustomPage2 extends StatefulWidget {
  final String pageTitle;
  final bool showBack;
  final bool showLogout;
  final Widget sidebar;
  final bool changeContent;
  final List<Widget> actions;
  final double height;

  final VoidCallback? onRefresh;

  const CustomPage2({
    super.key,
    required this.sidebar,
    this.pageTitle = 'GeoEstate',
    this.showLogout = false,
    this.showBack = true,
    this.changeContent = false,
    this.actions = const [],
    this.height = 800,
    this.onRefresh,
  });

  @override
  State<CustomPage2> createState() => _CustomPage2State();
}

class _CustomPage2State extends State<CustomPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
        actions: widget.actions,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/egor-myznik-hyUnY1oXthA-unsplash.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(),
          ),
          Center(
            child: SizedBox(
              height: widget.height,
              width: 600,
              child: Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: widget.sidebar,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
