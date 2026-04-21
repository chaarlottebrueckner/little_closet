//type converters for the Drift database
//so we can store complex data types like lists as strings in the database.

import 'dart:convert';
import 'package:drift/drift.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) =>
      (json.decode(fromDb) as List).cast<String>();

  @override
  String toSql(List<String> value) => json.encode(value);
}
