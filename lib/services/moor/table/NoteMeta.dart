import 'package:moor/moor.dart';

class NoteMetas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get noteId => integer().nullable()();
  TextColumn get key => text()();
  TextColumn get value => text()();
}
