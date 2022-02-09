import 'package:flutter/material.dart';

class BtnNext extends StatelessWidget {

  const BtnNext({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color(0xff3baef0),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 16,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: "Inter",
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
