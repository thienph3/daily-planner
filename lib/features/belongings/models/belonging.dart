import 'package:hive/hive.dart';

part 'belonging.g.dart';

/// Trạng thái sử dụng đồ dùng
@HiveType(typeId: 9)
enum BelongingStatus {
  @HiveField(0)
  unused, // Chưa dùng

  @HiveField(1)
  inUse, // Đang dùng

  @HiveField(2)
  used, // Đã dùng
}

@HiveType(typeId: 8)
class Belonging extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final BelongingStatus status;

  @HiveField(3)
  final String location;

  Belonging({
    required this.id,
    required this.name,
    this.status = BelongingStatus.unused,
    this.location = '',
  });

  Belonging copyWith({
    String? id,
    String? name,
    BelongingStatus? status,
    String? location,
  }) {
    return Belonging(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      location: location ?? this.location,
    );
  }
}
