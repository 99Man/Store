import 'package:fire/utils/text.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const Button(
      {super.key,
      required this.onTap,
      required this.title,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 51,
        width: 147,
        decoration: BoxDecoration(
          color: Color(0xFF2D201C),
          borderRadius: BorderRadius.circular(70),
        ),
        child: Center(
            child: loading
                ? CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  )
                : text(title, 15, Colors.white, FontWeight.bold)),
      ),
    );
  }
}
