import 'package:flutter/material.dart';
class ClickBox extends StatefulWidget {
  const ClickBox({
    required this.icons,
    required this.text,
    required this.onTap,
    super.key
  });
  final IconData icons;
  final String text;
  final Function onTap;
  @override
  State<ClickBox> createState() => _ClickBoxState();
}

class _ClickBoxState extends State<ClickBox> {

  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){widget.onTap;},
      child: Container(
        height: height*0.075,
        width: width*0.285 ,
        decoration: BoxDecoration(
          color: Color(0xff32A64F),
          borderRadius: BorderRadius.all(Radius.circular(width*0.01)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icons,color: Colors.white,),
            SizedBox(width: width*0.015,),
            Text(widget.text,style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
    );
  }
}
