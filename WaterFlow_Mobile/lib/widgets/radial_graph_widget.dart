import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:waterflow_mobile/utils/constans_values/fontsize_constrant.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';

class RadialGraphWidget extends StatelessWidget {
  // Component parameters
  final double currentValue;
  final double maxValue;
  final String unit;

  // Constructor to initialize the component with required parameters
  const RadialGraphWidget({
    super.key,
    required this.currentValue,
    this.maxValue = 300,
    this.unit = 'L/s'});

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(

      // Setting the gauge properties
      axes: <RadialAxis> [

        // Radial axis to display the gauge
        RadialAxis(
          minimum:  0,
          maximum: maxValue,
          showLastLabel: true,
          showLabels: true,
          showTicks: true,
          interval: 20,

          // Setting the axis label style
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              positionFactor: 0.1,
              angle: 90,
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                 Text(currentValue.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: kFontsizeXXLarge,
                      fontWeight: FontWeight.bold,
                      color: ThemeColor.secondaryColor
                    )
                  ),
                  Text(
                    unit,
                    style: const TextStyle(
                      fontSize: kFontsizeLarge,
                      fontWeight: FontWeight.bold,
                      color: ThemeColor.secondaryColor
                    )
                  ),
                ],
              ),
            )
          ],

          // Setting the gauge pointers
          pointers: <GaugePointer>[
            RangePointer(
              value:  currentValue,
              width: 10,
              color: ThemeColor.primaryColor,
              cornerStyle: CornerStyle.bothCurve,
              enableAnimation: true,
              animationDuration: 10000,
            )
          ],
        )
      ]
    );
  }
}
