import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:google_fonts/google_fonts.dart";
import "../../../shared/core/theme/app_theme.dart";
import "../../domain/models/note.dart";
import "../viewmodels/notes_bloc.dart";
import "../widgets/note_card.dart";
import "../widgets/empty_state.dart";
import "../widgets/search_bar.dart";
import "note_editor_screen.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(LoadNotes());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            SliverToBoxAdapter(
              child: _buildSearchBar(),
            ),
            SliverToBoxAdapter(
              child: _buildCategories(),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: _buildNotesList(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Notes",
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
              const SizedBox(height: 4),
              Text(
                "Capture your thoughts",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.textSecondaryLight,
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
            ],
          ),
          _buildProfileAvatar(),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 24,
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            if (value.isNotEmpty) {
              context.read<NotesBloc>().add(SearchNotes(query: value));
            } else {
              context.read<NotesBloc>().add(LoadNotes());
            }
          },
          decoration: InputDecoration(
            hintText: "Search notes...",
            hintStyle: GoogleFonts.inter(
              color: AppColors.textSecondaryLight,
            ),
            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.textSecondaryLight),
                    onPressed: () {
                      _searchController.clear();
                      context.read<NotesBloc>().add(LoadNotes());
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {"name": "All", "icon": Icons.folder_outlined, "color": AppColors.primary},
      {"name": "Personal", "icon": Icons.person_outline, "color": const Color(0xFFFF6B6B)},
      {"name": "Work", "icon": Icons.work_outline, "color": const Color(0xFF4ECDC4)},
      {"name": "Ideas", "icon": Icons.lightbulb_outline, "color": const Color(0xFFFFE66D)},
    ];

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (category["color"] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    category["icon"] as IconData,
                    color: category["color"] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category["name"] as String,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms, delay: (100 * index).ms).slideY(begin: 0.2, end: 0);
        },
      ),
    );
  }

  Widget _buildNotesList() {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        if (state is NotesLoading) {
          return SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }

        if (state is NotesError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                "Error: ${state.message}",
                style: GoogleFonts.inter(color: AppColors.error),
              ),
            ),
          );
        }

        if (state is NotesLoaded) {
          if (state.notes.isEmpty) {
            return const SliverToBoxAdapter(
              child: EmptyState(),
            );
          }

          final pinnedNotes = state.notes.where((n) => n.isPinned).toList();
          final otherNotes = state.notes.where((n) => !n.isPinned).toList();

          return SliverList(
            delegate: SliverChildListDelegate([
              if (pinnedNotes.isNotEmpty) ...[
                _buildSectionTitle("Pinned"),
                const SizedBox(height: 12),
                MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemCount: pinnedNotes.length,
                  itemBuilder: (context, index) {
                    return _buildNoteCard(pinnedNotes[index], index);
                  },
                ),
                const SizedBox(height: 24),
              ],
              if (otherNotes.isNotEmpty) ...[
                _buildSectionTitle("Others"),
                const SizedBox(height: 12),
                MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemCount: otherNotes.length,
                  itemBuilder: (context, index) {
                    return _buildNoteCard(otherNotes[index], index);
                  },
                ),
              ],
            ]),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondaryLight,
      ),
    );
  }

  Widget _buildNoteCard(Note note, int index) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              context.read<NotesBloc>().add(TogglePinNote(id: note.id));
            },
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) {
              context.read<NotesBloc>().add(DeleteNote(id: note.id));
            },
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: NoteCard(
        note: note,
        onTap: () => _openNoteEditor(note),
      ).animate().fadeIn(duration: 400.ms, delay: (50 * index).ms).slideY(begin: 0.1, end: 0),
    );
  }

  void _openNoteEditor(Note? note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(note: note),
      ),
    ).then((_) {
      context.read<NotesBloc>().add(LoadNotes());
    });
  }

  Widget _buildFab() {
    return FloatingActionButton.extended(
      onPressed: () => _openNoteEditor(null),
      icon: const Icon(Icons.add),
      label: Text(
        "New Note",
        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
      ),
    ).animate().scale(duration: 400.ms, delay: 500.ms, curve: Curves.easeOutBack);
  }
}
