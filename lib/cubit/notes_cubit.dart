import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/note_model.dart';
import '../services/firestore_service.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final FirestoreService _firestoreService = FirestoreService();

  NotesCubit() : super(NotesInitial());

  void getNotes() {
    emit(NotesLoading());
    _firestoreService.getNotes().listen(
      (notes) => emit(NotesLoaded(notes)),
      onError: (e) => emit(NotesError(e.toString())),
    );
  }

  Future<void> addNote({required String title, required String content}) async {
    try {
      final note = NoteModel(
        id: '',
        title: title,
        content: content,
        createdAt: DateTime.now(),
      );
      await _firestoreService.addNote(note);
      emit(NoteOperationSuccess());
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> updateNote(NoteModel note) async {
    try {
      await _firestoreService.updateNote(note);
      emit(NoteOperationSuccess());
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _firestoreService.deleteNote(id);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }
}
