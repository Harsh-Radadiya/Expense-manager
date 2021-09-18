import 'package:hive/hive.dart';
part 'category_model.g.dart';

@HiveType(typeId: 0)
class CategoryExpenseModel {
  @HiveField(0)
  final String imgUrl;
  @HiveField(1)
  final String categoryTitle;
  @HiveField(2)
  final String taskColor;

  CategoryExpenseModel(
      {required this.imgUrl,
      required this.categoryTitle,
      required this.taskColor});
}
