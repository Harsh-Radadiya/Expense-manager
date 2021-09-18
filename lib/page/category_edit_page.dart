import 'package:expencemanager/controllers/expance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expencemanager/model/category_model.dart';
import 'package:expencemanager/utils/assets.dart';
import 'package:expencemanager/utils/constant.dart';

class CateGoryEditPage extends StatefulWidget {
  final int categoryEditKey;
  CateGoryEditPage({required this.categoryEditKey});

  @override
  _CateGoryEditPageState createState() => _CateGoryEditPageState();
}

class _CateGoryEditPageState extends State<CateGoryEditPage> {
  ExpenceController expenceController = Get.find();
  int isSelectedIcon = 0;
  var titleExpense = TextEditingController();
  int isSelctedColor = 0;
  String titleImagePath = AppAsset.user;
  Color taskColor = Colors.green;
  // Box<CategoryExpenseModel>? categoryDataBox;
  CategoryExpenseModel? categoryExpenseModel;
  @override
  void initState() {
    // categoryDataBox = Hive.box<CategoryExpenseModel>(categoryDataBoxName);
    categoryExpenseModel =
        expenceController.categoryDataBox!.get(widget.categoryEditKey);

    setState(() {
      titleExpense.text = categoryExpenseModel!.categoryTitle;
      titleImagePath = categoryExpenseModel!.imgUrl;
      taskColor = Color(int.parse(categoryExpenseModel!.taskColor));
      for (int i = 0; i < assetList.length; i++) {
        if (assetList[i] == categoryExpenseModel!.imgUrl) {
          isSelectedIcon = i;
        }
      }
      for (int i = 0; i < colorList.length; i++) {
        if (colorList[i].value.toString() == categoryExpenseModel!.taskColor) {
          isSelctedColor = i;
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: taskColor,
        centerTitle: true,
        title: Text('Edit Category'),
        actions: [
          IconButton(
              onPressed: () {
                // CategoryExpenseModel data = CategoryExpenseModel(
                //     imgUrl: titleImagePath,
                //     categoryTitle: titleExpense.text,
                //     taskColor: taskColor.value.toString());
                expenceController.categoryDataBox!
                    .delete(widget.categoryEditKey);
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete))
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
                          child:
                              Image.asset(titleImagePath, color: Colors.white)),
                      SizedBox(
                        width: size.width * .05,
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: titleExpense,
                        style: Theme.of(context).textTheme.headline5,
                        decoration: InputDecoration(
                            hintText: 'Category Name...',
                            hintStyle: Theme.of(context).textTheme.headline5!,
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
                                        child: Center(
                                            child: Icon(
                                      Icons.done,
                                      // color: Colors.white,
                                    )))
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
                        print('ontap');
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(int.parse(taskColor.value.toString())),
        onPressed: () {
          CategoryExpenseModel data = CategoryExpenseModel(
              imgUrl: titleImagePath,
              categoryTitle: titleExpense.text,
              taskColor: taskColor.value.toString());
          expenceController.categoryDataBox!.put(widget.categoryEditKey, data);
          Navigator.pop(context);
        },
        child: Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
