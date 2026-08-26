class VendorOrderModel {
  final String orderId;
  final String customerName;
  final String customerPhone;
  final String customerInitials;
  final String serviceType;
  final int itemCount;
  final String itemsDescription;
  final String pickupPointName;
  final String pickupAddress;
  final String dropoffPointName;
  final String dropoffAddress;
  final String distanceText;
  final String estimatedTimeText;
  final String estimatedWeightText;
  bool isPackaged;
  bool isRiderBooked;
  String? assignedRiderName;
  String deliveryOption; // 'Standard' or 'Express'
  String? riderNotes;
  String pickupOtp;

  VendorOrderModel({
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    String? customerInitials,
    this.serviceType = 'Premium Wash & Iron',
    this.itemCount = 6,
    this.itemsDescription = '6 Items • Premium Wash & Iron',
    this.pickupPointName = 'Yes Dhobi - MG Road Branch',
    this.pickupAddress = 'Shop 4, Ground Floor, MG Road Metro Pillar 120',
    this.dropoffPointName = '42, Sunrise Apartments, Koramangala',
    this.dropoffAddress = 'Sunrise Block B, 4th Block, Near Post Office',
    this.distanceText = '4.2 km',
    this.estimatedTimeText = '~15 min',
    this.estimatedWeightText = '~3.5 kg',
    this.isPackaged = false,
    this.isRiderBooked = false,
    this.assignedRiderName,
    this.deliveryOption = 'Standard',
    this.riderNotes,
    this.pickupOtp = '5831',
  }) : customerInitials = customerInitials ??
            (customerName.isNotEmpty
                ? customerName
                    .split(' ')
                    .where((e) => e.isNotEmpty)
                    .map((e) => e[0])
                    .take(2)
                    .join()
                    .toUpperCase()
                : 'AP');
}
