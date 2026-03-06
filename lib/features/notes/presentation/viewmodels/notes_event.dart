part of "notes_bloc.dart";

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NotesEvent {}

class LoadFavorites extends NotesEvent {}

class LoadArchived extends NotesEvent {}

class AddNote extends NotesEvent {
  final Note note;

  const AddNote({required this.note});

  @override
  List<Object?> get props => [note];
}

class UpdateNote extends NotesEvent {
  final Note note;

  const UpdateNote({required this.note});

  @override
  List<Object?> get props => [note];
}

class DeleteNote extends NotesEvent {
  final String id;

  const DeleteNote({required this.id});

  @override
  List<Object?> get props => [id];
}

class TogglePinNote extends NotesEvent {
  final String id;

  const TogglePinNote({required this.id});

  @override
  List<Object?> get props => [id];
}

class ToggleFavoriteNote extends NotesEvent {
  final String id;

  const ToggleFavoriteNote({required this.id});

  @override
  List<Object?> get props => [id];
}

class ToggleArchiveNote extends NotesEvent {
  final String id;

  const ToggleArchiveNote({required this.id});

  @override
  List<Object?> get props => [id];
}

class SearchNotes extends NotesEvent {
  final String query;

  const SearchNotes({required this.query});

  @override
  List<Object?> get props => [query];
}
