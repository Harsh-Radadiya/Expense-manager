import 'package:expencemanager/controllers/expance_controller.dart';
import 'package:expencemanager/page/sample_view_model.dart';
import 'package:expencemanager/utils/sorting_utils.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWidget extends StatelessWidget {
  ChartWidget(
      {required this.chartData,
      required this.chartCategory,
      required this.expenceController});
  final List<ChartSampleData> chartData;
  final String chartCategory;
  final ExpenceController expenceController;

  List<DoughnutSeries<ChartSampleData, String>> _getDoughnutSeries() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          radius: '80%',
          explode: true,
          explodeOffset: '10%',
          dataSource: chartData,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ))
    ];
  }



  @override
  Widget build(BuildContext context) {
    if (chartCategory == 'year') {
      return SfCircularChart(
        title: ChartTitle(
            text:
                'Yearly Expenses ${expenceController.expenseListdataBox!.values.toList().last.dataKey.substring(0, 4)} is ${HiveSortUtils().getTotalOfExpenceYear(expenceController.expenseListdataBox!.values.toList().last.dataKey)}'),
        legend:
            Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        series: _getDoughnutSeries(),
        tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x'),
      );
    } else if (chartCategory == 'month') {
      return SfCircularChart(
        title: ChartTitle(
            text:
                'Monthly Expenses ${expenceController.expenseListdataBox!.values.toList().last.dataKey.substring(0, 7)} is ${HiveSortUtils().getTotalOfExpenceMonth(expenceController.expenseListdataBox!.values.toList().last.dataKey)}'),
        legend:
            Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        series: _getDoughnutSeries(),
        tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x'),
      );
    } else {
      return Text('No Chart Data Available');
    }
  }
}
