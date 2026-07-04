import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note_model.dart';

/// Service class that handles all Firestore CRUD operations for notes.
class NoteService {
  NoteService._();

  static final NoteService instance = NoteService._();

  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('notes');

  // ── READ ────────────────────────────────────────────────────────────────────

  /// Returns a real-time stream of all notes ordered by creation date (newest first).
  Stream<List<NoteModel>> getNotes() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NoteModel.fromFirestore(doc))
          .toList();
    });
  }

  // ── CREATE ──────────────────────────────────────────────────────────────────

  /// Adds a new note to Firestore.
  Future<void> addNote({
    required String title,
    required String description,
  }) async {
    final now = DateTime.now();
    await _collection.add({
      'title': title.trim(),
      'description': description.trim(),
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    });
  }

  // ── UPDATE ──────────────────────────────────────────────────────────────────

  /// Updates an existing note's title and description.
  Future<void> updateNote({
    required String id,
    required String title,
    required String description,
  }) async {
    await _collection.doc(id).update({
      'title': title.trim(),
      'description': description.trim(),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // ── DELETE ──────────────────────────────────────────────────────────────────

  /// Permanently deletes a note from Firestore by its document ID.
  Future<void> deleteNote(String id) async {
    await _collection.doc(id).delete();
  }
}
