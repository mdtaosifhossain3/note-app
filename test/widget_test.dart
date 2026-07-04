import 'package:flutter_test/flutter_test.dart';
import 'package:note_app/models/note_model.dart';

void main() {
  group('NoteModel Unit Tests', () {
    test('copyWith should modify fields correctly', () {
      final now = DateTime.now();
      final note = NoteModel(
        id: '123',
        title: 'Original Title',
        description: 'Original Description',
        createdAt: now,
        updatedAt: now,
      );

      final updatedNote = note.copyWith(title: 'Updated Title');

      expect(updatedNote.id, '123');
      expect(updatedNote.title, 'Updated Title');
      expect(updatedNote.description, 'Original Description');
      expect(updatedNote.createdAt, now);
      expect(updatedNote.updatedAt, now);
    });
  });
}
