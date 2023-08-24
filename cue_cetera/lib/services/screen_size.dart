import 'package:flutter/material.dart';

// idea and implementation for this file found here:
// https://medium.com/tagmalogic/widgets-sizes-relative-to-screen-size-in-flutter-using-mediaquery-3f283afc64d6

Size screenSize(BuildContext ctx) {
  return MediaQuery.of(ctx).size;
}

double screenHeight(BuildContext ctx) {
  return screenSize(ctx).height;
}

double screenWidth(BuildContext ctx) {
  return screenSize(ctx).width;
}