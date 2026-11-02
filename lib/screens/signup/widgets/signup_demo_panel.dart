import 'package:flutter/material.dart';
import 'package:student_signup/data/demo_presets.dart';

// [Form] Bảng điều khiển demo giúp điền nhanh dữ liệu mẫu và kiểm tra hành vi form
class SignupDemoPanel extends StatelessWidget {
  final AutovalidateMode autovalidateMode;
  final ValueChanged<SignupDemoPreset> onPresetSelected;
  final VoidCallback onClear;

  const SignupDemoPanel({
    super.key,
    required this.autovalidateMode,
    required this.onPresetSelected,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // [Form] Card không đổ bóng, bo góc 12 và viền outlineVariant
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Theme(
        // [Form] Loại bỏ đường kẻ chia mặc định khi mở rộng của ExpansionTile
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          leading: Icon(
            Icons.tune_outlined,
            color: colorScheme.primary,
          ),
          title: Text(
            'Bảng điều khiển demo',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'Chế độ kiểm tra: ${autovalidateMode.name}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            // [Form] Wrap tự động xuống dòng giúp hiển thị an toàn trên màn hình hẹp 320 px
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...signupDemoPresets.map(
                  (preset) => ActionChip(
                    key: ValueKey('preset_${preset.id}'),
                    label: Text(preset.label),
                    onPressed: () => onPresetSelected(preset),
                  ),
                ),
                ActionChip(
                  key: const ValueKey('preset_clear'),
                  avatar: const Icon(Icons.clear, size: 16),
                  label: const Text('Xóa form'),
                  onPressed: onClear,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
