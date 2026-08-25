import 'package:flutter/material.dart';
import 'package:yesdhobi_ridervendor/theme.dart';
import 'package:yesdhobi_ridervendor/models/order_flow_model.dart';
import 'package:yesdhobi_ridervendor/widgets/custom_back_button.dart';
import 'package:yesdhobi_ridervendor/widgets/app_bottom_nav.dart';
import 'package:yesdhobi_ridervendor/widgets/add_item_bottom_sheet.dart';
import 'package:yesdhobi_ridervendor/screens/confirm_pickup_screen.dart';

class PickupVerificationScreen extends StatefulWidget {
  final OrderFlowState? orderState;

  const PickupVerificationScreen({
    super.key,
    this.orderState,
  });

  @override
  State<PickupVerificationScreen> createState() =>
      _PickupVerificationScreenState();
}

class _PickupVerificationScreenState extends State<PickupVerificationScreen> {
  late OrderFlowState _orderState;

  @override
  void initState() {
    super.initState();
    _orderState = widget.orderState ??
        OrderFlowState(
          orderId: '#YD-90823',
          customerName: 'Rahul Sharma',
          customerAddress: 'B-402, Shanti Vihar, Sector 45',
          customerInitials: 'RS',
          estimatedPrice: 450.0,
          items: [],
        );
  }

  void _openAddItemSheet({
    required String serviceCategory,
    required double rate,
    required String unit,
  }) async {
    final newItem = await AddItemBottomSheet.show(
      context,
      serviceCategory: serviceCategory,
      rate: rate,
      unit: unit,
    );

    if (newItem != null && mounted) {
      setState(() {
        _orderState.items.add(newItem);
      });
    }
  }

  void _confirmPickupAndPrice() {
    if (_orderState.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please add at least one item before continuing.',
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmPickupScreen(orderState: _orderState),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final washAndFoldItems = _orderState.items
        .where((i) => i.category == 'Wash & Fold')
        .toList();
    final shoesItems = _orderState.items
        .where((i) => i.category == 'Shoes')
        .toList();
    final dryCleanItems = _orderState.items
        .where((i) => i.category == 'Dry Clean')
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CustomBackButton(),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pickup Verification',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Order ${_orderState.orderId}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: const Text(
                  'IN PROGRESS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB45309),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Section
              Container(
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
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xFFEEF2FF),
                      child: Text(
                        _orderState.customerInitials,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _orderState.customerName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _orderState.customerAddress,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Verify & Categorize Items Section Title
              const Text(
                'VERIFY & CATEGORIZE ITEMS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              // 1. Service Row: Add Wash & Fold items (₹80/kg)
              _buildServiceCategoryCard(
                categoryTitle: 'Wash & Fold',
                addLabel: '+ Add Wash & Fold items',
                rateText: '₹80/kg',
                icon: Icons.local_laundry_service_outlined,
                items: washAndFoldItems,
                onAddTap: () => _openAddItemSheet(
                  serviceCategory: 'Wash & Fold',
                  rate: 80.0,
                  unit: 'kg',
                ),
              ),
              const SizedBox(height: 14),

              // 2. Service Row: Add Shoes items (₹200/pair)
              _buildServiceCategoryCard(
                categoryTitle: 'Shoes',
                addLabel: '+ Add Shoes items',
                rateText: '₹200/pair',
                icon: Icons.roller_skating_outlined,
                items: shoesItems,
                onAddTap: () => _openAddItemSheet(
                  serviceCategory: 'Shoes',
                  rate: 200.0,
                  unit: 'pair',
                ),
              ),
              const SizedBox(height: 14),

              // 3. Service Row: Add Dry Clean item (₹150/kg)
              _buildServiceCategoryCard(
                categoryTitle: 'Dry Clean',
                addLabel: '+ Add Dry Clean item',
                rateText: '₹150/kg',
                icon: Icons.dry_cleaning_outlined,
                items: dryCleanItems,
                onAddTap: () => _openAddItemSheet(
                  serviceCategory: 'Dry Clean',
                  rate: 150.0,
                  unit: 'kg',
                ),
              ),
              const SizedBox(height: 24),

              // Confirm Pickup & Price Button (Green)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _confirmPickupAndPrice,
                  icon: const Icon(Icons.check, size: 22, color: Colors.white),
                  label: const Text(
                    'Confirm Pickup & Price',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Price Breakdown Section
              Container(
                padding: const EdgeInsets.all(18),
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
                    const Text(
                      'Price Breakdown',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 14),

                    if (washAndFoldItems.isNotEmpty)
                      _buildPriceRow(
                        label: 'Wash & Fold',
                        value: '₹${_orderState.washAndFoldTotal.toInt()}',
                      ),

                    if (shoesItems.isNotEmpty)
                      _buildPriceRow(
                        label: 'Shoes',
                        value: '₹${_orderState.shoesTotal.toInt()}',
                      ),

                    if (dryCleanItems.isNotEmpty)
                      _buildPriceRow(
                        label: 'Dry Clean',
                        value: '₹${_orderState.dryCleanTotal.toInt()}',
                      ),

                    if (_orderState.items.isEmpty)
                      _buildPriceRow(
                        label: 'No services added',
                        value: '₹0',
                        valueColor: const Color(0xFF94A3B8),
                      ),

                    const Divider(height: 20, color: Color(0xFFF1F5F9)),

                    // Total Actual Price
                    _buildPriceRow(
                      label: 'Total Actual Price',
                      value: '₹${_orderState.totalActualPrice.toInt()}',
                      labelStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                      valueStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Estimated Price
                    _buildPriceRow(
                      label: 'Estimated Price',
                      value: '₹${_orderState.estimatedPrice.toInt()}',
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                      valueStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  Widget _buildServiceCategoryCard({
    required String categoryTitle,
    required String addLabel,
    required String rateText,
    required IconData icon,
    required List<LaundryItem> items,
    required VoidCallback onAddTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: items.isNotEmpty
              ? const Color(0xFF10B981).withOpacity(0.3)
              : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header / Add Tap Row
          InkWell(
            onTap: onAddTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: AppTheme.primaryColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      addLabel,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      rateText,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Render Added Items in this category
          if (items.isNotEmpty) ...[
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 12, color: Color(0xFFF8FAFC)),
              itemBuilder: (ctx, index) {
                final item = items[index];
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${item.quantity % 1 == 0 ? item.quantity.toInt() : item.quantity.toStringAsFixed(1)} ${item.unit} • ₹${item.totalPrice.toInt()}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Color(0xFFEF4444), size: 20),
                      onPressed: () {
                        setState(() {
                          _orderState.items.remove(item);
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String value,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: labelStyle ??
                  const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: valueStyle ??
                  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? const Color(0xFF0F172A),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
