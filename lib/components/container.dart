import 'package:flutter/widgets.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;
  final BorderRadius radius;

  const RoundedContainer({Key key, @required this.radius, @required this.child})
      : assert(radius != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: this.radius)),
      child: this.child,
    );
  }
}
