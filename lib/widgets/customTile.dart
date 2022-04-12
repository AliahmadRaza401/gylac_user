import 'package:flutter/material.dart';
class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? icon;
  final Widget? subtitle;
  final Widget? cat;
  final Widget? trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  CustomTile({
    required this.leading,
    required this.title,
     this.icon,
    this.subtitle,
    this.trailing,
    this.margin = const EdgeInsets.all(0),
    this.onTap,
    this.onLongPress,
    this.mini = true, this.cat,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: mini ? 10 : 0),
        margin: margin,
        child: Row(
          children: <Widget>[
            leading, 
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: mini ? 10 : 15),
               // padding: EdgeInsets.symmetric(vertical: mini ? 3 : 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    title,
                    
                    
                  ],
                ),

              ),
            ),
            icon!,
          ],
        ),
      ),
    );
  }
}