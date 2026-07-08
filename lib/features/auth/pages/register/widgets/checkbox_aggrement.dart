import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

class CheckboxAgreement extends StatelessWidget {
  const CheckboxAgreement({
    required this.value,
    required this.onChanged,
    super.key,
    this.onTapTerms,
    this.onTapPrivacy,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onTapTerms;
  final VoidCallback? onTapPrivacy;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        SizedBox(
          width: Dimens.space24,
          height: Dimens.space24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: BorderSide(
              color: isDark ? Palette.iconDark : Palette.icon,
              width: 1.5,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: Strings.of(context)!.agreeToOur,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? Palette.textDark : Palette.text,
              ),
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: onTapTerms,
                    child: Text(
                      Strings.of(context)!.termsOfService,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                TextSpan(text: ' ${Strings.of(context)!.and} '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: onTapPrivacy,
                    child: Text(
                      Strings.of(context)!.privacyPolicy,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
