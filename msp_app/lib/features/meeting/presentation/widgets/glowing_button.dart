import 'package:flutter/material.dart';

const Color orangeDeep = Color(0xFFFF5E13);
const Color orangeMid = Color(0xFFFFA463);

class GlowingButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool isFullWidth;
  final bool isDisabled;
  final bool isCompact; // ✅ NEW: Compact mode

  const GlowingButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.isFullWidth = false,
    this.isDisabled = false,
    this.isCompact = false, // ✅ Default compact
  });

  @override
  State<GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.25,
      end: 0.45,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Compact sizes
    final horizontalPadding = widget.isCompact
        ? 14.0
        : (widget.isFullWidth ? 20.0 : 16.0);
    final verticalPadding = widget.isCompact ? 10.0 : 12.0;
    final iconSize = widget.isCompact ? 18.0 : 20.0;
    final fontSize = widget.isCompact ? 14.0 : 15.0;
    final borderRadius = widget.isCompact ? 12.0 : 14.0;

    return GestureDetector(
      onTapDown: widget.isDisabled
          ? null
          : (_) {
              setState(() => _isPressed = true);
            },
      onTapUp: widget.isDisabled
          ? null
          : (_) {
              setState(() => _isPressed = false);
            },
      onTapCancel: widget.isDisabled
          ? null
          : () {
              setState(() => _isPressed = false);
            },
      onTap: widget.isDisabled ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: widget.isFullWidth ? double.infinity : null,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isDisabled
                      ? [Colors.grey[400]!, Colors.grey[500]!]
                      : [orangeDeep, orangeMid],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isDisabled
                        ? Colors.grey.withOpacity(0.15)
                        : orangeMid.withOpacity(_glowAnimation.value),
                    blurRadius: widget.isCompact ? 12 : 16,
                    spreadRadius: _isPressed ? 0 : (widget.isCompact ? 1 : 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisSize: widget.isFullWidth
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: Colors.white, size: iconSize),

                  SizedBox(width: widget.isCompact ? 6 : 8),

                  Text(
                    widget.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: fontSize,
                      letterSpacing: 0.3,
                    ),
                  ),

                  // Arrow for full width
                  if (widget.isFullWidth && !widget.isCompact) ...[
                    const Spacer(),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      transform: Matrix4.translationValues(
                        _isPressed ? -3 : 0,
                        0,
                        0,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ✅ Outline Variant (Compact)
class GlowingOutlineButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool isFullWidth;
  final bool isCompact;

  const GlowingOutlineButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.isFullWidth = false,
    this.isCompact = false,
  });

  @override
  State<GlowingOutlineButton> createState() => _GlowingOutlineButtonState();
}

class _GlowingOutlineButtonState extends State<GlowingOutlineButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = widget.isCompact
        ? 14.0
        : (widget.isFullWidth ? 20.0 : 16.0);
    final verticalPadding = widget.isCompact ? 10.0 : 12.0;
    final iconSize = widget.isCompact ? 18.0 : 20.0;
    final fontSize = widget.isCompact ? 14.0 : 15.0;
    final borderRadius = widget.isCompact ? 12.0 : 14.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: _isPressed ? orangeMid.withOpacity(0.1) : Colors.transparent,
          border: Border.all(color: orangeMid, width: 2),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: orangeMid.withOpacity(0.25),
                    blurRadius: widget.isCompact ? 8 : 10,
                    spreadRadius: widget.isCompact ? 0 : 1,
                  ),
                ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Row(
          mainAxisSize: widget.isFullWidth
              ? MainAxisSize.max
              : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: orangeDeep, size: iconSize),
            SizedBox(width: widget.isCompact ? 6 : 8),
            Text(
              widget.text,
              style: TextStyle(
                color: orangeDeep,
                fontWeight: FontWeight.w700,
                fontSize: fontSize,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Icon Only Button (Compact)
class GlowingIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final Color? color;
  final bool isSmall; // ✅ Small size option

  const GlowingIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.color,
    this.isSmall = false,
  });

  @override
  State<GlowingIconButton> createState() => _GlowingIconButtonState();
}

class _GlowingIconButtonState extends State<GlowingIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.2,
      end: 0.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ?? orangeMid;
    final size = widget.isSmall ? 48.0 : 56.0;
    final iconSize = widget.isSmall ? 22.0 : 26.0;

    return Tooltip(
      message: widget.tooltip ?? '',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return AnimatedScale(
              scale: _isPressed ? 0.9 : 1.0,
              duration: const Duration(milliseconds: 100),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [orangeDeep, buttonColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: buttonColor.withOpacity(_glowAnimation.value),
                      blurRadius: widget.isSmall ? 12 : 16,
                      spreadRadius: _isPressed ? 0 : (widget.isSmall ? 1 : 2),
                    ),
                  ],
                ),
                child: Icon(widget.icon, color: Colors.white, size: iconSize),
              ),
            );
          },
        ),
      ),
    );
  }
}
