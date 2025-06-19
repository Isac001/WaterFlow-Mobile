
import 'package:flutter/cupertino.dart';


/// CLASS TO CREATE THE TRIANGULAR SHAPE
class TriangleClipper extends CustomClipper<Path> {
  final bool isTopCorner;

  TriangleClipper({this.isTopCorner = true});

  @override

  Path getClip(Size size) {
    final path = Path();

    if (isTopCorner) {
      // Triangle for the top-left corner
      path.lineTo(size.width, 0.0);
      path.lineTo(0.0, size.height);
      path.close();
    } else {
      // Triangle for the bottom-right corner
      path.moveTo(size.width, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
