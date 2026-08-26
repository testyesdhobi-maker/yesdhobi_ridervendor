import 'package:flutter/material.dart';
import 'package:yesdhobi_ridervendor/widgets/custom_back_button.dart';
import 'package:yesdhobi_ridervendor/widgets/vendor_bottom_nav.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_order_details_screen.dart';

class ActiveTaskItem {
  final String orderId;
  final String customerName;
  final String customerPhone;
  final String itemsCount;
  final double progress;
  final String estTime;
  final String tab;

  const ActiveTaskItem({
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.itemsCount,
    required this.progress,
    required this.estTime,
    this.tab = 'In Progress',
  });
}

class VendorActiveOrdersScreen extends StatefulWidget {
  const VendorActiveOrdersScreen({super.key});

  @override
  State<VendorActiveOrdersScreen> createState() =>
      _VendorActiveOrdersScreenState();
}

class _VendorActiveOrdersScreenState extends State<VendorActiveOrdersScreen> {
  String selectedTab = 'In Progress';

  final List<ActiveTaskItem> tasks = const [
    ActiveTaskItem(
      orderId: '#YD-9584',
      customerName: 'Rajesh Kumar',
      customerPhone: '+91 98765 12345',
      itemsCount: '12 Items',
      progress: 0.65,
      estTime: 'Est: 2 hrs remaining',
      tab: 'In Progress',
    ),
    ActiveTaskItem(
      orderId: '#YD-9576',
      customerName: 'Neha Saxena',
      customerPhone: '+91 99887 76655',
      itemsCount: '8 Items',
      progress: 0.25,
      estTime: 'Est: Tomorrow, 11 AM',
      tab: 'In Progress',
    ),
    ActiveTaskItem(
      orderId: '#YD-9581',
      customerName: 'Priya Sharma',
      customerPhone: '+91 91234 56780',
      itemsCount: '5 Items',
      progress: 1.0,
      estTime: 'Ready for Rider Pickup',
      tab: 'Ready',
    ),
    ActiveTaskItem(
      orderId: '#YD-9560',
      customerName: 'Karan Mehra',
      customerPhone: '+91 98765 43210',
      itemsCount: '10 Items',
      progress: 1.0,
      estTime: 'Out with Rider Zack',
      tab: 'Out for Delivery',
    ),
  ];

  List<ActiveTaskItem> get filteredTasks {
    return tasks.where((t) => t.tab == selectedTab).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: const CustomBackButton(),
        title: const Text(
          'Active Tasks',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tabs Bar
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              ),
              child: Row(
                children: [
                  _buildTab('In Progress'),
                  _buildTab('Ready'),
                  _buildTab('Out for Delivery'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tasks List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                itemCount: filteredTasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (ctx, index) {
                  final task = filteredTasks[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VendorOrderDetailsScreen(
                            orderId: task.orderId,
                            customerName: task.customerName,
                            customerPhone: task.customerPhone,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(18),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                task.orderId,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                task.itemsCount,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.customerName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: task.progress,
                              minHeight: 5,
                              backgroundColor: const Color(0xFFF1F5F9),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF2563EB),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          Text(
                            task.estTime,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const VendorBottomNav(currentIndex: 1),
    );
  }

  Widget _buildTab(String title) {
    final isSelected = selectedTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }
}
