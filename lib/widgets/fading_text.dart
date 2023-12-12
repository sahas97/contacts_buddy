import 'package:flutter/material.dart';

class FadingText extends StatefulWidget {
  final String message;

  const FadingText({required this.message, Key? key}) : super(key: key);

  @override
  State<FadingText> createState() => _FadingTextState();
}

class _FadingTextState extends State<FadingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Text(
        widget.message,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
