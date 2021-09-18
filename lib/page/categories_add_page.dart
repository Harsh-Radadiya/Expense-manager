import 'package:expencemanager/controllers/expance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expencemanager/model/category_model.dart';
import 'package:expencemanager/utils/assets.dart';
import 'package:expencemanager/utils/constant.dart';

class CategoryAddTask extends StatefulWidget {
  const CategoryAddTask({Key? key}) : super(key: key);

  @override
  _CategoryAddTaskState createState() => _CategoryAddTaskState();
}

class _CategoryAddTaskState extends State<CategoryAddTask> {
      ExpenceController expanceController = Get.find();

  int isSelectedIcon = 14;
  var titleExpense = TextEditingController();
  int isSelctedColor = 1;
  String titleImagePath = AppAsset.user;
  Color taskColor = Colors.green;
  @override
  void initState() {
    // categoryDataBox = Hive.box<CategoryExpenseModel>(categoryDataBoxName);
    super.initState();
    // categoryDataBox!.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: taskColor,
        centerTitle: true,
        title: Text('Add Category'),
        actions: [
          IconButton(
              onPressed: () {
                // print(
                //     '$titleImagePath ${titleExpense.text} ${taskColor.value.toString()}');
                CategoryExpenseModel data = CategoryExpenseModel(
                    imgUrl: titleImagePath,
                    categoryTitle: titleExpense.text,
                    taskColor: taskColor.value.toString());
                expanceController.categoryDataBox!.add(data);
                // categoryDataBox!.put(, value)
                Navigator.pop(context);
              },
              icon: Icon(Icons.done))
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                  height: size.height * .15,
                  color: taskColor,
                  child: Row(
                    children: [
                      Container(
                          height: size.height * .055,
                          child: Image.asset(
                            titleImagePath,
                            color: Colors.white,
                          )),
                      SizedBox(
                        width: size.width * .05,
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: titleExpense,
                        style: Theme.of(context).textTheme.headline5!,
                        decoration: InputDecoration(
                            hintText: 'Category Name...',
                            hintStyle: Theme.of(context).textTheme.headline5,
                            border: InputBorder.none),
                        cursorColor: Colors.white,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter description';
                          }
                        },
                      ))
                    ],
                  )),
              Container(
                // color: Colors.amber,
                margin: EdgeInsets.symmetric(
                    vertical: size.height * .02, horizontal: size.width * .03),
                height: size.height * .065,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: colorList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            taskColor = colorList[index];
                            isSelctedColor = index;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          height: size.height * .05,
                          width: size.width * .11,
                          color: colorList[index],
                          child: isSelctedColor == index
                              ? Stack(
                                  children: [
                                    Positioned(
                                        child: Center(child: Icon(Icons.done)))
                                  ],
                                )
                              : Container(),
                        ),
                      );
                    }),
              ),
              Container(
                margin: EdgeInsets.all(size.width * .06),
                height: size.height * .6,
                child: GridView.builder(
                  itemCount: assetList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: size.width * .12,
                    mainAxisSpacing: size.height * .04,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelectedIcon = index;
                          titleImagePath = assetList[index];
                        });
                      },
                      child: Container(
                        child: Image.asset(
                          assetList[index],
                          color: index == isSelectedIcon
                              ? Colors.green
                              : Colors.white,
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                ),
              )
            ]),
      ),
    );
  }
}
