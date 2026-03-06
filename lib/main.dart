import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:google_fonts/google_fonts.dart";
import "shared/core/theme/app_theme.dart";
import "features/notes/presentation/screens/home_screen.dart";
import "features/notes/data/repositories/note_repository.dart";
import "features/notes/presentation/viewmodels/notes_bloc.dart";
import "shared/data/database/database_helper.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
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
        ),
        child: MaterialApp(
          title: "Premium Notes",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
