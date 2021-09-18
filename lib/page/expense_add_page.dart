import 'package:expencemanager/controllers/expance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expencemanager/model/category_model.dart';
import 'package:expencemanager/model/expense_data_model.dart';
import 'package:expencemanager/router/routing_constants.dart';
import 'package:intl/intl.dart' as intl;

class ExpenseAddPage extends StatefulWidget {
  final int categoryKey;
  ExpenseAddPage({required this.categoryKey});

  @override
  _ExpenseAddPageState createState() => _ExpenseAddPageState();
}

class _ExpenseAddPageState extends State<ExpenseAddPage> {
  ExpenceController expenceController = Get.find();

  // Box<ExpenseDataModel>? expenseListdataBox;
  // Box<CategoryExpenseModel>? categoryDataBox;
  CategoryExpenseModel? categoryExpenseModel;
  TextEditingController expensePriceController = TextEditingController();
  TextEditingController expenseDesController = TextEditingController();
  TextEditingController expenseLocationController = TextEditingController();
  String? widgetColor;

  var formKey = GlobalKey<FormState>();

  intl.DateFormat? formatterMonth = intl.DateFormat('MMMM d, y');
  intl.DateFormat? formateOnlyDate = intl.DateFormat('yyyy-MM-dd');
  intl.DateFormat? formateOnlyTime = intl.DateFormat('HH:mm:ss.sss');

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(
      {required BuildContext context, required String color}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2017, 8),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: Color(int.parse(color)),
              ),
            ),
            child: child!,
          );
        });

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    // expenseListdataBox = Hive.box<ExpenseDataModel>(expenseDataBoxName);
    // categoryDataBox = Hive.box<CategoryExpenseModel>(categoryDataBoxName);
    categoryExpenseModel =
        expenceController.categoryDataBox!.get(widget.categoryKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(int.parse(categoryExpenseModel!.taskColor)),
        title: Text(
          'Price',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                color: Color(int.parse(categoryExpenseModel!.taskColor)),
                child: Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 40,
                            child: Image.asset(
                              categoryExpenseModel!.imgUrl,
                              color: Colors.white,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text(categoryExpenseModel!.categoryTitle,
                            style: TextStyle(
                                // color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 17)),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Expanded(
                        child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        controller: expensePriceController,
                        style: Theme.of(context).textTheme.headline5,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            // prefixIcon: Text('\$'),
                            errorStyle: TextStyle(),
                            hintText: 'Price',
                            prefixText: '\$',
                            hintStyle:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      color: Colors.white54,
                                    ),
                            border: InputBorder.none),
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.white,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Price';
                          }
                        },
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: Icon(
                    Icons.calendar_today,
                    color: Color(int.parse(categoryExpenseModel!.taskColor)),
                  ),
                  onTap: () => _selectDate(
                      color: categoryExpenseModel!.taskColor, context: context),
                  title: Text(
                    formatterMonth!.format(selectedDate),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              Container(
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: Icon(
                    Icons.edit,
                    color: Color(int.parse(categoryExpenseModel!.taskColor)),
                  ),
                  title: TextFormField(
                    controller: expenseDesController,
                    style: Theme.of(context).textTheme.headline5,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintText: 'Description...',
                        hintStyle:
                            Theme.of(context).textTheme.headline6!.copyWith(
                                  color: Colors.white54,
                                ),
                        border: InputBorder.none),
                    cursorColor: Colors.white,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Description';
                      }
                    },
                  ),
                ),
              ),
              Container(
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: Icon(
                    Icons.location_on_rounded,
                    color: Color(int.parse(categoryExpenseModel!.taskColor)),
                  ),
                  title: TextFormField(
                    controller: expenseLocationController,
                    style: Theme.of(context).textTheme.headline5,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        hintText: 'Location...',
                        hintStyle:
                            Theme.of(context).textTheme.headline6!.copyWith(
                                  color: Colors.white54,
                                ),
                        border: InputBorder.none),
                    cursorColor: Colors.white,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Location';
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(int.parse(categoryExpenseModel!.taskColor)),
        onPressed: () {
          try {
            if (formKey.currentState!.validate()) {
              String dateKey = formateOnlyDate!.format(selectedDate) +
                  ' ' +
                  formateOnlyTime!.format(DateTime.now());
              ExpenseDataModel expenseDataModel = ExpenseDataModel(
                  categoryExpenseId: widget.categoryKey,
                  price: expensePriceController.text,
                  date: formatterMonth!.format(selectedDate),
                  description: expenseDesController.text,
                  location: expenseLocationController.text,
                  dataKey: dateKey);
              print(expenseDataModel.categoryExpenseId.toString() +
                  '\n' +
                  expenseDataModel.date +
                  '\n' +
                  expenseDataModel.description +
                  '\n' +
                  expenseDataModel.location +
                  '\n' +
                  expenseDataModel.price);
              // .put('2021-06-15 16:15:39.856901', expenseDataModel)
              expenceController.expenseListdataBox!
                  .put(dateKey, expenseDataModel)
                  .then((value) {
                print('pop page ');
                Navigator.pushReplacementNamed(context, HOME_PAGE_ROUTE);
              });
            } else {
              print('notValidate');
              // print(DateTime.now());
            }
          } catch (e) {
            print("ERROR::$e");
          }
        },
        child: Icon(Icons.done),
      ),
    );
  }
}
