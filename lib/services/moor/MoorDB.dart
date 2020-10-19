import 'dart:io';

import 'package:hooks_riverpod/all.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';

import 'table/Note.dart';
import 'table/NoteMeta.dart';
import 'package:path/path.dart' as p;

part 'MoorDB.g.dart';

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Notes, NoteMetas])
class MoorDB extends _$MoorDB {
  // we tell the database where to store the data with this constructor
  MoorDB(QueryExecutor e) : super(e);

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  // loads all todo entries
  Future<List<Note>> get allNoteEntries => select(notes).get();
  Stream<List<Note>> get watchAllNoteEntries => select(notes).watch();

  // watches all todo entries in a given category. The stream will automatically
  // emit new items whenever the underlying data changes.
  Stream<List<Note>> watchEntriesInNoteMeta(NoteMeta c) {
    return (select(notes)..where((t) => t.id.equals(c.noteId))).watch();
  }

  // returns the generated id
  Future<int> addNote(NotesCompanion entry) {
    return into(notes).insert(entry);
  }




  ///-------------------------------
  ///
  ///
  ////// Creates a user and returns their id
  Future<int> createNote(String title) {
    return into(notes).insert(NotesCompanion.insert(title: title));
  }

  /// Changes the name of a user with the [id] to the [newName].
  Future<void> updateTitle(int id, String newTitle) {
    return update(notes).replace(Note(id: id, title: newTitle));
  }

  Stream<Note> watchNoteWithId(int id) {
    return (select(notes)..where((u) => u.id.equals(id))).watchSingle();
  }
}

final dbProvider = Provider((ref) => MoorDB(_openConnection()));
