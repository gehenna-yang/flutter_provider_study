import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? titletxt;
  final Widget? bottomNavigationBar;

  const DefaultLayout({
    this.backgroundColor,
    this.titletxt,
    this.bottomNavigationBar,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar(){
    if(titletxt == null){
      return null;
    } else {
      return AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(titletxt!, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
        foregroundColor: Colors.black,
      );
    }
  }

}