import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class FirestoreService {
  final CollectionReference _notesCollection = FirebaseFirestore.instance
      .collection('notes');

  // ✅ Add Note
  Future<void> addNote(NoteModel note) async {
    await _notesCollection.add(note.toFirestore());
  }

  // ✅ Get All Notes
  Stream<List<NoteModel>> getNotes() {
    return _notesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => NoteModel.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  // ✅ Update Note
  Future<void> updateNote(NoteModel note) async {
    await _notesCollection.doc(note.id).update(note.toFirestore());
  }

  // ✅ Delete Note
  Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
  }
}
