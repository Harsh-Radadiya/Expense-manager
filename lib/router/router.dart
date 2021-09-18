import 'package:expencemanager/page/categories_add_page.dart';
import 'package:expencemanager/page/category_edit_page.dart';
import 'package:expencemanager/page/category_list_page.dart';
import 'package:expencemanager/page/expense_add_page.dart';
import 'package:expencemanager/page/expense_edit_page.dart';
import 'package:expencemanager/page/expense_list_page.dart';
import 'package:expencemanager/page/myhomepage.dart';
import 'package:expencemanager/page/statement_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'routing_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HOME_PAGE_ROUTE:
      return CupertinoPageRoute(
          builder: (BuildContext context) => MyHomePage());
    case CATEGORY_ADD_TASK_PAGE_ROUTE:
      return CupertinoPageRoute(
          builder: (BuildContext context) => CategoryAddTask());
    case CATEGORY_LIST_PAGE_ROUTE:
      return CupertinoPageRoute(
          builder: (BuildContext context) => CategoryListPage());
    case CATEGORY_EDIT_PAGE_ROUTE:
      return CupertinoPageRoute(
          builder: (BuildContext context) => CateGoryEditPage(
                categoryEditKey: settings.arguments as int,
              ));
    case EXPENSELIST_PAGE_ROUTE:
      return CupertinoPageRoute(
          builder: (BuildContext context) => ExpenseListPage());
    case STATEMENT_PAGE_ROUTE:
      return CupertinoPageRoute(
          builder: (BuildContext context) => StateMentPage());
    case EXPENSEADD_PAGE_ROUTE:
      return CupertinoPageRoute(
          builder: (BuildContext context) =>
              ExpenseAddPage(categoryKey: settings.arguments as int));
    case EXPENSEEDIT_PAGE_ROUTE:
      return CupertinoPageRoute(
          builder: (BuildContext context) => ExpenseEditPage(
                expenseKey: settings.arguments as String,
              ));
  }
  print('failed to navigate');
  return CupertinoPageRoute(builder: (BuildContext context) => MyHomePage());
}
