import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ConnectionIndicator extends StatelessWidget {
  final bool isConnected;
  const ConnectionIndicator({super.key, required this.isConnected});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isConnected ? AppColors.successBg : AppColors.errorBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: isConnected ? AppColors.success : AppColors.error, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(isConnected ? 'Central OK' : 'Hors ligne', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isConnected ? AppColors.success : AppColors.error)),
      ]),
    );
  }
}
