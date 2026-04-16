import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/hive_helper.dart';
import '../models/belonging.dart';

const _uuid = Uuid();

class BelongingNotifier extends StateNotifier<List<Belonging>> {
  BelongingNotifier() : super(const []) {
    load();
  }

  Future<void> load() async {
    final box = await HiveHelper.openBox<Belonging>(HiveHelper.belongingBox);
    state = box.values.toList();
  }

  Future<void> add({
    required String name,
    BelongingStatus status = BelongingStatus.unused,
    String location = '',
  }) async {
    if (name.trim().isEmpty) return;
    final box = await HiveHelper.openBox<Belonging>(HiveHelper.belongingBox);
    final item = Belonging(
      id: _uuid.v4(),
      name: name.trim(),
      status: status,
      location: location.trim(),
    );
    await box.put(item.id, item);
    state = [...state, item];
  }

  Future<void> update(Belonging updated) async {
    final box = await HiveHelper.openBox<Belonging>(HiveHelper.belongingBox);
    if (!box.containsKey(updated.id)) return;
    await box.put(updated.id, updated);
    state = state.map((b) => b.id == updated.id ? updated : b).toList();
  }

  Future<void> delete(String id) async {
    final box = await HiveHelper.openBox<Belonging>(HiveHelper.belongingBox);
    await box.delete(id);
    state = state.where((b) => b.id != id).toList();
  }
}

final belongingProvider =
    StateNotifierProvider<BelongingNotifier, List<Belonging>>((ref) {
  return BelongingNotifier();
});
