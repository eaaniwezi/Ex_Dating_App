import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  Loading({
    this.color,
  });

  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: color ?? Colors.black.withOpacity(0.2),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
}
