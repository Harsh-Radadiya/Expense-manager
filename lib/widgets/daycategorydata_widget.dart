import 'package:expencemanager/controllers/expance_controller.dart';
import 'package:expencemanager/model/category_model.dart';
import 'package:expencemanager/model/expense_data_model.dart';
import 'package:expencemanager/router/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class DayCategoryDataWidget extends StatefulWidget {
  Map<String, List<ExpenseDataModel>>? userDataMap;
  // Box<ExpenseDataModel>? expenseListdataBox;
  // Box<CategoryExpenseModel>? categoryDataBox;

  DayCategoryDataWidget({
    required this.userDataMap,
    // required this.categoryDataBox,
    // required this.expenseListdataBox,
  });

  @override
  _DayCategoryDataWidgetState createState() => _DayCategoryDataWidgetState();
}

class _DayCategoryDataWidgetState extends State<DayCategoryDataWidget> {
  ExpenceController expenceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.userDataMap!.length,
      shrinkWrap: true,
      // scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, userDataMapIndex) {
        String userDataOneKey =
            widget.userDataMap!.keys.toList()[userDataMapIndex];

        double sum = 0.00;
        // print(userDataMap![userDataOneKey]![0].price);

        for (var i = 0; i < widget.userDataMap![userDataOneKey]!.length; i++) {
          sum += double.parse(widget.userDataMap![userDataOneKey]![i].price);
        }
        return Card(
            color: Colors.grey.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userDataOneKey,
                        style: Theme.of(context).textTheme.headline6!,
                      ),
                      Text(
                        '\$$sum',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.red),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.userDataMap!['$userDataOneKey']!.length,
                    itemBuilder: (_, dateWiseSortDataKeyIndex) {
                      ExpenseDataModel expenseDataModel = widget.userDataMap![
                          '$userDataOneKey']![dateWiseSortDataKeyIndex];
                      CategoryExpenseModel? categoryExpenseModel =
                          expenceController.categoryDataBox!
                              .get(expenseDataModel.categoryExpenseId);

                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actions: [
                            IconSlideAction(
                              caption: 'Edit',
                              color: Colors.grey[900],
                              icon: Icons.edit,
                              onTap: () async {
                                Navigator.pop(context);
                                await Navigator.pushNamed(
                                    context, EXPENSEEDIT_PAGE_ROUTE,
                                    arguments: expenseDataModel.dataKey);
                                // widget.expenseListdataBox!
                                //     .delete(expenseDataModel.dataKey);
                                // dataBox!.keyAt(index).delete();
                              },
                            ),
                          ],
                          secondaryActions: [
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            'Are you sure you want to delete!!!'),
                                        actions: [
                                          MaterialButton(
                                            onPressed: () {
                                              expenceController
                                                  .expenseListdataBox!
                                                  .delete(
                                                      expenseDataModel.dataKey);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Yes'),
                                          )
                                        ],
                                      );
                                    });
                              },
                            ),
                          ],
                          child: ListTile(
                            title: Text(
                              categoryExpenseModel!.categoryTitle,
                              // style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.description,
                                      color: Colors.white54,
                                      size: 15,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      expenseDataModel.description,
                                      style: TextStyle(
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: Colors.white54,
                                      size: 15,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      expenseDataModel.location,
                                      style: TextStyle(
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Text('\$${expenseDataModel.price}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.red)),
                            leading: Container(
                                decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        categoryExpenseModel.taskColor)),
                                    shape: BoxShape.circle),
                                child: ClipOval(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      categoryExpenseModel.imgUrl,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                      backgroundColor: Colors.grey[900],
                                      child: MaterialButton(
                                        child: Text("Edit Expense"),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await Navigator.pushNamed(
                                              context, EXPENSEEDIT_PAGE_ROUTE,
                                              arguments:
                                                  expenseDataModel.dataKey);
                                          // widget.expenseListdataBox!
                                          //     .delete(expenseDataModel.dataKey);
                                          // dataBox!.keyAt(index).delete();
                                        },
                                      ));
                                },
                              );
                            },
                          ),
                        ),
                      );
                    }),
              ],
            ));
      },
    );
  }
}
