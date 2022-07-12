import 'package:flutter/material.dart';
import 'package:flutter_kit/utils/app_route.dart';

class XKHomeListTile extends StatelessWidget {
  const XKHomeListTile({
    Key? key,
    required this.leading,
    required this.title,
    this.onTap,
    this.pushPage,
  })  : assert(onTap != null || pushPage != null),
        super(key: key);

  final String leading;
  final String title;
  final VoidCallback? onTap;
  final Widget? pushPage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(leading),
      title: Text('$title'),
      trailing: Icon(Icons.keyboard_arrow_right_outlined),
      onTap: () {
        if (onTap != null) {
          onTap!.call();
        } else {
          AppRoute.push(context: context, child: pushPage!);
        }
      },
    );
  }
}