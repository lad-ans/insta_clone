import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false, String titleText, bool removeBackButton: false}) {
  return AppBar(
    /**removing or seting backButton */
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? "Dilena" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "Signatra" : "",
        fontSize: isAppTitle ? 50 : 22,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
