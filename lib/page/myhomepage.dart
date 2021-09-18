import 'package:collection/collection.dart';
import 'package:expencemanager/controllers/expance_controller.dart';
import 'package:expencemanager/page/sample_view_model.dart';
import 'package:expencemanager/utils/sorting_utils.dart';
import 'package:expencemanager/utils/utils.dart';
import 'package:expencemanager/widgets/chart_widget.dart';
import 'package:expencemanager/widgets/daycategorydata_widget.dart';
import 'package:expencemanager/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expencemanager/model/category_model.dart';
import 'package:expencemanager/model/expense_data_model.dart';
import 'package:expencemanager/router/routing_constants.dart';
import 'package:expencemanager/utils/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sizer/sizer.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  ExpenceController expenceController = Get.put(ExpenceController());
  // Box<ExpenseDataModel>? expenseListdataBox;
  // Box<CategoryExpenseModel>? categoryDataBox;
  // List<CategoryExpenseModel>? categoryExpenseList;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  Map<String, List<ExpenseDataModel>>? userDataMap;
  //chart Data month
  List<ChartSampleData> chartDataMonth = <ChartSampleData>[];

  bool isCardView = false;
  List<DoughnutSeries<ChartSampleData, String>> _getMonthDoughnutSeries() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          radius: '80%',
          explode: true,
          explodeOffset: '10%',
          dataSource: chartDataMonth,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(isVisible: true))
    ];
  }

  //chart Data Year
  List<ChartSampleData> chartDataYear = <ChartSampleData>[];

  List<DoughnutSeries<ChartSampleData, String>> _getYearDoughnutSeries() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          radius: '80%',
          explode: true,
          explodeOffset: '10%',
          dataSource: chartDataYear,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ))
    ];
  }

  //tababr
  TabController? _tabController;
  List tabName = [];

  addMockData() {
    if (expenceController.categoryDataBox!.isEmpty) {
      List imgUrlList = [
        "assets/airplane.png",
        "assets/barber.png",
        "assets/car.png",
        "assets/card.png",
        "assets/cash.png",
        "assets/clothe.png",
        "assets/drink.png",
        "assets/fuel.png"
      ];
      List categoryTitleList = [
        'Flights',
        'Barber',
        'Taxi',
        'Card Payment',
        'Cash Payment',
        'Clothes',
        'Drink',
        'Fuel'
      ];
      List taskColor = colorList;
      for (var i = 0; i < taskColor.length; i++) {
        CategoryExpenseModel data = CategoryExpenseModel(
            imgUrl: imgUrlList[i],
            categoryTitle: categoryTitleList[i],
            taskColor: taskColor[i].value.toString());
        expenceController.categoryDataBox!.add(data);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // expenseListdataBox = Hive.box<ExpenseDataModel>(expenseDataBoxName);
    expenceController.categoryDataBox =
        Hive.box<CategoryExpenseModel>(categoryDataBoxName);
    // categoryDataBox!.clear();
    addMockData();

    // dataBox!.clear();
  }

  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // print("homepage build");
    return AdvancedDrawer(
        backdropColor: Colors.grey.withOpacity(0.1),
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        childDecoration: const BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Scaffold(
          appBar: AppBar(
              title: Text("Dashboard"),
              centerTitle: true,
              leading: IconButton(
                onPressed: _handleMenuButtonPressed,
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: _advancedDrawerController,
                  builder: (_, value, __) {
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      child: Icon(
                        value.visible ? Icons.clear : Icons.menu,
                        key: ValueKey<bool>(value.visible),
                      ),
                    );
                  },
                ),
              )),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ValueListenableBuilder(
                  valueListenable:
                      expenceController.expenseListdataBox!.listenable(),
                  builder: (context, Box<ExpenseDataModel> items, _) {
                    List<ExpenseDataModel> boxValueList = items.values.toList();

                    // HiveUtils().sortExpenses(boxValueList);
                    // print(boxValueList.length);

                    boxValueList.sort((a, b) => b.dataKey.compareTo(a.dataKey));
                    // print(boxValueList[0].date);

                    userDataMap = groupBy(boxValueList, (a) => a.date);

                    if (userDataMap!.isEmpty) {
                      return Center(
                        child: Text('No Data'),
                      );
                    } else {
                      Map<String, List<ExpenseDataModel>>? userDataMapForMonth =
                          groupBy(
                              boxValueList, (a) => a.dataKey.substring(0, 7));
                      tabName = userDataMapForMonth.keys.toList();
                      _tabController =
                          TabController(length: tabName.length, vsync: this);

                      chartDataMonth = HiveSortUtils().getMonthWiseChartData(
                          expenceController.expenseListdataBox!.values
                              .toList()
                              .last
                              .dataKey);
                      chartDataYear = HiveSortUtils().getYearWiseChartData(
                          expenceController.expenseListdataBox!.values
                              .toList()
                              .last
                              .dataKey);
                      return Container(
                        // height: size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              //chart
                              Card(
                                color: Colors.grey.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ChartWidget(
                                  chartCategory: 'year',
                                  chartData: chartDataYear,
                                  expenceController: expenceController,
                                ),
                              ),
                              SizedBox(height: 10),
                              Card(
                                color: Colors.grey.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ChartWidget(
                                  chartCategory: 'month',
                                  chartData: chartDataMonth,
                                  expenceController: expenceController,
                                ),
                              ),
                              TabBar(
                                isScrollable: true,
                                indicator: UnderlineTabIndicator(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 3),
                                    insets: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 0)),
                                // unselectedLabelColor: Colors.black,
                                labelColor: Colors.red,
                                controller: _tabController,
                                indicatorSize: TabBarIndicatorSize.tab,
                                tabs: tabName.map((groupKey) {
                                  return Tab(
                                      child:
                                          Text(Utils.getMonthString(groupKey)));
                                }).toList(),
                              ),

                              Container(
                                height: size.height,
                                child: TabBarView(
                                  children: tabName.map((groupKey) {
                                    return tab(groupKey, userDataMapForMonth);
                                  }).toList(),
                                  controller: _tabController,
                                ),
                              ),

                              // DayCategoryDataWidget(
                              //   userDataMap: userDataMap,
                              // ),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ),

          //Floating Action Button
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.grey[800],
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Colors.grey[900],
                  context: context,
                  builder: (context) {
                    String? selectYourCategory;
                    String categoryImage = '1';
                    String imageColor = Colors.red.value.toString();
                    int? categoryId;

                    return StatefulBuilder(builder: (context, setState) {
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        height: 60.h,
                        width: 100.w,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      height: 40,
                                      child: categoryImage == '1'
                                          ? Container()
                                          : Image.asset(
                                              categoryImage,
                                              color:
                                                  Color(int.parse(imageColor)),
                                            )),
                                  Expanded(
                                    child: Text(
                                      selectYourCategory ??
                                          'Select Your Category',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!,
                                    ),
                                  ),
                                  categoryImage == '1'
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: MaterialButton(
                                              padding: EdgeInsets.all(8.0),
                                              color: Colors.grey[800],
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pushNamed(context,
                                                    EXPENSEADD_PAGE_ROUTE,
                                                    arguments: categoryId);
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Add Expenses',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              )),
                                        )
                                ],
                              ),
                              Divider(
                                color: Colors.white,
                                height: 5,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SingleChildScrollView(
                                child: ValueListenableBuilder(
                                    valueListenable: expenceController
                                        .categoryDataBox!
                                        .listenable(),
                                    builder: (context,
                                        Box<CategoryExpenseModel> items, _) {
                                      return GridView.builder(
                                        shrinkWrap: true,
                                        itemCount: expenceController
                                            .categoryDataBox!.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                        ),
                                        itemBuilder: (context, index) {
                                          CategoryExpenseModel
                                              singleExpenseData =
                                              expenceController
                                                  .categoryDataBox!.values
                                                  .toList()[index];
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectYourCategory =
                                                    singleExpenseData
                                                        .categoryTitle;
                                                categoryImage =
                                                    singleExpenseData.imgUrl;
                                                imageColor =
                                                    singleExpenseData.taskColor;
                                                categoryId = expenceController
                                                    .categoryDataBox!.keys
                                                    .toList()[index];
                                              });
                                            },
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Image.asset(
                                                      singleExpenseData.imgUrl,
                                                      color: Color(int.parse(
                                                          singleExpenseData
                                                              .taskColor)),
                                                      fit: BoxFit.fill,
                                                      height: 5.h,
                                                    ),
                                                  ),
                                                  Text(
                                                    singleExpenseData
                                                        .categoryTitle,
                                                    softWrap: true,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption!
                                                        .copyWith(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  });
            },
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
        //Drawer
        drawer:
            Drawerwidget(advancedDrawerController: _advancedDrawerController));
  }

  Widget tab(groupKey, userDataMapForMonth) {
    List<ExpenseDataModel>? groupData = userDataMapForMonth![groupKey];
    Map<String, List<ExpenseDataModel>>? _userDataMapForMonth;
    _userDataMapForMonth = groupBy(groupData!, (a) => a.date);
    return DayCategoryDataWidget(
      userDataMap: _userDataMapForMonth,
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
