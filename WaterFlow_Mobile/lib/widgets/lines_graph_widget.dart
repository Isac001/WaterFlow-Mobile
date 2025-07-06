
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:waterflow_mobile/utils/constans_values/fontsize_constrant.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';

class ChartPoint {
  final String x;
  final double y;
  ChartPoint({required this.x, required this.y});
}

class LinesGraphWidget extends StatelessWidget {
  final String title;
  final List<ChartPoint> dataPoints;

  const LinesGraphWidget({
    super.key,
    required this.title,
    required this.dataPoints,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      // SUGESTÃO 2: Adiciona margem inferior para dar espaço aos rótulos.
margin: const EdgeInsets.only(bottom: 30),      
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enablePinching: true,
        zoomMode: ZoomMode.x,
      ),
      title: ChartTitle(
          text: title,
          textStyle: const TextStyle(
              color: ThemeColor.primaryColor,
              fontSize: kFontsizeMedium,
              fontWeight: FontWeight.bold)),
      
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelPlacement: LabelPlacement.onTicks,
        interval: 1,
        labelRotation: -45,

        // SUGESTÃO 1: Ajustes de posicionamento e estilo.
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelStyle: TextStyle(
          color: Colors.black, // Use a cor que se encaixa no seu tema
          fontSize: 10,
        ),
      ),

      primaryYAxis: const NumericAxis(
        labelFormat: '{value} L',
      ),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        lineType: TrackballLineType.vertical,
        tooltipSettings: const InteractiveTooltip(
            format: 'Período: {point.x}\nConsumo: {point.y} L'),
        lineDashArray: const <double>[5, 5],
      ),
      series: <CartesianSeries<ChartPoint, String>>[
        LineSeries<ChartPoint, String>(
          dataSource: dataPoints,
          xValueMapper: (ChartPoint data, _) => data.x,
          yValueMapper: (ChartPoint data, _) => data.y,
          color: ThemeColor.primaryColor,
          width: 3,
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 8,
            width: 8,
            borderColor: ThemeColor.primaryColor,
            color: ThemeColor.whiteColor,
          ),
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        )
      ],
    );
  }
}