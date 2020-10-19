import 'package:TakeNote/repo/NoteRepo.dart';
import 'package:TakeNote/services/moor/MoorDB.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/all.dart';

class Panel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(''),
              onPressed: () {
                context.read(noteRepoProvider).add('t', 'd');
                // context.refresh(watchAllNotesProvider);
              },
            ),
            watch(watchAllNotesProvider).when(
              error: (Object error, StackTrace stackTrace) {
                return Text('${error.toString()} :: ${stackTrace.toString()}');
              },
              data: (List<Note> noteList) {
                return Column(children: [
                  for (var note in noteList)
                    Card(
                        child: Column(children: [
                      Text(note.title),
                      Text(note.description),
                    ]))
                ]);
              },
              loading: () {
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
