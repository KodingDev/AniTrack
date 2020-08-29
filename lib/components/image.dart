import 'package:flutter/widgets.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class Avatar extends StatelessWidget {
  final Widget image;
  final BorderRadius radius;

  const Avatar({Key key, this.image, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: radius ?? BorderRadius.circular(5.0),
        child: ContainerResponsive(child: image));
  }
}
