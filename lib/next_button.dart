import 'package:flutter/material.dart';

import 'utils.dart';

class NextButton extends StatefulWidget {
  const NextButton({required this.onTap, this.isCanClick = true, required this.text});
  final bool isCanClick;
  final VoidCallback onTap;
  final String text;

  @override
  State<StatefulWidget> createState() {
    return NextButtonState();
  }
}

class NextButtonState extends State<NextButton> {
  Color color = const Color(0xFFAA1F52);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (TapUpDetails _) {
        if (widget.isCanClick) {
          setState(() {
            color = const Color(0xFFAA1F52);
          });
        }
      },
      onTapDown: (TapDownDetails _) {
        if (widget.isCanClick) {
          setState(() {
            color = const Color(0xFFCC1F52);
          });
        }
      },
      onTapCancel: () {
        if (widget.isCanClick) {
          setState(() {
            color = const Color(0xFFAA1F52);
          });
        }
      },
      onTap: widget.isCanClick ? widget.onTap : null,
      child: Container(
        width: setWidth(327),
        height: setHeight(48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(setHeight(3)),
          color: !widget.isCanClick ? const Color(0x44AA1F52) : color,
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(color: Colors.white, fontSize: setSp(16)),
          ),
        ),
      ),
    );
  }
}
