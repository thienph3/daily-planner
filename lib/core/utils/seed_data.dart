import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../features/belongings/models/belonging.dart';
import '../../features/books/models/book.dart';
import '../../features/books/models/book_category.dart';
import '../../features/classes/models/class_note.dart';
import '../../features/classes/models/class_room.dart';
import '../../features/diary/models/diary_entry.dart';
import '../../features/meal_plan/models/meal_plan.dart';
import '../../features/mood_tracker/models/mood_record.dart';
import '../../features/schedule/models/schedule_item.dart';
import '../../features/settings/models/category.dart';
import '../../features/todo/models/task.dart';
import 'hive_helper.dart';

const _uuid = Uuid();
const _seedKey = 'has_seeded_data';

/// Tạo dữ liệu mẫu cho lần đầu mở app
Future<void> seedSampleData() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_seedKey) == true) return;

  final today = DateTime.now();
  final todayOnly = DateTime(today.year, today.month, today.day);

  await _seedCategories();
  await _seedTasks(todayOnly);
  await _seedSchedule(todayOnly);
  await _seedMealPlan(todayOnly);
  await _seedDiary(todayOnly);
  await _seedMood(todayOnly);
  await _seedBooks();
  await _seedBelongings();
  await _seedClasses();

  await prefs.setBool(_seedKey, true);
}

Future<void> _seedCategories() async {
  final box = await HiveHelper.openBox<Category>(HiveHelper.categoryBox);
  final items = [
    Category(id: _uuid.v4(), name: 'Công việc', emoji: '💼'),
    Category(id: _uuid.v4(), name: 'Cá nhân', emoji: '🌸'),
    Category(id: _uuid.v4(), name: 'Học tập', emoji: '📚'),
  ];
  for (final item in items) {
    await box.put(item.id, item);
  }
}

Future<void> _seedTasks(DateTime today) async {
  final box = await HiveHelper.openBox<Task>(HiveHelper.taskBox);
  final items = [
    Task(
      id: _uuid.v4(),
      title: 'Soạn giáo án tuần tới',
      description: 'Môn Toán lớp 5A',
      date: today,
      priority: 2,
      category: 'Công việc',
    ),
    Task(
      id: _uuid.v4(),
      title: 'Mua sữa và trái cây',
      date: today,
      priority: 1,
      category: 'Cá nhân',
    ),
    Task(
      id: _uuid.v4(),
      title: 'Đọc sách 30 phút',
      date: today,
      priority: 0,
      category: 'Cá nhân',
      isCompleted: true,
    ),
  ];
  for (final item in items) {
    await box.put(item.id, item);
  }
}

Future<void> _seedSchedule(DateTime today) async {
  final box =
      await HiveHelper.openBox<ScheduleItem>(HiveHelper.scheduleBox);
  final items = [
    ScheduleItem(
      id: _uuid.v4(),
      title: 'Dạy lớp 5A',
      startTime: DateTime(today.year, today.month, today.day, 7, 30),
      endTime: DateTime(today.year, today.month, today.day, 9, 0),
      date: today,
      color: 0xFFFFB6C1,
    ),
    ScheduleItem(
      id: _uuid.v4(),
      title: 'Họp tổ chuyên môn',
      startTime: DateTime(today.year, today.month, today.day, 10, 0),
      endTime: DateTime(today.year, today.month, today.day, 11, 0),
      date: today,
      color: 0xFFB5EAD7,
    ),
    ScheduleItem(
      id: _uuid.v4(),
      title: 'Dạy lớp 3B',
      startTime: DateTime(today.year, today.month, today.day, 14, 0),
      endTime: DateTime(today.year, today.month, today.day, 15, 30),
      date: today,
      color: 0xFFFFDAB9,
    ),
  ];
  for (final item in items) {
    await box.put(item.id, item);
  }
}

Future<void> _seedMealPlan(DateTime today) async {
  final box = await HiveHelper.openBox<MealPlan>(HiveHelper.mealPlanBox);
  final meal = MealPlan(
    id: _uuid.v4(),
    date: today,
    breakfast: 'Phở bò + cà phê sữa ☕',
    lunch: 'Cơm tấm sườn bì chả 🍚',
    dinner: 'Bún riêu cua 🍜',
    snacks: ['Trái cây 🍎', 'Sữa chua 🥛'],
  );
  await box.put(meal.id, meal);
}

Future<void> _seedDiary(DateTime today) async {
  final box = await HiveHelper.openBox<DiaryEntry>(HiveHelper.diaryBox);
  final entry = DiaryEntry(
    id: _uuid.v4(),
    date: today,
    content:
        'Hôm nay là ngày đầu tiên dùng app Kawaii Daily Planner! '
        'Cảm thấy rất hào hứng khi có thể ghi chép lại mọi thứ trong ngày. '
        'Hy vọng sẽ duy trì được thói quen viết nhật ký mỗi ngày 🌸',
    mood: '🥰',
  );
  await box.put(entry.id, entry);
}

Future<void> _seedMood(DateTime today) async {
  final box = await HiveHelper.openBox<MoodRecord>(HiveHelper.moodBox);
  // Seed mood cho 3 ngày gần nhất
  final moods = [
    MoodRecord(
      id: _uuid.v4(),
      date: today.subtract(const Duration(days: 2)),
      mood: '😊',
      note: 'Ngày vui vẻ',
    ),
    MoodRecord(
      id: _uuid.v4(),
      date: today.subtract(const Duration(days: 1)),
      mood: '😴',
      note: 'Hơi mệt',
    ),
    MoodRecord(
      id: _uuid.v4(),
      date: today,
      mood: '🥰',
      note: 'Bắt đầu dùng app mới!',
    ),
  ];
  for (final m in moods) {
    await box.add(m);
  }
}

Future<void> _seedBooks() async {
  final catBox =
      await HiveHelper.openBox<BookCategory>(HiveHelper.bookCategoryBox);
  final bookBox = await HiveHelper.openBox<Book>(HiveHelper.bookBox);

  final catId1 = _uuid.v4();
  final catId2 = _uuid.v4();
  await catBox.put(
      catId1, BookCategory(id: catId1, name: 'Giáo dục', emoji: '🎓'));
  await catBox.put(
      catId2, BookCategory(id: catId2, name: 'Tiểu thuyết', emoji: '📖'));

  final books = [
    Book(id: _uuid.v4(), title: 'Totto-chan bên cửa sổ', categoryId: catId1, isRead: true, isPaperBook: true),
    Book(id: _uuid.v4(), title: 'Nhà giả kim', categoryId: catId2, isRead: false, isEbook: true),
    Book(id: _uuid.v4(), title: 'Dạy con kiểu Nhật', categoryId: catId1, isRead: false, isPaperBook: true, isEbook: true),
  ];
  for (final b in books) {
    await bookBox.put(b.id, b);
  }
}

Future<void> _seedBelongings() async {
  final box = await HiveHelper.openBox<Belonging>(HiveHelper.belongingBox);
  final items = [
    Belonging(
      id: _uuid.v4(),
      name: 'Máy chiếu mini',
      status: BelongingStatus.inUse,
      location: 'Phòng giáo viên',
    ),
    Belonging(
      id: _uuid.v4(),
      name: 'Bộ bút màu 48 cây',
      status: BelongingStatus.unused,
      location: 'Ngăn kéo bàn làm việc',
    ),
    Belonging(
      id: _uuid.v4(),
      name: 'Loa bluetooth',
      status: BelongingStatus.used,
      location: 'Tủ đồ ở nhà',
    ),
  ];
  for (final item in items) {
    await box.put(item.id, item);
  }
}

Future<void> _seedClasses() async {
  final classBox =
      await HiveHelper.openBox<ClassRoom>(HiveHelper.classRoomBox);
  final noteBox =
      await HiveHelper.openBox<ClassNote>(HiveHelper.classNoteBox);

  final classId1 = _uuid.v4();
  final classId2 = _uuid.v4();

  await classBox.put(
      classId1, ClassRoom(id: classId1, name: 'Lớp 5A', emoji: '🌟'));
  await classBox.put(
      classId2, ClassRoom(id: classId2, name: 'Lớp 3B', emoji: '🌈'));

  final notes = [
    ClassNote(
      id: _uuid.v4(),
      classId: classId1,
      content: 'Bạn Minh tiến bộ rõ rệt trong môn Toán tuần này',
      date: DateTime.now(),
      tag: NoteTag.student,
    ),
    ClassNote(
      id: _uuid.v4(),
      classId: classId1,
      content: 'Tuần tới kiểm tra giữa kỳ — cần ôn tập chương 3, 4',
      date: DateTime.now(),
      tag: NoteTag.reminder,
    ),
    ClassNote(
      id: _uuid.v4(),
      classId: classId2,
      content: 'Đã dạy xong bài Tập đọc "Con cò"',
      date: DateTime.now(),
      tag: NoteTag.lesson,
    ),
  ];
  for (final n in notes) {
    await noteBox.put(n.id, n);
  }
}
