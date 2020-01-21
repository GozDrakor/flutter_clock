import 'package:flutter/material.dart';

enum clockStyle {
  background,
  text,
  shadow,
}

final lightTheme = {
  clockStyle.background: Color(0x55FFFFFF),
  clockStyle.text: Colors.white,
  clockStyle.shadow: Colors.black,
};

final darkTheme = {
  clockStyle.background: Color(0x55000000),
  clockStyle.text: Colors.white,
  clockStyle.shadow: Color(0xFF174EA6),
};
