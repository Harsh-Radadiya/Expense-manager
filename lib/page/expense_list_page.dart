import 'package:collection/collection.dart';
import 'package:expencemanager/controllers/expance_controller.dart';
import 'package:expencemanager/utils/sorting_utils.dart';
import 'package:expencemanager/widgets/daycategorydata_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:expencemanager/model/expense_data_model.dart';
import 'package:expencemanager/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'sample_view_model.dart';
// import 'package:intl/intl.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({Key? key}) : super(key: key);

  @override
  _ExpenseListPageState createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  ExpenceController expenceController = Get.find();

  // Box<ExpenseDataModel>? expenseListdataBox;
  // Box<CategoryExpenseModel>? categoryDataBox;
  Map<String, List<ExpenseDataModel>>? userDataMapDemo;
  List tabName = [];

  @override
  void initState() {
    // expenseListdataBox = Hive.box<ExpenseDataModel>(expenseDataBoxName);
    // categoryDataBox = Hive.box<CategoryExpenseModel>(categoryDataBoxName);
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: tabName.length,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Expenses'),
            bottom: TabBar(
                isScrollable: true,
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: Colors.red, width: 3),
                    insets:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 0)),
                tabs: tabName.map((groupKey) {
                  return Tab(child: Text(Utils.getMonthString(groupKey)));
                }).toList()),

            // <Widget>[
            //   Tab(child: Text('June')),
            //   Tab(child: Text('July')),
            //   Tab(child: Text('August')),
            // ],
          ),
          body: ValueListenableBuilder(
              valueListenable:
                  expenceController.expenseListdataBox!.listenable(),
              builder: (context, Box<ExpenseDataModel> items, _) {
                return TabBarView(
                    children: tabName.map((groupKey) {
                  return tab(groupKey);
                }).toList());
              })),
    );
  }

  // for tabs
  Widget tab(groupKey) {
    getData();
    //chart Data
    List<ChartSampleData> chartData = <ChartSampleData>[];
    List<DoughnutSeries<ChartSampleData, String>> _getDefaultDoughnutSeries() {
      return <DoughnutSeries<ChartSampleData, String>>[
        DoughnutSeries<ChartSampleData, String>(
            radius: '80%',
            explode: true,
            explodeOffset: '10%',
            dataSource: chartData,
            xValueMapper: (ChartSampleData data, _) => data.x as String,
            yValueMapper: (ChartSampleData data, _) => data.y,
            dataLabelMapper: (ChartSampleData data, _) => data.text,
            dataLabelSettings: const DataLabelSettings(isVisible: true))
      ];
    }

    chartData = HiveSortUtils()
        .getMonthWiseChartData(userDataMapDemo![groupKey]!.first.dataKey);
    List<ExpenseDataModel>? groupData = userDataMapDemo![groupKey];
    // Map<String, List<ExpenseDataModel>>? boxValueList;
    // boxValueList = groupBy(groupData!, (e) => e.dataKey);
    Map<String, List<ExpenseDataModel>>? userDataMap;
    userDataMap = groupBy(groupData!, (a) => a.date);

    // print(groupData);
    // Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          //chart
          SfCircularChart(
            title: ChartTitle(
                text:
                    'Monthly Expenses ${HiveSortUtils().getTotalOfExpenceMonth(groupData[0].dataKey)}'),
            legend: Legend(
                isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
            series: _getDefaultDoughnutSeries(),
            tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x'),
          ),
          //
          SizedBox(height: 10),
          // ValueListenableBuilder(
          //   valueListenable: gropData!.is,
          //   builder: (context, Box<ExpenseDataModel> items, _) {
          //     List<ExpenseDataModel> boxValueList = items.values.toList();
          //     boxValueList.sort((a, b) => b.dataKey.compareTo(a.dataKey));
          //     userDataMap = groupBy(boxValueList, (a) => a.date);
          // if (userDataMap!.isEmpty) {
          //   return Center(
          //     child: Center(
          //       child: Text('No Data'),
          //     ),
          //   );
          // }
          // return

          DayCategoryDataWidget(
            userDataMap: userDataMap,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  getData() {
    // ValueListenable listen() => expenseListdataBox!.listenable();
    // print(listen().value.toList);
    List<ExpenseDataModel> boxValueList =
        expenceController.expenseListdataBox!.values.toList();
    boxValueList.sort((a, b) => b.dataKey.compareTo(a.dataKey));
    userDataMapDemo = groupBy(boxValueList, (a) => a.dataKey.substring(0, 7));
    // print(userDataMapDemo);
    tabName = userDataMapDemo!.keys.toList();
    // for (var i = 0; i < userDataMapDemo!.keys.length; i++) {
    //   tabName.add(Utils.getMonthString(userDataMapDemo!.keys.toList()[0]));
    // }

    // print("tabName${userDataMapDemo![tabName[1]]}");
    // setState(() {});
    
  }
}
