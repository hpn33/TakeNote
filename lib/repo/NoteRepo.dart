import 'package:TakeNote/services/moor/MoorDB.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:moor/moor.dart';

final noteRepoProvider = Provider((ref) {
  final db = ref.watch(dbProvider);

  return NoteRepo(db);
});

final watchAllNotesProvider = StreamProvider((ref) {
  final db = ref.watch(dbProvider);
  final noteRepo = NoteRepo(db);

  return noteRepo.watchAll();
});

class NoteRepo {
  final MoorDB db;

  NoteRepo(this.db);

  // returns the generated id
  Future<int> add(String title, String description) {
    return db.addNote(
        NotesCompanion(title: Value(title), description: Value(description)));
  }

  Stream<List<Note>> watchAll() => db.watchAllNoteEntries;
}
