import 'package:flutter/material.dart';
import 'package:yesdhobi_ridervendor/theme.dart';
import 'package:yesdhobi_ridervendor/models/order_flow_model.dart';

class OrderProgressStepper extends StatelessWidget {
  final DeliveryStage currentStage;

  const OrderProgressStepper({
    super.key,
    this.currentStage = DeliveryStage.outForDrop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'ACTIVE DROP',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stepper Items
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Connecting lines
                  Positioned(
                    top: 14,
                    left: constraints.maxWidth * 0.12,
                    right: constraints.maxWidth * 0.12,
                    child: Row(
                      children: [
                        // Line 1: Accepted -> Picked Up (Green)
                        Expanded(
                          child: Container(
                            height: 2.5,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        // Line 2: Picked Up -> Out for Drop (Green)
                        Expanded(
                          child: Container(
                            height: 2.5,
                            color: currentStage == DeliveryStage.outForDrop ||
                                    currentStage == DeliveryStage.delivered
                                ? const Color(0xFF10B981)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        // Line 3: Out for Drop -> Delivered (Gray)
                        Expanded(
                          child: Container(
                            height: 2.5,
                            color: currentStage == DeliveryStage.delivered
                                ? const Color(0xFF10B981)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 4 Steps
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStep(
                        label: 'Accepted',
                        type: _StepType.completed,
                      ),
                      _buildStep(
                        label: 'Picked Up',
                        type: _StepType.completed,
                      ),
                      _buildStep(
                        label: 'Out for Drop',
                        type: currentStage == DeliveryStage.delivered
                            ? _StepType.completed
                            : _StepType.active,
                      ),
                      _buildStep(
                        label: 'Delivered',
                        type: currentStage == DeliveryStage.delivered
                            ? _StepType.completed
                            : _StepType.inactive,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String label,
    required _StepType type,
  }) {
    Widget iconWidget;
    Color textColor;
    FontWeight fontWeight;

    switch (type) {
      case _StepType.completed:
        iconWidget = Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFF10B981),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 18,
          ),
        );
        textColor = const Color(0xFF10B981);
        fontWeight = FontWeight.bold;
        break;

      case _StepType.active:
        iconWidget = Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryColor,
              width: 2.5,
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
        );
        textColor = AppTheme.primaryColor;
        fontWeight = FontWeight.bold;
        break;

      case _StepType.inactive:
        iconWidget = Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFCBD5E1),
              shape: BoxShape.circle,
            ),
          ),
        );
        textColor = const Color(0xFF94A3B8);
        fontWeight = FontWeight.w500;
        break;
    }

    return SizedBox(
      width: 76,
      child: Column(
        children: [
          iconWidget,
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

enum _StepType {
  completed,
  active,
  inactive,
}
