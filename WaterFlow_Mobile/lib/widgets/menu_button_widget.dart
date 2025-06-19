import 'package:flutter/material.dart';
import 'package:waterflow_mobile/utils/constans_values/fontsize_constrant.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';

// Widget to create a menu button
class MenuButtonWidget extends StatelessWidget {
  /// Creates a menu button with an icon and label.
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isSelected;

  const MenuButtonWidget(
      {super.key,
      required this.icon,
      required this.label,
      this.onPressed,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const Color color = ThemeColor.whiteColor;

    // Return an InkWell widget to handle taps
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: color),
          Text(
            label,
            style: const TextStyle(
                fontSize: kFontsizeStandard, color: ThemeColor.whiteColor),
          )
        ],
      ),
    );
  }
}
