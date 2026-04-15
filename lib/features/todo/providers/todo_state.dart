import '../models/task.dart';

/// Trạng thái lọc danh sách task
enum FilterState { all, incomplete, completed }

/// Immutable state class cho To-Do feature
class TodoState {
  final List<Task> tasks;
  final FilterState filter;
  final bool isLoading;

  const TodoState({
    this.tasks = const [],
    this.filter = FilterState.all,
    this.isLoading = true,
  });

  TodoState copyWith({
    List<Task>? tasks,
    FilterState? filter,
    bool? isLoading,
  }) {
    return TodoState(
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Task đã lọc theo filter hiện tại, sắp xếp theo priority giảm dần
  List<Task> get filteredTasks {
    List<Task> result;
    switch (filter) {
      case FilterState.incomplete:
        result = tasks.where((t) => !t.isCompleted).toList();
      case FilterState.completed:
        result = tasks.where((t) => t.isCompleted).toList();
      case FilterState.all:
        result = List.of(tasks);
    }
    result.sort((a, b) => b.priority.compareTo(a.priority));
    return result;
  }

  /// Số task đã hoàn thành
  int get completedCount => tasks.where((t) => t.isCompleted).length;

  /// Tổng số task
  int get totalCount => tasks.length;

  /// Tỷ lệ hoàn thành (0.0 - 1.0)
  double get progress => totalCount == 0 ? 0.0 : completedCount / totalCount;
}
