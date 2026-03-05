import 'package:catalog_app/core/theme/theme_mode_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeMode>(
      builder: (context, mode) {
        final brightness = Theme.of(context).brightness;
        final isDark =
            mode == ThemeMode.dark ||
            (mode == ThemeMode.system && brightness == Brightness.dark);

        return IconButton(
          tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
          onPressed: () => context.read<ThemeModeCubit>().toggle(),
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
        );
      },
    );
  }
}
