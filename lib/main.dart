import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'features/todo/models/task.dart';
import 'features/schedule/models/schedule_item.dart';
import 'features/meal_plan/models/meal_plan.dart';
import 'features/diary/models/diary_entry.dart';
import 'features/mood_tracker/models/mood_record.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Hive.initFlutter();

  // Đăng ký tất cả TypeAdapter
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(ScheduleItemAdapter());
  Hive.registerAdapter(MealPlanAdapter());
  Hive.registerAdapter(DiaryEntryAdapter());
  Hive.registerAdapter(MoodRecordAdapter());

  FlutterNativeSplash.remove();
  runApp(const ProviderScope(child: App()));
}
