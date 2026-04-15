# Ticket 01 — Khởi tạo dự án Flutter

## Mô tả
Tạo project Flutter mới, cấu hình cấu trúc thư mục theo feature-based, thêm các dependencies cần thiết và thiết lập theme cơ bản.

## Công việc
- [ ] Tạo Flutter project: `flutter create daily_planner`
- [ ] Thiết lập cấu trúc thư mục `lib/` theo tech-stack guideline (core, features, shared, routes)
- [ ] Thêm dependencies vào `pubspec.yaml`: flutter_riverpod, go_router, hive_flutter, intl, google_fonts, flutter_svg
- [ ] Cấu hình `analysis_options.yaml` với flutter_lints
- [ ] Tạo `app.dart` với MaterialApp + ThemeData cơ bản (pastel palette từ UI style guide)
- [ ] Tạo `core/theme/app_theme.dart` — định nghĩa light theme & dark theme
- [ ] Tạo `core/theme/app_colors.dart` — bảng màu pastel
- [ ] Tạo `core/theme/app_text_styles.dart` — typography (Nunito/Quicksand)
- [ ] Tạo `core/constants/app_spacing.dart` — spacing constants
- [ ] Verify app chạy được trên emulator/device

## Tiêu chí hoàn thành
- App chạy được, hiển thị màn hình trắng với theme pastel
- Cấu trúc thư mục đầy đủ
- Tất cả dependencies cài thành công
