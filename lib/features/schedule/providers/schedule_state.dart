import '../models/schedule_item.dart';

/// Immutable state class cho Schedule feature
class ScheduleState {
  final List<ScheduleItem> items;
  final bool isLoading;

  const ScheduleState({
    this.items = const [],
    this.isLoading = true,
  });

  ScheduleState copyWith({
    List<ScheduleItem>? items,
    bool? isLoading,
  }) {
    return ScheduleState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Danh sách items đã sắp xếp theo startTime tăng dần
  List<ScheduleItem> get sortedItems {
    final sorted = List<ScheduleItem>.of(items);
    sorted.sort((a, b) => a.startTime.compareTo(b.startTime));
    return sorted;
  }
}
