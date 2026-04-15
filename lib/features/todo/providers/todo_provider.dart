import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/hive_helper.dart';
import '../../../shared/providers/selected_date_provider.dart';
import '../models/task.dart';
import 'todo_state.dart';

const _uuid = Uuid();

/// StateNotifier quản lý logic nghiệp vụ To-Do.
/// Watch selectedDateProvider để tự động load tasks khi ngày thay đổi.
class TodoNotifier extends StateNotifier<TodoState> {
  final Ref _ref;

  TodoNotifier(this._ref) : super(const TodoState()) {
    // Lắng nghe thay đổi ngày từ shared provider
    _ref.listen<DateTime>(selectedDateProvider, (prev, next) {
      loadTasks(next);
    });
    // Load tasks cho ngày ban đầu
    loadTasks(_ref.read(selectedDateProvider));
  }

  /// Load tasks từ Hive cho ngày đã chọn
  Future<void> loadTasks(DateTime date) async {
    state = state.copyWith(isLoading: true);
    final box = await HiveHelper.openBox<Task>(HiveHelper.taskBox);
    final tasksForDate = box.values.where((task) {
      return task.date.year == date.year &&
          task.date.month == date.month &&
          task.date.day == date.day;
    }).toList();

    state = state.copyWith(tasks: tasksForDate, isLoading: false);
  }

  /// Tạo task mới với id duy nhất, validate title, lưu Hive
  Future<void> addTask({
    required String title,
    String description = '',
    int priority = 0,
    String category = '',
  }) async {
    if (title.trim().isEmpty) return;

    final selectedDate = _ref.read(selectedDateProvider);
    final box = await HiveHelper.openBox<Task>(HiveHelper.taskBox);
    final newTask = Task(
      id: _uuid.v4(),
      title: title.trim(),
      description: description,
      isCompleted: false,
      date: selectedDate,
      priority: priority,
      category: category,
    );

    await box.put(newTask.id, newTask);
    state = state.copyWith(tasks: [...state.tasks, newTask]);
  }

  /// Cập nhật task, validate title, lưu Hive
  Future<void> updateTask(Task updatedTask) async {
    if (updatedTask.title.trim().isEmpty) return;

    final box = await HiveHelper.openBox<Task>(HiveHelper.taskBox);
    if (!box.containsKey(updatedTask.id)) return;

    await box.put(updatedTask.id, updatedTask);
    final updatedTasks = state.tasks.map((t) {
      return t.id == updatedTask.id ? updatedTask : t;
    }).toList();

    state = state.copyWith(tasks: updatedTasks);
  }

  /// Xóa task khỏi Hive
  Future<void> deleteTask(String taskId) async {
    final box = await HiveHelper.openBox<Task>(HiveHelper.taskBox);
    if (!box.containsKey(taskId)) return;

    await box.delete(taskId);
    final updatedTasks = state.tasks.where((t) => t.id != taskId).toList();
    state = state.copyWith(tasks: updatedTasks);
  }

  /// Đảo trạng thái isCompleted
  Future<void> toggleComplete(String taskId) async {
    final box = await HiveHelper.openBox<Task>(HiveHelper.taskBox);
    final task = state.tasks.firstWhere(
      (t) => t.id == taskId,
      orElse: () => throw StateError('Task not found: $taskId'),
    );

    final toggled = task.copyWith(isCompleted: !task.isCompleted);
    await box.put(toggled.id, toggled);

    final updatedTasks = state.tasks.map((t) {
      return t.id == taskId ? toggled : t;
    }).toList();
    state = state.copyWith(tasks: updatedTasks);
  }

  /// Thay đổi filter
  void setFilter(FilterState filter) {
    state = state.copyWith(filter: filter);
  }

  /// Lấy danh sách task chưa hoàn thành từ ngày hôm trước
  Future<List<Task>> getYesterdayIncompleteTasks() async {
    final box = await HiveHelper.openBox<Task>(HiveHelper.taskBox);
    final selectedDate = _ref.read(selectedDateProvider);
    final yesterday = selectedDate.subtract(const Duration(days: 1));

    return box.values.where((task) {
      return task.date.year == yesterday.year &&
          task.date.month == yesterday.month &&
          task.date.day == yesterday.day &&
          !task.isCompleted;
    }).toList();
  }

  /// Clone các task được chọn sang ngày hiện tại với id mới
  Future<void> carryOverTasks(List<Task> tasks) async {
    if (tasks.isEmpty) return;

    final selectedDate = _ref.read(selectedDateProvider);
    final box = await HiveHelper.openBox<Task>(HiveHelper.taskBox);
    final newTasks = <Task>[];

    for (final task in tasks) {
      final copy = task.copyWith(
        id: _uuid.v4(),
        date: selectedDate,
        isCompleted: false,
      );
      await box.put(copy.id, copy);
      newTasks.add(copy);
    }

    state = state.copyWith(tasks: [...state.tasks, ...newTasks]);
  }
}

/// Riverpod provider cho TodoNotifier
final todoProvider = StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  return TodoNotifier(ref);
});
