import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class SubtitleText extends StatelessWidget {
  final String text;

  const SubtitleText(this.text, {Key key})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextResponsive(text,
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: Colors.grey.shade400, fontSize: 13));
  }
}

class SmallHeadingText extends StatelessWidget {
  final String text;

  const SmallHeadingText(this.text, {Key key})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextResponsive(text,
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: Colors.grey.shade200));
  }
}
