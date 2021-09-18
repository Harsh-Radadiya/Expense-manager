import 'package:collection/collection.dart';
import 'package:expencemanager/controllers/expance_controller.dart';
import 'package:expencemanager/model/category_model.dart';
import 'package:expencemanager/model/expense_data_model.dart';
import 'package:expencemanager/page/sample_view_model.dart';
import 'package:get/get.dart';

class HiveSortUtils {
  ExpenceController expenceController = Get.find();

  // Box<CategoryExpenseModel>? categoryDataBox =
  //     Hive.box<CategoryExpenseModel>(categoryDataBoxName);

  // Box<ExpenseDataModel>? expenseListdataBox =
  //     Hive.box<ExpenseDataModel>(expenseDataBoxName);

  sortExpenses(List<ExpenseDataModel> boxValueList) {
    if (boxValueList.isNotEmpty) {
      Map<String, List<ExpenseDataModel>>? sortByCategoryId =
          groupBy(boxValueList, (a) => a.categoryExpenseId.toString());
      print(sortByCategoryId);
      for (var i = 0; i < sortByCategoryId.length; i++) {
        CategoryExpenseModel chartTitle = getCatogoryName(
            sortByCategoryId.values.toList()[i][0].categoryExpenseId);
        // print(chartTitle.categoryTitle);
        for (var j = 0; j < sortByCategoryId.values.length; j++) {}
      }
      return boxValueList;
    }
  }

  getCatogoryName(int id) {
    return expenceController.categoryDataBox!.get(id);
  }

  getTotalOfExpence() {
    if (expenceController.expenseListdataBox!.values.toList().isNotEmpty) {
      double sum = 0.0;
      for (var i = 0;
          i < expenceController.expenseListdataBox!.values.toList().length;
          i++) {
        sum += double.parse(
            expenceController.expenseListdataBox!.values.toList()[i].price);
      }
      return sum;
    }
  }

  getTotalOfExpenceMonth(String dataKey) {
    String key = dataKey.substring(0, 7); //[2021-07]

    if (expenceController.expenseListdataBox!.values.toList().isNotEmpty) {
      double sum = 0.0;
      Map<String, List<ExpenseDataModel>>? userDataAccordingMonthList;
      List<ExpenseDataModel> boxValueList =
          expenceController.expenseListdataBox!.values.toList();
      boxValueList.sort((a, b) => b.dataKey.compareTo(a.dataKey));
      userDataAccordingMonthList =
          groupBy(boxValueList, (a) => a.dataKey.substring(0, 7));

      for (var i = 0; i < userDataAccordingMonthList[key]!.length; i++) {
        sum += double.parse(userDataAccordingMonthList[key]![i].price);
      }
      return sum;
    }
  }

  getTotalOfExpenceYear(String dataKey) {
    String key = dataKey.substring(0, 4); //[2021]
    print(key);

    if (expenceController.expenseListdataBox!.values.toList().isNotEmpty) {
      double sum = 0.0;
      Map<String, List<ExpenseDataModel>>? userDataAccordingMonthList;
      List<ExpenseDataModel> boxValueList =
          expenceController.expenseListdataBox!.values.toList();
      boxValueList.sort((a, b) => b.dataKey.compareTo(a.dataKey));
      userDataAccordingMonthList =
          groupBy(boxValueList, (a) => a.dataKey.substring(0, 4));
      // print(userDataAccordingMonthList);

      for (var i = 0; i < userDataAccordingMonthList[key]!.length; i++) {
        sum += double.parse(userDataAccordingMonthList[key]![i].price);
      }
      return sum;
    }
  }

  getMonthWiseChartData(String dataKey) {
    String key = dataKey.substring(0, 7); //[2021-07]
    // String key = '2021-07';
    // print("month wise chart data" + dataKey);

    if (expenceController.expenseListdataBox!.values.toList().isNotEmpty) {
      double totalMonthSum = getTotalOfExpenceMonth(dataKey);
      Map<String, List<ExpenseDataModel>>? userDataAccordingMonthList;
      Map<String, List<ExpenseDataModel>>? monthChartData;
      List<ExpenseDataModel> boxValueList =
          expenceController.expenseListdataBox!.values.toList();
      boxValueList.sort((a, b) => b.dataKey.compareTo(a.dataKey));
      userDataAccordingMonthList =
          groupBy(boxValueList, (a) => a.dataKey.substring(0, 7));
      monthChartData = groupBy(userDataAccordingMonthList[key]!,
          (a) => a.categoryExpenseId.toString());

      // print(monthChartData);
      List<ChartSampleData> chartData = <ChartSampleData>[
        // ChartSampleData(x: 'Food', y: 55, text: '55%'),
        // ChartSampleData(x: 'Flight', y: 31, text: '31%'),
        // ChartSampleData(x: 'Taxi', y: 7.7, text: '7.7%'),
      ];
      List chartDataKey = monthChartData.keys.toList();
      for (var i = 0; i < monthChartData.keys.length; i++) {
        List<ExpenseDataModel>? monthSpecCategoryDataList =
            monthChartData[chartDataKey[i]];
        double monthSpecCategorySum = 0.0;
        for (var j = 0; j < monthSpecCategoryDataList!.length; j++) {
          monthSpecCategorySum +=
              double.parse(monthSpecCategoryDataList[j].price);
        }
        var percentage = double.parse(
            ((monthSpecCategorySum / totalMonthSum) * 100).toStringAsFixed(2));

        CategoryExpenseModel categoryExpenseModel =
            getCatogoryName(int.parse(chartDataKey[i]));

        chartData.add(ChartSampleData(
            x: categoryExpenseModel.categoryTitle +
                ' ' +
                '\$' +
                monthSpecCategorySum.ceil().toString(),
            y: percentage,
            text: categoryExpenseModel.categoryTitle));
      }
      // print(chartData[0].x);

      return chartData;
    }
  }

  getYearWiseChartData(String dataKey) {
    String key = dataKey.substring(0, 4); //[2021-07]
    // String key = '2021-07';
    print("Year chartData" + dataKey.toString());

    if (expenceController.expenseListdataBox!.values.toList().isNotEmpty) {
      double totalMonthSum = getTotalOfExpenceYear(dataKey);
      Map<String, List<ExpenseDataModel>>? userDataAccordingYearList;
      Map<String, List<ExpenseDataModel>>? yearChartData;
      List<ExpenseDataModel> boxValueList =
          expenceController.expenseListdataBox!.values.toList();
      boxValueList.sort((a, b) => b.dataKey.compareTo(a.dataKey));
      userDataAccordingYearList =
          groupBy(boxValueList, (a) => a.dataKey.substring(0, 4));
      yearChartData = groupBy(userDataAccordingYearList[key]!,
          (a) => a.categoryExpenseId.toString());

      print(yearChartData);
      List<ChartSampleData> chartData = <ChartSampleData>[
        // ChartSampleData(x: 'Food', y: 55, text: '55%'),
        // ChartSampleData(x: 'Flight', y: 31, text: '31%'),
        // ChartSampleData(x: 'Taxi', y: 7.7, text: '7.7%'),
      ];
      List chartDataKey = yearChartData.keys.toList();
      for (var i = 0; i < yearChartData.keys.length; i++) {
        List<ExpenseDataModel>? yearSpecCategoryDataList =
            yearChartData[chartDataKey[i]];
        double yearSpecCategorySum = 0.0;
        for (var j = 0; j < yearSpecCategoryDataList!.length; j++) {
          yearSpecCategorySum +=
              double.parse(yearSpecCategoryDataList[j].price);
        }
        var percentage = double.parse(
            ((yearSpecCategorySum / totalMonthSum) * 100).toStringAsFixed(2));

        CategoryExpenseModel categoryExpenseModel =
            getCatogoryName(int.parse(chartDataKey[i]));

        chartData.add(ChartSampleData(
            x: categoryExpenseModel.categoryTitle +
                ' ' +
                '\$' +
                yearSpecCategorySum.toString(),
            y: percentage,
            text: categoryExpenseModel.categoryTitle));
      }

      return chartData;
    }
  }
}
