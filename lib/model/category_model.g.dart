// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryExpenseModelAdapter extends TypeAdapter<CategoryExpenseModel> {
  @override
  final int typeId = 0;

  @override
  CategoryExpenseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryExpenseModel(
      imgUrl: fields[0] as String,
      categoryTitle: fields[1] as String,
      taskColor: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryExpenseModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.imgUrl)
      ..writeByte(1)
      ..write(obj.categoryTitle)
      ..writeByte(2)
      ..write(obj.taskColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryExpenseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
