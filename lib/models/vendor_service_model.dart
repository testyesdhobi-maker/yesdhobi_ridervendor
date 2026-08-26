class VendorServiceModel {
  final String id;
  String name;
  bool isEnabled;
  double price;
  String unit; // 'kg', 'piece', 'pair', 'item'
  final bool isCustom;

  VendorServiceModel({
    required this.id,
    required this.name,
    required this.isEnabled,
    required this.price,
    required this.unit,
    this.isCustom = false,
  });

  String get formattedPrice {
    final priceStr =
        price % 1 == 0 ? price.toInt().toString() : price.toStringAsFixed(2);
    return '₹$priceStr / $unit';
  }

  VendorServiceModel copyWith({
    String? id,
    String? name,
    bool? isEnabled,
    double? price,
    String? unit,
    bool? isCustom,
  }) {
    return VendorServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isEnabled: isEnabled ?? this.isEnabled,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}
