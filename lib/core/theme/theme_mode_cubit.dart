import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit() : super(_initialMode());

  static const _boxName = 'catalog_cache';
  static const _themeKey = 'app:theme_mode';

  static ThemeMode _initialMode() {
    if (!Hive.isBoxOpen(_boxName)) {
      return ThemeMode.system;
    }
    final box = Hive.box<dynamic>(_boxName);
    final stored = box.get(_themeKey) as String?;
    return switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.system,
    };
  }

  Future<void> setMode(ThemeMode mode) async {
    emit(mode);
    await _persist(mode);
  }

  Future<void> toggle() async {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isDarkNow =
        state == ThemeMode.dark ||
        (state == ThemeMode.system && brightness == Brightness.dark);
    final next = isDarkNow ? ThemeMode.light : ThemeMode.dark;
    emit(next);
    await _persist(next);
  }

  Future<void> _persist(ThemeMode mode) async {
    if (!Hive.isBoxOpen(_boxName)) {
      return;
    }
    final box = Hive.box<dynamic>(_boxName);
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await box.put(_themeKey, value);
  }
}
