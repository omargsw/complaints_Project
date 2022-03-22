import 'package:flutter/material.dart';

import 'colors.dart';

class AppAppBar extends StatelessWidget with PreferredSizeWidget{
  final String? title;
  bool show;
  AppAppBar({Key? key, this.title,required this.show}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    if(show){
      return AppBar(
        title: Text(title!, style: TextStyle(color: ColorForDesign().white, fontSize: 25),),
        centerTitle: true,
        backgroundColor: ColorForDesign().blue,
      );
    }else{
      return Container(
        height: 0,
      );
    }
  }
}

