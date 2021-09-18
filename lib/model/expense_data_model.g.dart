// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseDataModelAdapter extends TypeAdapter<ExpenseDataModel> {
  @override
  final int typeId = 1;

  @override
  ExpenseDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseDataModel(
      categoryExpenseId: fields[0] as int,
      price: fields[1] as String,
      date: fields[2] as String,
      description: fields[3] as String,
      location: fields[4] as String,
      dataKey: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseDataModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.categoryExpenseId)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.dataKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
