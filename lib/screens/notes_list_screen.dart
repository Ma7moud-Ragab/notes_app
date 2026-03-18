import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/notes_cubit.dart';
import '../cubit/notes_state.dart';
import '../models/note_model.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotesCubit()..getNotes(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          title: const Text(
            'Notes List',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<NotesCubit, NotesState>(
          builder: (context, state) {
            if (state is NotesLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF00BCD4)),
              );
            }

            if (state is NotesError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is NotesLoaded) {
              if (state.notes.isEmpty) {
                return const Center(
                  child: Text(
                    'No notes yet!',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.notes.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: Color(0xFF2C2C2C), height: 1),
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return _NoteListItem(note: note);
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _NoteListItem extends StatelessWidget {
  final NoteModel note;

  const _NoteListItem({required this.note});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () =>
          Navigator.pushNamed(context, '/note-details', arguments: note),
      title: Text(
        note.title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          note.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Color(0xFF00BCD4), fontSize: 13),
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: const Color(0xFF2C2C2C),
              title: const Text(
                'Delete Note',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                'Are you sure you want to delete this note?',
                style: TextStyle(color: Colors.grey),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<NotesCubit>().deleteNote(note.id);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
