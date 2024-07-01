import 'package:flutter/material.dart';

class TopCurve extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height*0.75);

    path.quadraticBezierTo(
        size.width*0.25,
        size.height*0.5,
        size.width*0.5,
        size.height*0.75
    );

    path.quadraticBezierTo(
        size.width*0.75,
        size.height,
        size.width,
        size.height*0.75
    );

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BottomCurve extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();

    path.moveTo(0, size.height*0.25);

    path.quadraticBezierTo(
        size.width*0.25,
        0,
        size.width*0.5,
        size.height*0.25
    );

    path.quadraticBezierTo(
        size.width*0.75,
        size.height*0.5,
        size.width,
        size.height*0.25
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();


    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }

}