import 'package:TakeNote/services/moor/MoorDB.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor/ffi.dart';
// the file defined above, you can test any moor database of course

void main() {
  MoorDB database;

  setUp(() {
    database = MoorDB(VmDatabase.memory());
  });

  test('notes can be created', () async {
    final id = await database.createNote('some user');
    final note = await database.watchNoteWithId(id).first;

    expect(note.title, 'some user');
  });

  test('stream emits a new user when the name updates', () async {
    final id = await database.createNote('first name');

    final expectation = expectLater(
      database.watchNoteWithId(id).map((user) => user.title),
      emitsInOrder(['first name', 'changed name']),
    );

    await database.updateTitle(id, 'changed name');
    await expectation;
  });

  tearDown(() async {
    await database.close();
  });
}
