import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffixIcon;
  final bool obscureText;
  final double maxWidth;
  final double height;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;

  const AuthTextField({
    super.key,
    this.controller,
    this.hintText,
    this.suffixIcon,
    this.obscureText = false,
    this.maxWidth = 450.0,
    this.height = 48.0,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            // style: const TextStyle(fontSize: 16.0, color: Colors.black87),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,

              // 1. DISABLES THE GREY HOVER EFFECT ON WEB/DESKTOP
              hoverColor: Colors.transparent,

              // 2. DISPLAYS THE HINT TEXT WHEN EMPTY
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black54),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 18.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),

              suffixIcon: Padding(
                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 15, 0),
                child: suffixIcon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
