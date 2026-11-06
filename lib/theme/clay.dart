import 'package:flutter/material.dart';

class ClayColors {
  static const bg = Color(0xFFE8EEF9);
  static const lavender = Color(0xFFC9B8FF);
  static const mint = Color(0xFFB8F0D8);
  static const peach = Color(0xFFFFD1BA);
  static const sky = Color(0xFFBFE0FF);
  static const text = Color(0xFF3B3552);
  static const textSoft = Color(0xFF7C7794);
  static const danger = Color(0xFFFF8FA3);
}

class ClayContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double depth;
  final bool pressed;

  const ClayContainer({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.radius = 28,
    this.padding = const EdgeInsets.all(18),
    this.depth = 1,
    this.pressed = false,
  });

  @override
  Widget build(BuildContext context) {
    final d = pressed ? depth * 0.4 : depth;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(Colors.white.withOpacity(0.35), color),
            color,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.95),
            offset: Offset(-8 * d, -8 * d),
            blurRadius: 16 * d,
          ),
          BoxShadow(
            color: const Color(0xFF8A7FB8).withOpacity(0.35),
            offset: Offset(9 * d, 10 * d),
            blurRadius: 20 * d,
          ),
        ],
      ),
      child: child,
    );
  }
}

class ClayButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final VoidCallback? onPressed;
  final bool loading;

  const ClayButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = ClayColors.lavender,
    this.loading = false,
  });

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.loading;
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _down = true) : null,
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: enabled ? widget.onPressed : null,
      child: ClayContainer(
        color: widget.color,
        radius: 24,
        pressed: _down,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (widget.loading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            else ...[
              if (widget.icon != null) ...[
                Icon(widget.icon, color: ClayColors.text),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: const TextStyle(
                  color: ClayColors.text,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
class ClayField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;

  const ClayField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        maxLength: maxLength,
        style: const TextStyle(
            color: ClayColors.text, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: ClayColors.textSoft),
          prefixIcon: Icon(icon, color: ClayColors.textSoft),
          filled: true,
          fillColor: const Color(0xFFF1F4FC),
          counterText: '',
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.9), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: ClayColors.lavender, width: 2.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: ClayColors.danger, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: ClayColors.danger, width: 2.5),
          ),
        ),
      ),
    );
  }
}

ThemeData clayTheme() => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ClayColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ClayColors.lavender,
        surface: ClayColors.bg,
      ),
      fontFamily: 'Roboto',
    );
