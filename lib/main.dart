import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/notes/presentation/screens/home_screen.dart';
import 'features/notes/data/repositories/note_repository.dart';
import 'features/notes/presentation/viewmodels/notes_bloc.dart';
import 'shared/data/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await DatabaseHelper.instance.database;
  runApp(const PremiumNotesApp());
}

class PremiumNotesApp extends StatelessWidget {
  const PremiumNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => NoteRepository(),
      child: BlocProvider(
        create: (context) => NotesBloc(
          repository: RepositoryProvider.of<NoteRepository>(context),
        )..add(LoadNotes()),
        child: MaterialApp(
          title: 'Premium Notes',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: ThemeMode.system,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
