import 'package:flutter/material.dart';
import 'package:waterflow_mobile/utils/constans_values/radius_constants.dart';

// Widget to create a IconButton
class IconButtonWidget extends StatelessWidget {
  // Parameters to create button
  final Function() onTap;
  final Color? backColor;
  final Color iconColor;
  final Icon icon;
  final double? width;
  final double? height;

  // Constructor
  const IconButtonWidget(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.iconColor,
      this.backColor,
      this.width,
      this.height,});

  // Build the button
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Size of the button
      width: width,
      height: height,

      // Body of the button
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(kRadiusButtonAndFields),
        ),
        child: IconButton(onPressed: onTap, icon: icon, color: iconColor),
      ),
    );
  }
}
