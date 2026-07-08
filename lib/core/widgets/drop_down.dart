import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';

class DropDown<T> extends StatefulWidget {
  const DropDown({
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
    this.hint,
    this.hintIsVisible = true,
    this.prefixIcon,
    this.isScrollPicker = false,
    this.scrollPickerValues,
    this.scrollPickerUnit,
    this.backgroundColor,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final bool hintIsVisible;
  final String? hint;
  final ValueChanged<T?>? onChanged;
  final Widget? prefixIcon;
  final bool isScrollPicker;
  final List<int>? scrollPickerValues;
  final String? scrollPickerUnit;
  final Color? backgroundColor;

  @override
  State<DropDown<T>> createState() => _DropDownState();
}

class _DropDownState<T> extends State<DropDown<T>> {
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    if (widget.isScrollPicker && widget.scrollPickerValues != null) {
      final initialIndex = widget.scrollPickerValues!.indexOf(
        widget.value as int,
      );
      _scrollController = FixedExtentScrollController(
        initialItem: initialIndex != -1 ? initialIndex : 0,
      );
    }
  }

  @override
  void dispose() {
    // Guard must match initState: the controller is only created when BOTH
    // isScrollPicker AND scrollPickerValues != null, otherwise the late field
    // is uninitialized and .dispose() would throw LateInitializationError.
    if (widget.isScrollPicker && widget.scrollPickerValues != null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _showScrollPickerSheet() {
    final values = widget.scrollPickerValues ?? [];
    int tempSelected = widget.value as int;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Palette.cardDark
          : Palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimens.cornerRadius),
        ),
      ),
      builder: (_) => SafeArea(
        child: SizedBox(
          height: Dimens.space280,
          child: Column(
            children: [
              SizedBox(height: Dimens.space24),
              Expanded(
                child: StatefulBuilder(
                  builder: (_, setModalState) => Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 48,
                        margin: EdgeInsets.symmetric(
                          horizontal: Dimens.space48,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Palette.formDark
                              : Palette.form,
                          borderRadius: BorderRadius.circular(
                            Dimens.cornerRadiusForm,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Dimens.space105,
                            child: ListWheelScrollView.useDelegate(
                              controller: _scrollController,
                              itemExtent: 48,
                              diameterRatio: 2.5,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: (index) {
                                setModalState(() {
                                  tempSelected = values[index];
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: values.length,
                                builder: (_, index) {
                                  final val = values[index];
                                  final isSelected = val == tempSelected;
                                  return Center(
                                    child: Text(
                                      '$val',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: isSelected ? 22 : 16,
                                            color: isSelected
                                                ? Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.dark
                                                      ? Palette.iconDark
                                                      : Palette.text
                                                : Theme.of(context).hintColor,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Text(
                            widget.scrollPickerUnit ?? '',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimens.space24),
                child: Button(
                  width: double.maxFinite,
                  title: Strings.of(context)!.save,
                  onPressed: () {
                    widget.onChanged?.call(tempSelected as T);
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // ← tambah ini
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Palette.cardDark
          : Palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimens.cornerRadius),
        ),
      ),
      builder: (_) => SafeArea(
        child: ConstrainedBox(
          // ← wrap dengan ConstrainedBox
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: Padding(
            padding: EdgeInsets.all(Dimens.space24),
            child: SingleChildScrollView(
              // ← tambah scroll
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.items
                    .where((item) => item.value != null)
                    .map(
                      (item) => ListTile(
                        title: DefaultTextStyle(
                          style: Theme.of(context).textTheme.bodyMedium!,
                          child: item.child,
                        ),
                        trailing: widget.value == item.value
                            ? Icon(
                                Icons.check,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Palette.iconDark
                                    : Palette.icon,
                              )
                            : null,
                        onTap: () {
                          widget.onChanged?.call(item.value);
                          context.pop();
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String get _displayLabel {
    if (widget.isScrollPicker) {
      final val = widget.value;
      if (val == null || val == 0) return widget.hint ?? '';
      return '$val';
    }
    final selected = widget.items
        .where((item) => item.value == widget.value)
        .firstOrNull;
    if (selected == null || widget.value == null) return widget.hint ?? '';
    return '';
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (widget.hintIsVisible) ...{
        Text(
          widget.hint ?? '',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
        ),
        SpacerV(value: Dimens.space6),
      },
      GestureDetector(
        onTap: widget.isScrollPicker
            ? _showScrollPickerSheet
            : _showBottomSheet,
        child: Container(
          width: double.maxFinite,
          height: Dimens.textField,
          decoration: BoxDecoration(
            color:
                widget.backgroundColor ??
                (Theme.of(context).brightness == Brightness.dark
                    ? Palette.formDark
                    : Palette.form),
            borderRadius: BorderRadius.circular(Dimens.cornerRadiusForm),
          ),
          padding: EdgeInsets.symmetric(horizontal: Dimens.space16),
          child: Row(
            children: [
              if (widget.prefixIcon != null) ...[
                widget.prefixIcon!,
                SizedBox(width: Dimens.space8),
              ],
              Expanded(
                child: widget.isScrollPicker
                    ? Text(
                        _displayLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: (widget.value == null || widget.value == 0)
                              ? Theme.of(context).hintColor
                              : null,
                        ),
                      )
                    : widget.value != null
                    ? Builder(
                        builder: (_) {
                          final selected = widget.items
                              .where((item) => item.value == widget.value)
                              .firstOrNull;
                          return DefaultTextStyle(
                            style: Theme.of(context).textTheme.bodyMedium!,
                            child:
                                selected?.child ??
                                Text(
                                  widget.hint ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                ),
                          );
                        },
                      )
                    : Text(
                        widget.hint ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Palette.iconDark
                    : Palette.icon,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
