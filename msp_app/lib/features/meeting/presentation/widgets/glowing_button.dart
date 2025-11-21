import 'package:flutter/material.dart';

const Color orangeDeep = Color(0xFFFF5E13);
const Color orangeMid = Color(0xFFFFA463);

class GlowingButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const GlowingButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [orangeDeep, orangeMid]),
          boxShadow: [
            BoxShadow(
              color: orangeMid.withOpacity(0.17),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
          borderRadius: BorderRadius.circular(32),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
