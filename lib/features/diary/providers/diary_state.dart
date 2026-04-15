import '../models/diary_entry.dart';

/// Immutable state class cho Diary feature
class DiaryState {
  final List<DiaryEntry> entries;
  final bool isLoading;

  const DiaryState({
    this.entries = const [],
    this.isLoading = true,
  });

  DiaryState copyWith({
    List<DiaryEntry>? entries,
    bool? isLoading,
  }) {
    return DiaryState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Entries đã sắp xếp theo ngày mới nhất
  List<DiaryEntry> get sortedEntries {
    final sorted = List<DiaryEntry>.from(entries);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }
}
