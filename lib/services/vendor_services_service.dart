import 'package:flutter/foundation.dart';
import 'package:yesdhobi_ridervendor/models/vendor_service_model.dart';

class VendorServicesService extends ChangeNotifier {
  static final VendorServicesService _instance =
      VendorServicesService._internal();
  static VendorServicesService get instance => _instance;

  VendorServicesService._internal() {
    _initDefaultServices();
  }

  final List<VendorServiceModel> _services = [];

  List<VendorServiceModel> get services => List.unmodifiable(_services);

  void _initDefaultServices() {
    _services.clear();
    _services.addAll([
      VendorServiceModel(
        id: 'wash_fold',
        name: 'Wash & Fold',
        isEnabled: true,
        price: 25.0,
        unit: 'kg',
      ),
      VendorServiceModel(
        id: 'wash_iron',
        name: 'Wash & Iron',
        isEnabled: true,
        price: 45.0,
        unit: 'kg',
      ),
      VendorServiceModel(
        id: 'dry_clean',
        name: 'Dry Clean',
        isEnabled: true,
        price: 180.0,
        unit: 'piece',
      ),
      VendorServiceModel(
        id: 'steam_press',
        name: 'Steam Press Only',
        isEnabled: false,
        price: 15.0,
        unit: 'piece',
      ),
    ]);
  }

  void toggleService(String id, bool enabled) {
    final index = _services.indexWhere((s) => s.id == id);
    if (index != -1) {
      _services[index].isEnabled = enabled;
      notifyListeners();
    }
  }

  void updateServicePrice(String id, double newPrice) {
    final index = _services.indexWhere((s) => s.id == id);
    if (index != -1) {
      _services[index].price = newPrice;
      notifyListeners();
    }
  }

  void addCustomService({
    required String name,
    required double price,
    required String unit,
  }) {
    final newId = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    _services.add(
      VendorServiceModel(
        id: newId,
        name: name,
        isEnabled: true,
        price: price,
        unit: unit,
        isCustom: true,
      ),
    );
    notifyListeners();
  }

  void resetToDefaults() {
    _initDefaultServices();
    notifyListeners();
  }
}
