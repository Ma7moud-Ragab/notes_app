import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/notes_cubit.dart';
import '../cubit/notes_state.dart';
import '../models/note_model.dart';

class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen({super.key});

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late NoteModel note;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    note = ModalRoute.of(context)!.settings.arguments as NoteModel;
    _titleController = TextEditingController(text: note.title);
    _contentController = TextEditingController(text: note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotesCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Note Details',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            BlocConsumer<NotesCubit, NotesState>(
              listener: (context, state) {
                if (state is NoteOperationSuccess) {
                  setState(() => _isEditing = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Note updated successfully!'),
                      backgroundColor: Color(0xFF00BCD4),
                    ),
                  );
                } else if (state is NotesError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    _isEditing ? Icons.check : Icons.edit_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (_isEditing) {
                      // Save Changes
                      final updatedNote = NoteModel(
                        id: note.id,
                        title: _titleController.text.trim(),
                        content: _contentController.text.trim(),
                        createdAt: note.createdAt,
                      );
                      context.read<NotesCubit>().updateNote(updatedNote);
                      note = updatedNote;
                    } else {
                      setState(() => _isEditing = true);
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              _isEditing
                  ? TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF2C2C2C),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    )
                  : Text(
                      note.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

              const SizedBox(height: 12),

              // Content
              _isEditing
                  ? TextField(
                      controller: _contentController,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      maxLines: 8,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF2C2C2C),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    )
                  : Text(
                      note.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),

              const SizedBox(height: 16),

              // Created At
              Text(
                'Created At: ${_formatDate(note.createdAt)}',
                style: const TextStyle(color: Color(0xFF00BCD4), fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
