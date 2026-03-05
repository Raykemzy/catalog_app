import 'package:catalog_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DsSearchBar extends StatefulWidget {
  const DsSearchBar({super.key, required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<DsSearchBar> createState() => _DsSearchBarState();
}

class _DsSearchBarState extends State<DsSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant DsSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 48,
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: textTheme.bodyMedium,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: colors.onSurfaceVariant),
          hintText: 'Search products',
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }
}
