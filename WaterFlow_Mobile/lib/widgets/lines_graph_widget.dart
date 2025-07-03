import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:waterflow_mobile/utils/constans_values/fontsize_constrant.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';

// A simple data model to hold a single point for the chart (X and Y values).
class ChartPoint {
  final String x;
  final double y;
  ChartPoint({required this.x, required this.y});
}

// A reusable widget to display a line graph using the Syncfusion Cartesian Chart.
class LinesGraphWidget extends StatelessWidget {
  // The title to be displayed above the chart.
  final String title;
  // The list of data points to be plotted on the chart.
  final List<ChartPoint> dataPoints;

  const LinesGraphWidget({
    super.key,
    required this.title,
    required this.dataPoints,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      // Sets the main title of the chart.
      title: ChartTitle(
          text: title,
          textStyle: const TextStyle(
              color: ThemeColor.primaryColor,
              fontSize: kFontsizeMedium,
              fontWeight: FontWeight.bold)),

      // Configures the horizontal (X) axis, treated as categories (e.g., dates or labels).
      primaryXAxis: const CategoryAxis(
        // Hides the vertical grid lines for a cleaner look.
        majorGridLines: MajorGridLines(width: 0),
        // Ensures labels are placed directly under their corresponding ticks.
        labelPlacement: LabelPlacement.onTicks,
      ),

      // Configures the vertical (Y) axis for numerical values.
      primaryYAxis: const NumericAxis(
        // Formats the axis labels to show the value followed by "L" (for Liters).
        labelFormat: '{value} L',
      ),

      // Enables an interactive trackball tooltip that appears on tap.
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        lineType: TrackballLineType.vertical,
        // Customizes the format of the text shown in the tooltip.
        tooltipSettings: const InteractiveTooltip(
            format: 'Dia: {point.x}\nConsumo: {point.y}'),
        // Creates a dashed line for the trackball.
        lineDashArray: const <double>[5, 5],
      ),

      // Defines the data series to be rendered on the chart.
      series: <CartesianSeries<ChartPoint, String>>[
        // Specifies that the data should be visualized as a line series.
        LineSeries<ChartPoint, String>(
          // Binds the list of data points to this series.
          dataSource: dataPoints,
          // Maps the 'x' and 'y' properties from our ChartPoint model to the chart's axes.
          xValueMapper: (ChartPoint data, _) => data.x,
          yValueMapper: (ChartPoint data, _) => data.y,
          color: ThemeColor.primaryColor,
          width: 3,
          // Adds a visible marker (a small circle) to each data point on the line.
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 8,
            width: 8,
            borderColor: ThemeColor.primaryColor,
            color: ThemeColor.whiteColor,
          ),
          // Hides data labels on the chart itself, as they are shown in the tooltip.
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        )
      ],
    );
  }
}