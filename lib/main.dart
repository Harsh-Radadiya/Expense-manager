import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:expencemanager/page/myhomepage.dart';
import 'package:expencemanager/router/router.dart';
import 'package:expencemanager/utils/constant.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:sizer/sizer.dart';

import 'model/category_model.dart';
import 'model/expense_data_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory? appDocumentDir = await path.getApplicationDocumentsDirectory();
  Hive
    ..init(appDocumentDir.path)
    ..registerAdapter(ExpenseDataModelAdapter())
    ..registerAdapter(CategoryExpenseModelAdapter());
  await Hive.openBox<ExpenseDataModel>(expenseDataBoxName);
  await Hive.openBox<CategoryExpenseModel>(categoryDataBoxName);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          // scrollBehavior: MyBehavior(),
          debugShowCheckedModeBanner: false,
          title: 'Expense Manager',
          theme: ThemeData(
            brightness: Brightness.dark,
            appBarTheme:
                AppBarTheme(backgroundColor: Colors.black, centerTitle: true),
            scaffoldBackgroundColor: Colors.black,
          ),
          onGenerateRoute: generateRoute,
          home: MyHomePage(),
        );
      },
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
