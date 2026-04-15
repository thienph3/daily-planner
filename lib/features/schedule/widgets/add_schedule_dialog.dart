import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/schedule_item.dart';
import 'pastel_color_picker.dart';

/// Dialog thêm/sửa hoạt động. Dùng chung cho cả add và edit.
class AddScheduleDialog extends StatefulWidget {
  /// null = thêm mới, non-null = sửa
  final ScheduleItem? existingItem;

  const AddScheduleDialog({super.key, this.existingItem});

  @override
  State<AddScheduleDialog> createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends State<AddScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late int _selectedColor;
  String? _timeError;

  bool get _isEditing => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.existingItem;
    _titleController = TextEditingController(text: item?.title ?? '');
    _startTime = item != null
        ? TimeOfDay.fromDateTime(item.startTime)
        : const TimeOfDay(hour: 8, minute: 0);
    _endTime = item != null
        ? TimeOfDay.fromDateTime(item.endTime)
        : const TimeOfDay(hour: 9, minute: 0);
    _selectedColor = item?.color ?? PastelColorPicker.pastelColors.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        _isEditing ? 'Sửa hoạt động' : 'Thêm hoạt động',
        style: const TextStyle(
          color: Color(0xFF5C4033),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Tiêu đề',
                  hintText: 'Nhập tên hoạt động...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFFFB6C1), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tiêu đề không được để trống';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTimePicker(
                context,
                label: 'Bắt đầu',
                time: _startTime,
                timeFormat: timeFormat,
                onPicked: (t) => setState(() {
                  _startTime = t;
                  _timeError = null;
                }),
              ),
              const SizedBox(height: 12),
              _buildTimePicker(
                context,
                label: 'Kết thúc',
                time: _endTime,
                timeFormat: timeFormat,
                onPicked: (t) => setState(() {
                  _endTime = t;
                  _timeError = null;
                }),
              ),
              if (_timeError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _timeError!,
                  style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 12),
                ),
              ],
              const SizedBox(height: 16),
              const Text(
                'Màu sắc',
                style: TextStyle(
                  color: Color(0xFF5C4033),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              PastelColorPicker(
                selectedColor: _selectedColor,
                onColorSelected: (c) => setState(() => _selectedColor = c),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy', style: TextStyle(color: Color(0xFF8B7D6B))),
        ),
        ElevatedButton(
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFB6C1),
            foregroundColor: const Color(0xFF5C4033),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Lưu'),
        ),
      ],
    );
  }

  Widget _buildTimePicker(
    BuildContext context, {
    required String label,
    required TimeOfDay time,
    required DateFormat timeFormat,
    required ValueChanged<TimeOfDay> onPicked,
  }) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) onPicked(picked);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFCCCCCC)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 20, color: Color(0xFF8B7D6B)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Color(0xFF8B7D6B))),
            const Spacer(),
            Text(
              timeFormat.format(dt),
              style: const TextStyle(
                color: Color(0xFF5C4033),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;

    if (endMinutes <= startMinutes) {
      setState(() => _timeError = 'Giờ kết thúc phải sau giờ bắt đầu');
      return;
    }

    final now = DateTime.now();
    final startDt = DateTime(now.year, now.month, now.day, _startTime.hour, _startTime.minute);
    final endDt = DateTime(now.year, now.month, now.day, _endTime.hour, _endTime.minute);

    Navigator.of(context).pop({
      'title': _titleController.text.trim(),
      'startTime': startDt,
      'endTime': endDt,
      'color': _selectedColor,
    });
  }
}
