import 'package:flutter/material.dart';

class BtnOnClickCircularIndicator extends StatelessWidget {
  const BtnOnClickCircularIndicator({
    Key key,
    this.width,
    this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
