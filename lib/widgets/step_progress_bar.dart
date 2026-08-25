import 'package:flutter/material.dart';
import 'package:yesdhobi_ridervendor/theme.dart';

class StepProgressBar extends StatelessWidget {
  final int step;
  final int totalSteps;
  final double progress;
  final String percentageText;

  const StepProgressBar({
    super.key,
    required this.step,
    this.totalSteps = 3,
    required this.progress,
    required this.percentageText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'STEP $step OF $totalSteps',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              percentageText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE2E8F0),
            color: AppTheme.secondaryColor,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
