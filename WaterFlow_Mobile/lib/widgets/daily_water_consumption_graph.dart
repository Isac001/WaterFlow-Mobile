import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';

// Holds the data for a single chart slice.
class _ChartData {
  final String x;
  final double y;
  final Color color;
  _ChartData({required this.x, required this.y, required this.color});
}

// A reusable doughnut chart widget.
class PizzaWaterConsumptionGraph extends StatelessWidget {
  // Widget settings
  final String title;
  final double consumedValue;
  final String consumedLabel;
  final String unit;

  // Constructor
  const PizzaWaterConsumptionGraph({
    super.key,
    required this.title,
    required this.consumedValue,
    this.consumedLabel = 'Consumo Total',
    this.unit = 'L/m3',
  });

  @override
  Widget build(BuildContext context) {
    // Data source for the chart.
    final List<_ChartData> chartData = [
      _ChartData(
        x: consumedLabel,
        y: consumedValue,
        color: ThemeColor.secondaryColor,
      ),
    ];

    return SfCircularChart(
      title: ChartTitle(text: title),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom), 

      // Shows the value and unit in the middle of the chart.
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                consumedValue.toStringAsFixed(1), 
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.secondaryColor,
                ),
              ),
              Text(
                unit,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          radius: '0%', // Puts the annotation in the center.
        )
      ],

      // Defines how to draw the data on the chart.
      series: <CircularSeries<_ChartData, String>>[
        DoughnutSeries<_ChartData, String>(
          // Connects our data fields (x, y, color) to the chart.
          dataSource: chartData,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
          pointColorMapper: (_ChartData data, _) => data.color,
          
          // The hole in the center, makes it a doughnut.
          innerRadius: '70%', 
          // Hides the labels on the slices.
          dataLabelSettings: const DataLabelSettings(isVisible: false), 
        )
      ],
    );
  }
}