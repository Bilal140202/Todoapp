class AppConstants {
  static const String appName = "Premium Notes";
  static const String databaseName = "premium_notes.db";
  static const int databaseVersion = 1;
  
  static const String notesTable = "notes";
  static const String categoriesTable = "categories";
  static const String trashTable = "trash";
  
  static const int maxTitleLength = 100;
  static const int maxContentLength = 10000;
  static const int trashRetentionDays = 30;
}
