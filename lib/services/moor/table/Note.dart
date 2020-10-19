import 'package:moor/moor.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(max: 200)();
  TextColumn get description => text()();
}
