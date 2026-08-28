import 'package:flutter/material.dart';
import 'package:yesdhobi_ridervendor/theme.dart';
import 'package:yesdhobi_ridervendor/widgets/app_logo.dart';
import 'package:yesdhobi_ridervendor/widgets/app_bottom_nav.dart';
import 'package:yesdhobi_ridervendor/screens/rider_order_details_screen.dart';
import 'package:yesdhobi_ridervendor/services/rider_auth_service.dart';
import 'package:yesdhobi_ridervendor/models/pickup_request_notification_model.dart';
import 'package:yesdhobi_ridervendor/services/rider_notification_service.dart';
import 'package:yesdhobi_ridervendor/widgets/incoming_pickup_request_dialog.dart';

class RiderDashboardScreen extends StatefulWidget {
  const RiderDashboardScreen({super.key});

  @override
  State<RiderDashboardScreen> createState() => _RiderDashboardScreenState();
}

class _RiderDashboardScreenState extends State<RiderDashboardScreen> {
  bool get isOnline => RiderAuthService.instance.isOnline;

  @override
  void initState() {
    super.initState();
    RiderNotificationService.instance.activeIncomingRequest
        .addListener(_onIncomingRequest);
  }

  @override
  void dispose() {
    RiderNotificationService.instance.activeIncomingRequest
        .removeListener(_onIncomingRequest);
    super.dispose();
  }

  void _onIncomingRequest() {
    final req =
        RiderNotificationService.instance.activeIncomingRequest.value;
    if (req != null &&
        req.status == PickupRequestStatus.offered &&
        mounted) {
      IncomingPickupRequestDialog.show(context, request: req);
    }
  }

  void _toggleOnlineStatus() {
    final bool currentStatus = RiderAuthService.instance.isOnline;
    if (currentStatus) {
      // Going ONLINE -> OFFLINE with active order check
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Go Offline?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF0F172A),
            ),
          ),
          content: const Text(
            'You will stop receiving new pickup requests, but your current order will remain active.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  RiderAuthService.instance.setOnline(false);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Go Offline',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      RiderAuthService.instance.setOnline(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leadingWidth: 48,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: AppLogo(
            size: 32,
            borderRadius: 8,
            iconSize: 20,
            backgroundColor: AppTheme.primaryColor,
          ),
        ),
        title: const Text(
          'Yes Dhobi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Rider Dashboard',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Manage your status and available deliveries',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Rider Availability',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isOnline ? 'ON' : 'OFF',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isOnline
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Transform.scale(
                        scale: 0.85,
                        child: Switch.adaptive(
                          value: isOnline,
                          activeColor: const Color(0xFF10B981),
                          activeTrackColor: const Color(0xFFD1FAE5),
                          inactiveThumbColor: const Color(0xFF94A3B8),
                          inactiveTrackColor: const Color(0xFFE2E8F0),
                          onChanged: (val) {
                            setState(() {
                              RiderAuthService.instance.setOnline(val);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: "Today's Earnings",
                      value: '₹1,450',
                      subtitle: '+15% from yesterday',
                      subtitleColor: const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Completed',
                      value: '8 Orders',
                      subtitle: 'Target: 12 orders',
                      subtitleColor: const Color(0xFF64748B),
                      valueColor: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Incoming Pickup Request Simulator Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.22),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Incoming Pickup Requests',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Tap Test Alert to simulate incoming pickup',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final sampleRequest =
                            PickupRequestNotificationModel.createDefaultSample();
                        RiderNotificationService.instance
                            .triggerIncomingPickup(sampleRequest);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF2563EB),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Test Alert',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Active Orders
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Orders',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    '(1)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildActiveOrderCard(),
              
              const SizedBox(height: 32),
              
              // Pickup History
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pickup History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    'Refresh',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              _buildHistoryCard(
                name: 'Rahul Sharma',
                address: 'B-402, Shanti Vihar, Sector 45',
                items: '12-15 items',
                timeInfo: 'Completed: 14 Mar • 10:42 AM',
                amount: '₹120',
              ),
              const SizedBox(height: 16),
              _buildHistoryCard(
                name: 'Priya Patel',
                address: 'Flat 12A, Royal Crest Towers, HSR',
                items: '8-10 items',
                timeInfo: 'Completed: 14 Mar • 11:15 AM',
                amount: '₹95',
              ),
              const SizedBox(height: 16),
              _buildHistoryCard(
                name: 'Amit Verma',
                address: 'No. 45, Ground Floor, 5th Cross, Indiranagar',
                items: '20+ items',
                timeInfo: 'Completed: 13 Mar • 6:20 PM',
                amount: '₹185',
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Color subtitleColor,
    Color valueColor = AppTheme.primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrderCard() {
    return Container(
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
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sneha Kapoor',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5)),
                          ),
                          child: const Text(
                            'In Progress',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF64748B)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'B-402, Shanti Vihar, Sector 45',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 16, color: Color(0xFF64748B)),
                        SizedBox(width: 8),
                        Text(
                          '8-12 items',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Flexible(
                          child: Text(
                            'Started: 14 Mar • 10:42 AM',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RiderOrderDetailsScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            minimumSize: Size.zero,
                          ),
                          child: const Text(
                            'View Order',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String name,
    required String address,
    required String items,
    required String timeInfo,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF64748B)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.inventory_2_outlined, size: 16, color: Color(0xFF64748B)),
              const SizedBox(width: 8),
              Text(
                items,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                timeInfo,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
