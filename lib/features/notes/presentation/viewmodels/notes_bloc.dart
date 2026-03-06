import "package:flutter_bloc/flutter_bloc.dart";
import "package:equatable/equatable.dart";
import "../../domain/models/note.dart";
import "../../data/repositories/note_repository.dart";

part "notes_event.dart";
part "notes_state.dart";

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteRepository _repository;

  NotesBloc({required NoteRepository repository})
      : _repository = repository,
        super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<TogglePinNote>(_onTogglePinNote);
    on<ToggleFavoriteNote>(_onToggleFavoriteNote);
    on<ToggleArchiveNote>(_onToggleArchiveNote);
    on<SearchNotes>(_onSearchNotes);
    on<LoadFavorites>(_onLoadFavorites);
    on<LoadArchived>(_onLoadArchived);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await _repository.getAllNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    try {
      await _repository.insertNote(event.note);
      add(LoadNotes());
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    try {
      await _repository.updateNote(event.note);
      add(LoadNotes());
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    try {
      await _repository.deleteNote(event.id);
      add(LoadNotes());
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onTogglePinNote(TogglePinNote event, Emitter<NotesState> emit) async {
    try {
      await _repository.togglePin(event.id);
      add(LoadNotes());
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onToggleFavoriteNote(ToggleFavoriteNote event, Emitter<NotesState> emit) async {
    try {
      await _repository.toggleFavorite(event.id);
      add(LoadNotes());
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onToggleArchiveNote(ToggleArchiveNote event, Emitter<NotesState> emit) async {
    try {
      await _repository.toggleArchive(event.id);
      add(LoadNotes());
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onSearchNotes(SearchNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await _repository.searchNotes(event.query);
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onLoadFavorites(LoadFavorites event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await _repository.getFavoriteNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onLoadArchived(LoadArchived event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await _repository.getArchivedNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }
}
