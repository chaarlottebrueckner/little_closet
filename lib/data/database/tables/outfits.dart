import 'package:drift/drift.dart';
import '../converters.dart';

class Outfits extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get styleTags =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn get weatherTags =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn get seasons =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
