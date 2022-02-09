import 'package:flutter/material.dart';

class DataNotFound extends StatelessWidget {
  final String title;

  const DataNotFound({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.subtitles_off_outlined,
          size: 100,
          color: Color(0xff3baef0),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                color: Color(0xff373737),
                fontSize: 20,
                fontFamily: "SF Pro Display",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
