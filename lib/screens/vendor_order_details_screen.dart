import 'package:flutter/material.dart';
import 'package:yesdhobi_ridervendor/theme.dart';
import 'package:yesdhobi_ridervendor/widgets/custom_back_button.dart';

class VendorOrderDetailsScreen extends StatefulWidget {
  final String orderId;
  final String customerName;
  final String customerPhone;

  const VendorOrderDetailsScreen({
    super.key,
    this.orderId = '#YD-9612',
    this.customerName = 'Amit Patel',
    this.customerPhone = '+91 99887 76655',
  });

  @override
  State<VendorOrderDetailsScreen> createState() =>
      _VendorOrderDetailsScreenState();
}

class _VendorOrderDetailsScreenState extends State<VendorOrderDetailsScreen> {
  bool isPackaged = false;
  bool isRiderAssigned = false;

  void _handleAssignRider() {
    setState(() {
      isRiderAssigned = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Rider Zack Colah assigned for pickup.'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _handleMarkPackaged() {
    setState(() {
      isPackaged = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Order marked as Packaged & Ready for Pickup.'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: const CustomBackButton(),
        title: Text(
          'Order ${widget.orderId}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEF2FF),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.customerName.isNotEmpty
                            ? widget.customerName
                                .split(' ')
                                .map((e) => e[0])
                                .take(2)
                                .join()
                            : 'AP',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.customerName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.customerPhone,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Laundry Items Section
              const Text(
                'Laundry Items',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildLaundryItemRow('Cotton Shirt', 'Wash & Iron (x3)'),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _buildLaundryItemRow('Blue Jeans', 'Wash & Iron (x2)'),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _buildLaundryItemRow('Winter Jacket', 'Dry Clean (x1)'),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Order Tracker Section
              const Text(
                'Order Tracker',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTrackerStep(
                      title: 'Order Accepted',
                      subtitle: '10:35 AM, Today',
                      stepState: TrackerStepState.completed,
                      showConnector: true,
                    ),
                    _buildTrackerStep(
                      title: 'Order Received',
                      subtitle: '10:30 AM, Today',
                      stepState: TrackerStepState.completed,
                      showConnector: true,
                    ),
                    _buildTrackerStep(
                      title: 'Packaging',
                      subtitle: isPackaged ? 'Completed' : 'Current step',
                      stepState: isPackaged
                          ? TrackerStepState.completed
                          : TrackerStepState.active,
                      showConnector: true,
                    ),
                    _buildTrackerStep(
                      title: 'Picked by Rider',
                      subtitle: isRiderAssigned
                          ? 'Assigned to Zack Colah'
                          : 'Not assigned',
                      stepState: isRiderAssigned
                          ? TrackerStepState.active
                          : TrackerStepState.inactive,
                      showConnector: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: _handleAssignRider,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2563EB),
                    side: const BorderSide(
                      color: Color(0xFF2563EB),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    isRiderAssigned
                        ? 'Rider Assigned (Zack Colah)'
                        : 'Assign Nearest Rider',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _handleMarkPackaged,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    isPackaged ? 'Packaged & Ready ✓' : 'Mark as Packaged',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLaundryItemRow(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackerStep({
    required String title,
    required String subtitle,
    required TrackerStepState stepState,
    required bool showConnector,
  }) {
    Color dotColor;
    Color titleColor;
    Color subtitleColor;

    switch (stepState) {
      case TrackerStepState.completed:
        dotColor = const Color(0xFF10B981);
        titleColor = const Color(0xFF0F172A);
        subtitleColor = const Color(0xFF64748B);
        break;
      case TrackerStepState.active:
        dotColor = const Color(0xFF2563EB);
        titleColor = const Color(0xFF2563EB);
        subtitleColor = const Color(0xFF2563EB);
        break;
      case TrackerStepState.inactive:
        dotColor = const Color(0xFFCBD5E1);
        titleColor = const Color(0xFF64748B);
        subtitleColor = const Color(0xFF94A3B8);
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: stepState == TrackerStepState.inactive
                      ? Colors.transparent
                      : dotColor,
                  shape: BoxShape.circle,
                  border: stepState == TrackerStepState.inactive
                      ? Border.all(color: dotColor, width: 2)
                      : null,
                ),
              ),
              if (showConnector)
                Expanded(
                  child: Container(
                    width: 2,
                    color: stepState == TrackerStepState.completed
                        ? const Color(0xFF10B981)
                        : const Color(0xFFE2E8F0),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Padding(
            padding: const EdgeInsets.only(bottom: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum TrackerStepState {
  completed,
  active,
  inactive,
}
