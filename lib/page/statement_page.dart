import 'package:collection/collection.dart';
import 'package:expencemanager/controllers/expance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expencemanager/model/expense_data_model.dart';
import 'package:expencemanager/utils/utils.dart';

class StateMentPage extends StatefulWidget {
  const StateMentPage({Key? key}) : super(key: key);

  @override
  _StateMentPageState createState() => _StateMentPageState();
}

class _StateMentPageState extends State<StateMentPage> {
      ExpenceController expenceController = Get.find();

  // Box<ExpenseDataModel>? expenseListdataBox;
  // Box<CategoryExpenseModel>? categoryDataBox;
  Map<String, List<ExpenseDataModel>>? userDataMapDemo;
  List tabName = [];

  double allTotal = 0.00;

  @override
  void initState() {
    // expenseListdataBox = Hive.box<ExpenseDataModel>(expenseDataBoxName);
    // categoryDataBox = Hive.box<CategoryExpenseModel>(categoryDataBoxName);
    getAllTotal();
    super.initState();
  }

  getAllTotal() {
    // print(expenseListdataBox!.values.toList().length);
    for (var i = 0; i < expenceController.expenseListdataBox!.values.toList().length; i++) {
      allTotal += double.parse(expenceController.expenseListdataBox!.values.toList()[i].price);
    }
    // print('allTotal ==>> $allTotal');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Statements'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: size.height * .02),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.withOpacity(.1),
                ),
                width: size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Text(
                              'Overview1',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    Text('Total Expense',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.white,
                            )),
                    SizedBox(
                      height: 5,
                    ),
                    Text('\$ $allTotal',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Colors.red,
                            )),
                    SizedBox(
                      height: size.height * .02,
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * .02),
              ValueListenableBuilder(
                valueListenable: expenceController.expenseListdataBox!.listenable(),
                builder: (context, Box<ExpenseDataModel> items, _) {
                  List<ExpenseDataModel> boxValueList = items.values.toList();
                  boxValueList.sort((a, b) => b.dataKey.compareTo(a.dataKey));
                  Map<String, List<ExpenseDataModel>>? userDataMapDemo;
                  userDataMapDemo =
                      groupBy(boxValueList, (a) => a.dataKey.substring(0, 7));

                  if (userDataMapDemo.isEmpty) {
                    return Center(
                      child: Center(
                        child: Text('No Data'),
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: userDataMapDemo.keys.length,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        // print(Utils.getMonthString(
                        //     userDataMapDemo!.keys.toList()[index]));
                        String userDataMaoDemoSingleKey =
                            userDataMapDemo!.keys.toList()[index];
                        print(
                            'userDataMapDemo ==>>> ${userDataMapDemo[userDataMaoDemoSingleKey]}');
                        double monthTotal = 0.00;
                        for (var i = 0;
                            i <
                                userDataMapDemo[userDataMaoDemoSingleKey]!
                                    .length;
                            i++) {
                          monthTotal += double.parse(
                              userDataMapDemo[userDataMaoDemoSingleKey]![i]
                                  .price);
                        }

                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(8),
                            width: size.width,
                            height: size.height * .1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey.withOpacity(.1),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        Utils.getMonthString(
                                            userDataMaoDemoSingleKey),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      monthTotal.toString(),
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
              SizedBox(height: size.height * .05),
            ],
          ),
        ),
      ),
    );
  }
}
