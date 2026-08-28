import 'package:flutter/material.dart';
import 'package:yesdhobi_ridervendor/models/vendor_order_model.dart';

class VendorOrderService {
  static final VendorOrderService instance = VendorOrderService._internal();

  VendorOrderService._internal() {
    _initializeDefaultOrders();
  }

  final List<VendorOrderModel> _orders = [];
  final List<VendorOrderModel> _newRequests = [];
  final ValueNotifier<VendorOrderModel?> activeOtpOrder = ValueNotifier<VendorOrderModel?>(null);
  final ValueNotifier<int> orderUpdateNotifier = ValueNotifier<int>(0);

  List<VendorOrderModel> get orders => List.unmodifiable(_orders);
  List<VendorOrderModel> get newRequests => List.unmodifiable(_newRequests);

  void _initializeDefaultOrders() {
    _newRequests.clear();
    _orders.clear();

    _newRequests.addAll([
      VendorOrderModel(
        orderId: '#YD-9612',
        customerName: 'Amit Patel',
        customerPhone: '+91 99887 76655',
        serviceType: 'Wash & Iron',
        itemCount: 5,
        itemsDescription: '3 Shirts, 2 Pants',
        pickupOtp: '5831',
        pickupAddress: 'Shop 4, Ground Floor, MG Road Metro Pillar 120',
        dropoffAddress: 'Sunrise Block B, 4th Block, Near Post Office',
        distanceText: '4.2 km',
        estimatedTimeText: '~15 min',
        estimatedWeightText: '~3.5 kg',
      ),
      VendorOrderModel(
        orderId: '#YD-9615',
        customerName: 'Kavita Menon',
        customerPhone: '+91 98765 43219',
        serviceType: 'Dry Clean',
        itemCount: 3,
        itemsDescription: '2 Silk Sarees, 1 Blazer',
        pickupOtp: '4192',
        pickupAddress: 'Shop 4, Ground Floor, MG Road Metro Pillar 120',
        dropoffAddress: 'Villa 14, Palm Meadows, Whitefield',
        distanceText: '6.5 km',
        estimatedTimeText: '~25 min',
        estimatedWeightText: '~2.0 kg',
      ),
    ]);

    _orders.addAll([
      VendorOrderModel(
        orderId: '#YD-9584',
        customerName: 'Rajesh Kumar',
        customerPhone: '+91 98765 12345',
        serviceType: 'Wash & Iron',
        itemCount: 12,
        itemsDescription: '12 Items • Regular Wash & Iron',
        pickupOtp: '7291',
        isPackaged: false,
        isRiderBooked: false,
      ),
      VendorOrderModel(
        orderId: '#YD-9576',
        customerName: 'Neha Saxena',
        customerPhone: '+91 99887 76655',
        serviceType: 'Premium Wash & Iron',
        itemCount: 8,
        itemsDescription: '8 Items • Bed linen & Towels',
        pickupOtp: '3382',
        isPackaged: false,
        isRiderBooked: false,
      ),
      VendorOrderModel(
        orderId: '#YD-9581',
        customerName: 'Priya Sharma',
        customerPhone: '+91 91234 56780',
        serviceType: 'Dry Clean',
        itemCount: 5,
        itemsDescription: '5 Items • Winter wear',
        pickupOtp: '6014',
        isPackaged: true,
        isRiderBooked: false,
      ),
      VendorOrderModel(
        orderId: '#YD-9560',
        customerName: 'Karan Mehra',
        customerPhone: '+91 98765 43210',
        serviceType: 'Wash & Fold',
        itemCount: 10,
        itemsDescription: '10 Items • Casuals',
        pickupOtp: '9183',
        isPackaged: true,
        isRiderBooked: true,
        assignedRiderName: 'Zack Colah',
      ),
    ]);
  }

  VendorOrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.orderId == orderId);
    } catch (_) {
      try {
        return _newRequests.firstWhere((o) => o.orderId == orderId);
      } catch (_) {
        return null;
      }
    }
  }

  VendorOrderModel markAsPackagedAndAssignRider(VendorOrderModel order) {
    VendorOrderModel target = getOrderById(order.orderId) ?? order;
    if (!_orders.contains(target)) {
      _orders.insert(0, target);
    }
    _newRequests.removeWhere((o) => o.orderId == target.orderId);

    target.isPackaged = true;
    target.isRiderBooked = true;
    target.assignedRiderName = 'Zack Colah';
    if (target.pickupOtp.isEmpty) {
      target.pickupOtp = '5831';
    }

    // Set active OTP order for persistent popup across vendor pages
    activeOtpOrder.value = target;
    orderUpdateNotifier.value++;
    return target;
  }

  void verifyOtpAndCompleteOrder(String orderId) {
    final order = getOrderById(orderId);
    if (order != null) {
      order.isPackaged = true;
      order.isRiderBooked = true;
      order.isCompleted = true;
    }

    if (activeOtpOrder.value?.orderId == orderId) {
      activeOtpOrder.value = null;
    }
    orderUpdateNotifier.value++;
  }

  void acceptNewRequest(VendorOrderModel order) {
    _newRequests.removeWhere((o) => o.orderId == order.orderId);
    if (!_orders.any((o) => o.orderId == order.orderId)) {
      _orders.insert(0, order);
    }
    orderUpdateNotifier.value++;
  }

  void rejectNewRequest(String orderId) {
    _newRequests.removeWhere((o) => o.orderId == orderId);
    orderUpdateNotifier.value++;
  }

  double get todayRevenue {
    return 8450.0;
  }

  int get newRequestsCount => _newRequests.length;
  int get inProgressCount => _orders.where((o) => !o.isPackaged && !o.isCompleted).length;
  int get readyCount => _orders.where((o) => o.isPackaged && !o.isRiderBooked && !o.isCompleted).length;
  int get outForDeliveryCount => _orders.where((o) => o.isRiderBooked && !o.isCompleted).length;
  int get completedCount => _orders.where((o) => o.isCompleted).length;

  void reset() {
    _initializeDefaultOrders();
    activeOtpOrder.value = null;
    orderUpdateNotifier.value = 0;
  }
}
