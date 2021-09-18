import 'package:hive/hive.dart';

part 'expense_data_model.g.dart';

@HiveType(typeId: 1)
class ExpenseDataModel {
  @HiveField(0)
  final int categoryExpenseId;

  @HiveField(1)
  final String price;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String location;
  @HiveField(5)
  final String dataKey;

  ExpenseDataModel({
    required this.categoryExpenseId,
    required this.price,
    required this.date,
    required this.description,
    required this.location,
    required this.dataKey,
  });
}
