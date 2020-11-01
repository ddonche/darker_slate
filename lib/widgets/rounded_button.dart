import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Color colour;
  final Function onPressed;

  RoundedButton ({this.colour, this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(32.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 48,
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}