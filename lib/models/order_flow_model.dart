enum DeliveryStage {
  accepted,
  pickedUp,
  outForDrop,
  delivered,
}

class LaundryItem {
  final String id;
  final String category;
  final double quantity;
  final double rate;
  final String unit;
  final String? imagePath;
  final String title;

  LaundryItem({
    required this.id,
    required this.category,
    required this.quantity,
    required this.rate,
    this.unit = 'kg',
    this.imagePath,
    required this.title,
  });

  // Backwards compatibility helpers
  double get weight => quantity;
  double get ratePerKg => rate;
  double get totalPrice => quantity * rate;
}

class OrderFlowState {
  String orderId;
  String customerName;
  String customerAddress;
  String deliveryAddress;
  String customerInitials;
  String customerPhone;
  double customerRating;
  String customerAvatarUrl;
  String estimatedLoad;
  String travelDistance;
  String estimatedTime;
  String payout;
  double estimatedPrice;
  String vendorName;
  double vendorRating;
  String vendorTag;
  String vendorAddress;
  String vendorPhone;
  String itemsQuantityText;
  DeliveryStage stage;
  List<LaundryItem> items;
  String customerOtp;
  String vendorOtp;
  String dropoffTime;

  OrderFlowState({
    this.orderId = '#YD-90823',
    this.customerName = 'Rahul Sharma',
    this.customerAddress = 'B-402, Shanti Vihar, Sector 45',
    this.deliveryAddress = 'Yes Dhobi Hub, Sector 44 Branch',
    this.customerInitials = 'RS',
    this.customerPhone = '+91 98765 43210',
    this.customerRating = 4.9,
    this.customerAvatarUrl = '',
    this.estimatedLoad = '12-15 Items (Approx. 4kg)',
    this.travelDistance = '2.8 km total',
    this.estimatedTime = '15-20 Mins',
    this.payout = '₹65.00',
    this.estimatedPrice = 450.0,
    this.vendorName = 'Star Bright Laundry',
    this.vendorRating = 4.9,
    this.vendorTag = 'Professional Partner',
    this.vendorAddress = 'Shop No. 12, Sector 15, HSR Layout, Bengaluru',
    this.vendorPhone = '+91 91234 56789',
    this.itemsQuantityText = '12-15 items (Wash & Fold)',
    this.stage = DeliveryStage.accepted,
    List<LaundryItem>? items,
    this.customerOtp = '5812',
    this.vendorOtp = '5812',
    this.dropoffTime = '10:45 AM',
  }) : items = items ?? [];

  double get totalWeight =>
      items.where((item) => item.unit == 'kg').fold(0.0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get totalActualPrice => totalPrice;

  double get washAndFoldTotal => items
      .where((item) => item.category == 'Wash & Fold')
      .fold(0.0, (sum, item) => sum + item.totalPrice);

  double get shoesTotal => items
      .where((item) => item.category == 'Shoes')
      .fold(0.0, (sum, item) => sum + item.totalPrice);

  double get dryCleanTotal => items
      .where((item) => item.category == 'Dry Clean')
      .fold(0.0, (sum, item) => sum + item.totalPrice);
}
