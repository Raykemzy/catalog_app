import 'package:catalog_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DsCategoryChip extends StatelessWidget {
  const DsCategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final background = selected
        ? scheme.primary
        : scheme.surfaceContainerHighest;
    final foreground = selected ? scheme.onPrimary : scheme.onSurface;

    return SizedBox(
      height: 48,
      child: Align(
        alignment: Alignment.center,
        child: Opacity(
          opacity: enabled ? 1 : 0.38,
          child: Material(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: InkWell(
              onTap: enabled ? onTap : null,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              splashColor: foreground.withAlpha(31),
              highlightColor: foreground.withAlpha(20),
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: foreground,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
