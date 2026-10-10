import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLarge;
  final bool isSecondary;
  const PrimaryButton({super.key, required this.label, this.icon, this.onPressed, this.isLarge = true, this.isSecondary = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isLarge ? double.infinity : null,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? AppColors.surfaceVariant : AppColors.primary,
          foregroundColor: isSecondary ? AppColors.textPrimary : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: isSecondary ? const BorderSide(color: AppColors.border) : BorderSide.none,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class SmallActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  const SmallActionButton({super.key, required this.label, required this.icon, required this.onTap, this.color});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: (color ?? AppColors.primary).withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: color ?? AppColors.primary),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color ?? AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
        ]),
      ),
    );
  }
}
