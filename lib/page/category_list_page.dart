import 'package:expencemanager/controllers/expance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expencemanager/model/category_model.dart';
import 'package:expencemanager/router/routing_constants.dart';
// import 'package:expencemanager/utils/constant.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  ExpenceController expenceController = Get.find();

  // Box<CategoryExpenseModel>? categoryDataBox;
  List<String>? keys;
  List<CategoryExpenseModel>? categoryExpenseList;

  @override
  void initState() {
    // categoryDataBox = Hive.box<CategoryExpenseModel>(categoryDataBoxName);
    // print(categoryDataBox!.values.toList()[0].categoryTitle);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Category List'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable:
                    expenceController.categoryDataBox!.listenable(),
                builder: (context, Box<CategoryExpenseModel> items, _) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: expenceController.categoryDataBox!.length,
                    itemBuilder: (context, index) {
                      CategoryExpenseModel singleExpenseData = expenceController
                          .categoryDataBox!.values
                          .toList()[index];
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(15)),
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(
                                    int.parse(singleExpenseData.taskColor)),
                                radius: 35,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    singleExpenseData.imgUrl,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  singleExpenseData.categoryTitle,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, CATEGORY_EDIT_PAGE_ROUTE,
                                        arguments: expenceController
                                            .categoryDataBox!.keys
                                            .toList()[index]);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Color(
                                        int.parse(singleExpenseData.taskColor)),
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CATEGORY_ADD_TASK_PAGE_ROUTE);
        },
        child: Icon(Icons.category_outlined),
      ),
    );
  }
}
