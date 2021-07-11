import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../all_constant.dart';

class CustomAppbarHome extends StatelessWidget with PreferredSizeWidget {
  final Function onMenuTap;
  final String title;
  CustomAppbarHome({@required this.onMenuTap, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            FontAwesomeIcons.solidBell,
            color: Const.primaryColor,
            size: 20.0,
          ),
          onPressed: () {},
        ),
        Text(
          title,
          style: TextStyle(
            color: Const.primaryColor,
            fontFamily: Const.poppinsMedium,
            fontSize: 18.0,
          ),
        ),
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: onMenuTap,
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class CustomAppbar extends StatelessWidget with PreferredSizeWidget {
  final Function onMenuTap;
  final String title;
  CustomAppbar({@required this.onMenuTap, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.black,
              size: 20.0,
            ),
            onPressed: () {
              Navigator.pop(context);
              // print('notification');
            },
          ),
          Text(
            title,
            style: TextStyle(
              color: Const.primaryColor,
              fontFamily: Const.poppinsMedium,
              fontSize: 18.0,
            ),
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: onMenuTap,
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
