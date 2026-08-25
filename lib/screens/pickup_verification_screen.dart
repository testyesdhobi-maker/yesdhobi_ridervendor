import 'package:flutter/material.dart';
import 'package:yesdhobi_ridervendor/theme.dart';
import 'package:yesdhobi_ridervendor/widgets/custom_back_button.dart';
import 'package:yesdhobi_ridervendor/widgets/dashed_border_painter.dart';

class PickupVerificationScreen extends StatefulWidget {
  const PickupVerificationScreen({super.key});

  @override
  State<PickupVerificationScreen> createState() => _PickupVerificationScreenState();
}

class _PickupVerificationScreenState extends State<PickupVerificationScreen> {
  final double rate = 100.0;
  double weight1 = 1.2;
  double weight2 = 0.8;
  double weight3 = 1.0;

  late TextEditingController controller1;
  late TextEditingController controller2;
  late TextEditingController controller3;

  @override
  void initState() {
    super.initState();
    controller1 = TextEditingController(text: weight1.toString());
    controller2 = TextEditingController(text: weight2.toString());
    controller3 = TextEditingController(text: weight3.toString());
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  double get subtotalWeight => double.parse((weight1 + weight2 + weight3).toStringAsFixed(1));
  double get subtotalPrice => double.parse((subtotalWeight * rate).toStringAsFixed(1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CustomBackButton(),
        title: const Text(
          'Pickup Verification & Pricing',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Upload images by service category and enter weight to calculate actual price.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              // Estimated Price Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.local_offer_outlined, color: Color(0xFF10B981), size: 20),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimated price',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF065F46),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Based on initial order details',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF047857),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Text(
                      '₹450',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF065F46),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Wash & Iron Section Card
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Wash & Iron',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          '₹100/kg',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Item 1
                    _buildLaundryItemRow(
                      itemName: 'Item 1',
                      controller: controller1,
                      price: '₹${(weight1 * rate).toInt()}',
                      iconData: Icons.checkroom,
                      onChanged: (val) {
                        setState(() {
                          weight1 = double.tryParse(val) ?? 0.0;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    // Item 2
                    _buildLaundryItemRow(
                      itemName: 'Item 2',
                      controller: controller2,
                      price: '₹${(weight2 * rate).toInt()}',
                      iconData: Icons.wb_sunny_outlined,
                      onChanged: (val) {
                        setState(() {
                          weight2 = double.tryParse(val) ?? 0.0;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    // Item 3
                    _buildLaundryItemRow(
                      itemName: 'Item 3',
                      controller: controller3,
                      price: '₹${(weight3 * rate).toInt()}',
                      iconData: Icons.layers_outlined,
                      onChanged: (val) {
                        setState(() {
                          weight3 = double.tryParse(val) ?? 0.0;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    // Add Item Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('+ Add Item'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 32, color: Color(0xFFE2E8F0)),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          '$subtotalWeight kg - ₹${subtotalPrice.toInt()}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Category Action Buttons
              _buildCategoryAddButton(
                title: '+ Add Wash & Fold items',
                rate: '₹80/kg',
                icon: Icons.dry_cleaning_outlined,
              ),
              const SizedBox(height: 12),
              _buildCategoryAddButton(
                title: '+ Add Shoes items',
                rate: '₹200/pair',
                icon: Icons.nordic_walking_outlined,
              ),
              const SizedBox(height: 12),
              _buildCategoryAddButton(
                title: '+ Add Dry Clean Items',
                rate: '₹150/kg',
                icon: Icons.bubble_chart_outlined,
                isDashed: true,
              ),
              const SizedBox(height: 24),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Confirm Pickup & Price',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Price Breakdown Header
              const Text(
                'Price Breakdown',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),

              // Price Details Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildBreakdownRow('Wash & Iron', '₹${subtotalPrice.toInt()}'),
                    const Divider(height: 24, color: Color(0xFFE2E8F0)),
                    _buildBreakdownRow('Total Actual Price', '₹${subtotalPrice.toInt()}', isBold: true),
                    const SizedBox(height: 8),
                    _buildBreakdownRow('Estimated Price', '₹450', isMuted: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: 1, // Orders tab selected
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_outlined),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Earnings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaundryItemRow({
    required String itemName,
    required TextEditingController controller,
    required String price,
    required IconData iconData,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      children: [
        // Rounded image/icon placeholder
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(iconData, color: const Color(0xFF64748B)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              // Editable weight input field
              Container(
                width: 80,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          border: InputBorder.none,
                        ),
                        onChanged: onChanged,
                      ),
                    ),
                    const Text(
                      'kg',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF10B981),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryAddButton({
    required String title,
    required String rate,
    required IconData icon,
    bool isDashed = false,
  }) {
    Widget innerContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isDashed ? null : Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          Text(
            rate,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );

    if (isDashed) {
      return CustomPaint(
        painter: DashedBorderPainter(
          color: AppTheme.primaryColor.withOpacity(0.5),
          borderRadius: 12,
          dashWidth: 6,
          dashSpace: 4,
        ),
        child: innerContent,
      );
    }
    
    return innerContent;
  }

  Widget _buildBreakdownRow(String label, String val, {bool isBold = false, bool isMuted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isMuted ? const Color(0xFF94A3B8) : (isBold ? const Color(0xFF1E293B) : const Color(0xFF64748B)),
          ),
        ),
        Text(
          val,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isMuted ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
            decoration: isMuted ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}
