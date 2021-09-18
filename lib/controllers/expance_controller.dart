import 'package:collection/collection.dart';
import 'package:expencemanager/model/category_model.dart';
import 'package:expencemanager/model/expense_data_model.dart';
import 'package:expencemanager/utils/constant.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ExpenceController extends GetxController {
  var userDataMapDemo = Map<String, List<ExpenseDataModel>>().obs;
  Box<ExpenseDataModel>? expenseListdataBox;
  Box<CategoryExpenseModel>? categoryDataBox;

  var tabName = [].obs;

  @override
  void onInit() {
    super.onInit();
    expenseListdataBox = Hive.box<ExpenseDataModel>(expenseDataBoxName);
    categoryDataBox = Hive.box<CategoryExpenseModel>(categoryDataBoxName);

    List<ExpenseDataModel> boxValueList = expenseListdataBox!.values.toList();
    boxValueList.sort((a, b) => b.dataKey.compareTo(a.dataKey));
    userDataMapDemo.value =
        groupBy(boxValueList, (a) => a.dataKey.substring(0, 7));
    tabName.value = userDataMapDemo.keys.toList();
  }
}
