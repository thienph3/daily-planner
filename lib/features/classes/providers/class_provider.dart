import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/hive_helper.dart';
import '../models/class_note.dart';
import '../models/class_room.dart';

const _uuid = Uuid();

/// Provider quản lý danh sách lớp học
class ClassRoomNotifier extends StateNotifier<List<ClassRoom>> {
  ClassRoomNotifier() : super(const []) {
    load();
  }

  Future<void> load() async {
    final box = await HiveHelper.openBox<ClassRoom>(HiveHelper.classRoomBox);
    state = box.values.toList();
  }

  Future<void> add({
    required String name,
    String emoji = '🏫',
    int color = 0xFFFFB6C1,
  }) async {
    if (name.trim().isEmpty) return;
    final box = await HiveHelper.openBox<ClassRoom>(HiveHelper.classRoomBox);
    final item = ClassRoom(
      id: _uuid.v4(),
      name: name.trim(),
      emoji: emoji,
      color: color,
    );
    await box.put(item.id, item);
    state = [...state, item];
  }

  Future<void> update(ClassRoom updated) async {
    final box = await HiveHelper.openBox<ClassRoom>(HiveHelper.classRoomBox);
    if (!box.containsKey(updated.id)) return;
    await box.put(updated.id, updated);
    state = state.map((c) => c.id == updated.id ? updated : c).toList();
  }

  Future<void> delete(String id) async {
    final box = await HiveHelper.openBox<ClassRoom>(HiveHelper.classRoomBox);
    await box.delete(id);
    state = state.where((c) => c.id != id).toList();
    // Xóa luôn ghi chú của lớp này
    final noteBox =
        await HiveHelper.openBox<ClassNote>(HiveHelper.classNoteBox);
    final keysToDelete =
        noteBox.keys.where((k) => noteBox.get(k)?.classId == id).toList();
    await noteBox.deleteAll(keysToDelete);
  }
}

final classRoomProvider =
    StateNotifierProvider<ClassRoomNotifier, List<ClassRoom>>((ref) {
  return ClassRoomNotifier();
});

/// Provider quản lý ghi chú theo lớp
class ClassNoteNotifier extends StateNotifier<List<ClassNote>> {
  ClassNoteNotifier() : super(const []) {
    load();
  }

  Future<void> load() async {
    final box = await HiveHelper.openBox<ClassNote>(HiveHelper.classNoteBox);
    state = box.values.toList();
  }

  /// Lấy ghi chú theo classId
  List<ClassNote> notesForClass(String classId) {
    final notes = state.where((n) => n.classId == classId).toList();
    notes.sort((a, b) => b.date.compareTo(a.date));
    return notes;
  }

  Future<void> add({
    required String classId,
    required String content,
    NoteTag tag = NoteTag.other,
  }) async {
    if (content.trim().isEmpty) return;
    final box = await HiveHelper.openBox<ClassNote>(HiveHelper.classNoteBox);
    final note = ClassNote(
      id: _uuid.v4(),
      classId: classId,
      content: content.trim(),
      date: DateTime.now(),
      tag: tag,
    );
    await box.put(note.id, note);
    state = [...state, note];
  }

  Future<void> update(ClassNote updated) async {
    final box = await HiveHelper.openBox<ClassNote>(HiveHelper.classNoteBox);
    if (!box.containsKey(updated.id)) return;
    await box.put(updated.id, updated);
    state = state.map((n) => n.id == updated.id ? updated : n).toList();
  }

  Future<void> delete(String id) async {
    final box = await HiveHelper.openBox<ClassNote>(HiveHelper.classNoteBox);
    await box.delete(id);
    state = state.where((n) => n.id != id).toList();
  }
}

final classNoteProvider =
    StateNotifierProvider<ClassNoteNotifier, List<ClassNote>>((ref) {
  return ClassNoteNotifier();
});
