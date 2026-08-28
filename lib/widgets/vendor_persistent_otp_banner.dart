import 'package:flutter/material.dart';
import 'package:yesdhobi_ridervendor/models/vendor_order_model.dart';
import 'package:yesdhobi_ridervendor/services/vendor_order_service.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_rider_booked_screen.dart';

class VendorPersistentOtpBanner extends StatelessWidget {
  const VendorPersistentOtpBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VendorOrderModel?>(
      valueListenable: VendorOrderService.instance.activeOtpOrder,
      builder: (context, activeOrder, child) {
        if (activeOrder == null) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VendorRiderBookedScreen(order: activeOrder),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Glowing Icon Container
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.delivery_dining_rounded,
                        color: Color(0xFF60A5FA),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Order & Rider info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${activeOrder.orderId} • Rider Assigned',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Rider: ${activeOrder.assignedRiderName ?? "Zack Colah"}',
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // OTP Highlight Box
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'PICKUP OTP',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            activeOrder.pickupOtp,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
