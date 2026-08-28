import 'package:flutter/material.dart';
import 'package:yesdhobi_ridervendor/theme.dart';
import 'package:yesdhobi_ridervendor/models/order_flow_model.dart';
import 'package:yesdhobi_ridervendor/widgets/app_bottom_nav.dart';
import 'package:yesdhobi_ridervendor/screens/rider_order_details_screen.dart';

class OrderHistoryItem {
  final String orderId;
  final String date;
  final String status;
  final String fromAddress;
  final String toAddress;
  final String payout;
  final String customerName;

  const OrderHistoryItem({
    required this.orderId,
    required this.date,
    required this.status,
    required this.fromAddress,
    required this.toAddress,
    required this.payout,
    required this.customerName,
  });
}

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String selectedDateFilter = 'Last 30 Days';
  String selectedStatusFilter = 'All Statuses';

  final List<OrderHistoryItem> allOrders = const [
    OrderHistoryItem(
      orderId: '#YD-90823',
      date: '12th Oct 2026',
      status: 'COMPLETED',
      customerName: 'Rahul Sharma',
      fromAddress: 'Rahul Sharma, Sector 45',
      toAddress: 'Yes Dhobi Sector 44',
      payout: '₹65.00',
    ),
    OrderHistoryItem(
      orderId: '#YD-90761',
      date: '11th Oct 2026',
      status: 'COMPLETED',
      customerName: 'Karan Mehra',
      fromAddress: 'Karan Mehra, Indiranagar',
      toAddress: 'Yes Dhobi Indiranagar',
      payout: '₹140.00',
    ),
    OrderHistoryItem(
      orderId: '#YD-90512',
      date: '09th Oct 2026',
      status: 'CANCELLED',
      customerName: 'Supriya Sen',
      fromAddress: 'Supriya Sen, Domlur',
      toAddress: 'Yes Dhobi Indiranagar',
      payout: '₹0.00',
    ),
    OrderHistoryItem(
      orderId: '#YD-90119',
      date: '07th Oct 2026',
      status: 'COMPLETED',
      customerName: 'Gaurav Das',
      fromAddress: 'Gaurav Das, Koramangala',
      toAddress: 'Yes Dhobi HSR',
      payout: '₹95.00',
    ),
  ];

  List<OrderHistoryItem> get filteredOrders {
    if (selectedStatusFilter == 'All Statuses') {
      return allOrders;
    }
    return allOrders
        .where((order) => order.status.toUpperCase() == selectedStatusFilter.toUpperCase())
        .toList();
  }

  void _openOrderDetails(OrderHistoryItem item) {
    final state = OrderFlowState(
      orderId: item.orderId,
      customerName: item.customerName,
      customerAddress: item.fromAddress,
      deliveryAddress: item.toAddress,
      payout: item.payout,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RiderOrderDetailsScreen(orderState: state),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Brand Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.sync_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Yes Dhobi',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'RIDER',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F46E5),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title and Subtitle
              const Text(
                'Order History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Overview of all your past orders',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 18),

              // Filters Row
              Row(
                children: [
                  // Filter 1: Date Dropdown
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedDateFilter,
                          isDense: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF64748B), size: 20),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                selectedDateFilter = val;
                              });
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'Last 30 Days',
                              child: Text('Last 30 Days'),
                            ),
                            DropdownMenuItem(
                              value: 'Last 7 Days',
                              child: Text('Last 7 Days'),
                            ),
                            DropdownMenuItem(
                              value: 'All Time',
                              child: Text('All Time'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Filter 2: Status Dropdown
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedStatusFilter,
                          isDense: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF64748B), size: 20),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                selectedStatusFilter = val;
                              });
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'All Statuses',
                              child: Text('All Statuses'),
                            ),
                            DropdownMenuItem(
                              value: 'COMPLETED',
                              child: Text('Completed'),
                            ),
                            DropdownMenuItem(
                              value: 'CANCELLED',
                              child: Text('Cancelled'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Orders List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredOrders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (ctx, index) {
                  final order = filteredOrders[index];
                  final isCompleted = order.status == 'COMPLETED';

                  return InkWell(
                    onTap: () => _openOrderDetails(order),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: ID and Date
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.orderId,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                order.date,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // From Address
                          Text(
                            'From: ${order.fromAddress}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF334155),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // To Address
                          Text(
                            'To: ${order.toAddress}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF334155),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 14),

                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
                          const SizedBox(height: 12),

                          // Payout Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Earnings Payout',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                order.payout,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isCompleted
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}
