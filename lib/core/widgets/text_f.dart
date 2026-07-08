import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaga_saku/core/core.dart';

class TextF extends StatefulWidget {
  const TextF({
    super.key,
    this.controller,
    this.errorMessage,
    this.isValid = false,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.obscureText,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.textInputAction,
    this.onTap,
    this.autoFillHints,
    this.description,
    this.labelTextStyle,
    this.noErrorSpace = false,
    this.focusNode,
    this.backgroundColor,
    this.hint,
    this.validatorListener,
    this.height,
    this.textStyle,
    this.maxLines = 1,
    this.semantic,
  });

  final TextEditingController? controller;
  final bool isValid;
  final String? errorMessage;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final Widget? prefixIcon;
  final bool? obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final Function(String)? validatorListener;
  final List<String>? autoFillHints;
  final String? description;
  final TextStyle? labelTextStyle;
  final TextStyle? textStyle;
  final bool noErrorSpace;
  final FocusNode? focusNode;
  final Color? backgroundColor;
  final String? hint;
  final double? height;
  final int maxLines;
  final String? semantic;

  @override
  TextFState createState() => TextFState();
}

class TextFState extends State<TextF> {
  late FocusNode _fn;

  /// True when this State created [_fn] itself (no [TextF.focusNode] passed).
  /// A caller-owned FocusNode must NOT be disposed here.
  bool _ownsFocusNode = false;
  bool _isFocus = false;
  bool _isError = false;
  bool _isFirstLoad = true;

  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _fn = widget.focusNode ?? FocusNode();
    _fn.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocus = _fn.hasFocus;

      /// Check if focus changed
      if (!_isFocus) {
        _isError = !widget.isValid;
      }
    });
  }

  @override
  void dispose() {
    _fn.removeListener(_onFocusChange);
    if (_ownsFocusNode) _fn.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _updateStatus() {
    if (_isFirstLoad) {
      _isFirstLoad = false;
    } else {
      if (_isFocus) {
        _isError = !widget.isValid;
      }
    }
  }

  void setIsError({required bool isError}) {
    setState(() {
      if (_isFirstLoad) {
        _isFirstLoad = false;
      } else {
        _isError = isError;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateStatus();

    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: double.maxFinite,
                height: widget.height ?? Dimens.textField,
                decoration: BoxDecoration(
                  color:
                      widget.backgroundColor ??
                      (widget.enabled
                          ? Theme.of(context).brightness == Brightness.dark
                                ? Palette.formDark
                                : Palette.form
                          : context.colors.shadow),
                  border: Border.all(
                    color: _isError
                        ? context.colors.red!
                        : Theme.of(context).brightness == Brightness.dark
                        ? Palette.formDark
                        : Palette.form,
                  ),
                  borderRadius: BorderRadius.circular(Dimens.cornerRadiusForm),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: Dimens.space4),
              ),
              Positioned.fill(child: _textFormField),
            ],
          ),
          if (widget.description != null && !_isError)
            Padding(
              padding: EdgeInsets.only(top: Dimens.space6),
              child: Text(
                widget.description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _isError ? context.colors.red! : context.colors.shadow,
                ),
              ),
            ),
          if (!widget.noErrorSpace) ...[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isError && widget.errorMessage != null
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: Dimens.space16,
                        top: Dimens.space4,
                      ),
                      child: Text(
                        widget.errorMessage ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.colors.red,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ],
      ),
    );
  }

  Widget get _textFormField => Semantics(
    label: widget.semantic,
    child: TextFormField(
      autofillHints: widget.autoFillHints,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      enabled: widget.enabled,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      obscureText: widget.obscureText ?? false,
      focusNode: _fn,
      maxLines: widget.maxLines,
      onTap: widget.onTap,
      style: widget.textStyle ?? Theme.of(context).textTheme.bodyMedium500,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimens.space16,
          vertical: Dimens.space16,
        ),
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        border: InputBorder.none,
        errorBorder: InputBorder.none,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        suffixIconColor: Theme.of(context).brightness == Brightness.dark
            ? Palette.iconDark
            : Palette.icon,
        suffixIconConstraints: widget.suffixIconConstraints,
        alignLabelWithHint: true,
        hintText: widget.hint,
        floatingLabelBehavior: widget.hint != null
            ? FloatingLabelBehavior.always
            : null,
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
      ),
      onChanged: (String value) =>
          _debouncer.run(() => widget.validatorListener?.call(value)),
      onSaved: (String? value) => widget.validatorListener?.call(value ?? ''),
    ),
  );
}
