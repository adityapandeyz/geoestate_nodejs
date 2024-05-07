import 'package:flutter/material.dart';

class ColorInfo {
  final String name;
  final String info;

  ColorInfo({this.name = 'White', this.info = "White",});

  ColorInfo getColorInfo(Color color) {
    return colorInfos[color.value] ?? ColorInfo(name:'Unknown', info: 'Unknown');
  }

    final Map<int, ColorInfo> colorInfos = {
    Colors.white.value: ColorInfo(name: 'White',info:  'White'),
    Colors.red.value: ColorInfo(name:'Red', info:'Red'),
    Colors.green.value: ColorInfo(name:'Green', info:'Green'),
    Colors.blue.value: ColorInfo(name:'Blue', info:'Blue'),
    Colors.yellow.value: ColorInfo(name:'Yellow', info:'Yellow'),
    Colors.orange.value: ColorInfo(name:'Orange',info: 'Orange'),
    Colors.purple.value: ColorInfo(name:'Purple',info: 'Purple'),
    Colors.indigo.value: ColorInfo(name:'Indigo', info:'Indigo'),
    Colors.grey.value: ColorInfo(name: "Grey" ,info: "Grey"),
    Colors.brown.value: ColorInfo(name: "Brown", info: "Brown"),
    Colors.amber.value: ColorInfo(name: "Amber", info: "Amber"),
    Colors.lime.value: ColorInfo(name: "Lime", info: "Lime"),
    Colors.cyan.value: ColorInfo(name:"Cyan", info: "Cyan")
  };

}

