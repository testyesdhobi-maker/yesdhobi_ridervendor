import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yesdhobi_ridervendor/screens/portal_selection_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_login_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_home_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_new_orders_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_order_details_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_book_rider_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_active_orders_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_earnings_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_profile_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_services_rates_screen.dart';
import 'package:yesdhobi_ridervendor/models/vendor_order_model.dart';
import 'package:yesdhobi_ridervendor/services/vendor_services_service.dart';

void main() {
  setUp(() {
    VendorServicesService.instance.resetToDefaults();
  });

  group('Vendor Portal Complete Flow Tests', () {
    testWidgets('TEST 1: Welcome -> Vendor Login -> Login to Portal -> Star Bright Laundry',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      // 1. Welcome screen
      await tester.pumpWidget(
        const MaterialApp(home: PortalSelectionScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Yes Dhobi'), findsOneWidget);
      expect(find.text('Vendor'), findsOneWidget);

      // Select Vendor
      await tester.tap(find.text('Vendor'));
      await tester.pumpAndSettle();

      // Tap Continue
      await tester.tap(find.text('Continue as Vendor'));
      await tester.pumpAndSettle();

      // 2. Opens Vendor Login screen
      expect(find.text('Welcome back!'), findsOneWidget);
      expect(find.text('VENDOR PORTAL'), findsOneWidget);
      expect(find.text('Registered Mobile Number *'), findsOneWidget);
      expect(find.text('Password *'), findsOneWidget);
      expect(find.text('Login to Portal'), findsOneWidget);

      // Enter credentials
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), '9876543210');
      await tester.enterText(textFields.at(1), 'password123');
      await tester.pumpAndSettle();

      // Tap Login to Portal
      await tester.tap(find.text('Login to Portal'));
      await tester.pumpAndSettle();

      // 3. Opens Star Bright Laundry (Vendor Home)
      expect(find.text('Star Bright Laundry'), findsOneWidget);
      expect(find.text('Vendor ID: #V-8947'), findsOneWidget);
      expect(find.text('TODAY\'S REVENUE'), findsOneWidget);
      expect(find.text('₹8,450.00'), findsOneWidget);
    });

    testWidgets('TEST 2: Star Bright Laundry -> Recent Orders -> View All -> Active Tasks',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(home: VendorHomeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Star Bright Laundry'), findsOneWidget);
      expect(find.text('Recent Orders'), findsOneWidget);
      expect(find.text('View All'), findsOneWidget);

      // Tap View All
      await tester.tap(find.text('View All'));
      await tester.pumpAndSettle();

      // Opens Active Tasks
      expect(find.text('Active Tasks'), findsOneWidget);
      expect(find.text('In Progress'), findsOneWidget);
      expect(find.text('Ready'), findsOneWidget);
      expect(find.text('Out for Delivery'), findsOneWidget);
      expect(find.text('#YD-9584'), findsOneWidget);
      expect(find.text('#YD-9576'), findsOneWidget);
    });

    testWidgets('TEST 3: Orders Tab -> New Requests Screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(home: VendorNewOrdersScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('New Requests'), findsOneWidget);
      expect(find.text('2 PENDING'), findsOneWidget);
      expect(find.text('#YD-9612'), findsOneWidget);
      expect(find.text('URGENT'), findsOneWidget);
      expect(find.text('Amit Patel'), findsOneWidget);
      expect(find.text('#YD-9615'), findsOneWidget);
      expect(find.text('NEW REQUEST'), findsOneWidget);
      expect(find.text('Anjali Gupta'), findsOneWidget);
    });

    testWidgets('TEST 4: New Requests -> Accept #YD-9612 -> Order #YD-9612 Details',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(home: VendorNewOrdersScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Accept'), findsNWidgets(2));

      // Tap first Accept (#YD-9612)
      await tester.tap(find.text('Accept').first);
      await tester.pumpAndSettle();

      // Opens Vendor Order Details
      expect(find.text('Order #YD-9612'), findsOneWidget);
      expect(find.text('Amit Patel'), findsOneWidget);
      expect(find.text('+91 99887 76655'), findsOneWidget);
      expect(find.text('Cotton Shirt'), findsOneWidget);
      expect(find.text('Wash & Iron (x3)'), findsOneWidget);
      expect(find.text('Order Tracker'), findsOneWidget);
      expect(find.text('Assign Nearest Rider'), findsOneWidget);
      expect(find.text('Mark as Packaged'), findsOneWidget);
    });

    testWidgets('TEST 5: Earnings Tab -> Vendor Earnings Screen UI and Features',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(home: VendorEarningsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Earnings'), findsNWidgets(2));
      expect(find.text('This Week'), findsOneWidget);
      expect(find.text('THIS WEEK NET EARNINGS'), findsOneWidget);
      expect(find.text('₹12,450.00'), findsOneWidget);
      expect(find.text('Orders Processed'), findsOneWidget);
      expect(find.text('48'), findsOneWidget);
      expect(find.text('Average Value'), findsOneWidget);
      expect(find.text('₹260.00'), findsOneWidget);
      expect(find.text('Next Payout Date: 22 Oct'), findsOneWidget);
      expect(find.text('₹4,120.00 pending'), findsOneWidget);
      expect(find.text('#PAY-9411'), findsOneWidget);
      expect(find.text('#PAY-9382'), findsOneWidget);
    });

    testWidgets('TEST 6: Profile Tab -> My Shop Profile Screen UI and Business Info',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(home: VendorProfileScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('My Shop Profile'), findsOneWidget);
      expect(find.text('VERIFIED PARTNER'), findsOneWidget);
      expect(find.text('Star Bright Laundry'), findsOneWidget);
      expect(find.text('Owner: Rajesh Kumar'), findsOneWidget);
      expect(find.text('4.8'), findsOneWidget);
      expect(find.text('Business Information'), findsOneWidget);
      expect(find.text('+91 98765 43210'), findsOneWidget);
      expect(find.text('Edit Shop Profile'), findsOneWidget);
      expect(find.text('Logout Account'), findsOneWidget);
    });

    testWidgets('TEST 7: My Shop Profile -> Logout Account -> Vendor Login Screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(home: VendorProfileScreen()),
      );
      await tester.pumpAndSettle();

      // Tap Logout Account
      await tester.tap(find.text('Logout Account'));
      await tester.pumpAndSettle();

      // Lands on VendorLoginScreen
      expect(find.text('Welcome back!'), findsOneWidget);
      expect(find.text('VENDOR PORTAL'), findsOneWidget);
      expect(find.text('Login with your registered credentials'), findsOneWidget);
    });

    testWidgets('TEST 8: Star Bright Laundry -> Services & Rates -> Verify Initial Offerings & Rates',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(home: VendorHomeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Services & Rates'), findsOneWidget);

      // Tap Services & Rates card
      await tester.tap(find.text('Services & Rates'));
      await tester.pumpAndSettle();

      // Opens Services & Rates screen
      expect(find.byType(VendorServicesRatesScreen), findsOneWidget);
      expect(find.text('Manage Your Offerings'), findsOneWidget);
      expect(find.text('Enable or disable catalog services and set per-unit laundry pricing.'),
          findsOneWidget);

      // Verify all 4 default services and prices
      expect(find.text('Wash & Fold'), findsOneWidget);
      expect(find.text('₹25 / kg'), findsOneWidget);

      expect(find.text('Wash & Iron'), findsOneWidget);
      expect(find.text('₹45 / kg'), findsOneWidget);

      expect(find.text('Dry Clean'), findsOneWidget);
      expect(find.text('₹180 / piece'), findsOneWidget);

      expect(find.text('Steam Press Only'), findsOneWidget);
      expect(find.text('₹15 / piece'), findsOneWidget);

      expect(find.text('+ Add New Custom Service'), findsOneWidget);
    });

    testWidgets('TEST 9: Toggle Services ON/OFF & Edit Unit Price with Validation',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(home: VendorServicesRatesScreen()),
      );
      await tester.pumpAndSettle();

      // Tap price to edit Wash & Fold
      await tester.tap(find.text('₹25 / kg'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Price: Wash & Fold'), findsOneWidget);
      expect(find.text('Save Price'), findsOneWidget);

      // Enter new price ₹30
      final priceField = find.byType(TextField);
      await tester.enterText(priceField, '30');
      await tester.tap(find.text('Save Price'));
      await tester.pumpAndSettle();

      // Verified updated price
      expect(find.text('₹30 / kg'), findsOneWidget);
    });

    testWidgets('TEST 10: Add New Custom Service -> Appears in Catalog with Active State',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(home: VendorServicesRatesScreen()),
      );
      await tester.pumpAndSettle();

      // Tap + Add New Custom Service
      await tester.tap(find.text('+ Add New Custom Service'));
      await tester.pumpAndSettle();

      expect(find.text('Add Custom Service'), findsOneWidget);
      expect(find.text('Add Service'), findsOneWidget);

      // Fill Form
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Premium Blanket Wash');
      await tester.enterText(textFields.at(1), '250');

      // Submit
      await tester.tap(find.text('Add Service'));
      await tester.pumpAndSettle();

      // Verify custom service appears in the catalog list
      expect(find.text('Premium Blanket Wash'), findsOneWidget);
      expect(find.text('₹250 / piece'), findsOneWidget);
    });

    testWidgets('TEST 11: Vendor Order Details -> Assign Nearest Rider -> Book a Rider Modal -> Later Button',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: VendorOrderDetailsScreen(
            orderId: '#YD-9612',
            customerName: 'Amit Patel',
            customerPhone: '+91 99887 76655',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Assign Nearest Rider'), findsOneWidget);

      // Tap Assign Nearest Rider
      await tester.tap(find.text('Assign Nearest Rider'));
      await tester.pumpAndSettle();

      // Modal appears
      expect(find.text('Book a Rider'), findsOneWidget);
      expect(find.text('Order #YD-9612 is ready for delivery. Tap to book a rider for pickup.'),
          findsOneWidget);
      expect(find.text('CUSTOMER'), findsOneWidget);
      expect(find.text('Amit Patel · 6 items'), findsOneWidget);
      expect(find.text('Book Now'), findsOneWidget);
      expect(find.text('Later'), findsOneWidget);

      // Tap Later -> Modal closes, remains on Vendor Order Details
      await tester.tap(find.text('Later'));
      await tester.pumpAndSettle();

      expect(find.text('Book Now'), findsNothing);
      expect(find.text('Assign Nearest Rider'), findsOneWidget);
    });

    testWidgets('TEST 12: Book a Rider Modal -> Book Now -> Full Book a Rider Screen -> Confirm & Book -> OTP Generated',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final order = VendorOrderModel(
        orderId: '#YD-9612',
        customerName: 'Amit Patel',
        customerPhone: '+91 99887 76655',
        itemCount: 6,
        itemsDescription: '6 Items • Premium Wash & Iron',
        pickupPointName: 'Yes Dhobi - MG Road Branch',
        pickupAddress: 'Shop 4, Ground Floor, MG Road Metro Pillar 120',
        dropoffPointName: '42, Sunrise Apartments, Koramangala',
        dropoffAddress: 'Sunrise Block B, 4th Block, Near Post Office',
        distanceText: '4.2 km',
        estimatedTimeText: '~15 min',
        estimatedWeightText: '~3.5 kg',
        pickupOtp: '5831',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: VendorOrderDetailsScreen(order: order),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Tap Assign Nearest Rider
      await tester.tap(find.text('Assign Nearest Rider'));
      await tester.pumpAndSettle();

      // 2. Tap Book Now on modal
      await tester.tap(find.text('Book Now'));
      await tester.pumpAndSettle();

      // 3. Full Book a Rider Screen appears
      expect(find.byType(VendorBookRiderScreen), findsOneWidget);
      expect(find.text('ACTIVE ORDER'), findsOneWidget);
      expect(find.text('#YD-9612'), findsOneWidget);
      expect(find.text('Amit Patel'), findsOneWidget);
      expect(find.text('6 Items • Premium Wash & Iron'), findsOneWidget);

      expect(find.text('PICKUP POINT'), findsOneWidget);
      expect(find.text('Yes Dhobi - MG Road Branch'), findsOneWidget);
      expect(find.text('DROP-OFF POINT'), findsOneWidget);
      expect(find.text('42, Sunrise Apartments, Koramangala'), findsOneWidget);

      expect(find.text('DELIVERY OPTION'), findsOneWidget);
      expect(find.text('Standard'), findsOneWidget);
      expect(find.text('FREE'), findsOneWidget);
      expect(find.text('Express'), findsOneWidget);
      expect(find.text('₹30 extra'), findsOneWidget);

      expect(find.text('PACKAGE DETAILS'), findsOneWidget);
      expect(find.text('6 Items'), findsOneWidget);
      expect(find.text('~3.5 kg'), findsOneWidget);

      // Select Express delivery option
      await tester.tap(find.text('Express'));
      await tester.pumpAndSettle();

      // Enter optional rider note
      final noteField = find.byType(TextField);
      await tester.enterText(noteField, 'Please handle with care.');
      await tester.pumpAndSettle();

      // 4. Tap Confirm & Book Rider
      final confirmBtn = find.text('Confirm & Book Rider');
      await tester.ensureVisible(confirmBtn);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // 5. Rider Booked dialog appears with Pickup OTP
      expect(find.text('Rider Booked'), findsOneWidget);
      expect(find.text('PICKUP OTP'), findsOneWidget);
      expect(find.text('5  8  3  1'), findsOneWidget);
      expect(find.text('Back to Order Details'), findsOneWidget);

      // 6. Tap Back to Order Details
      await tester.tap(find.text('Back to Order Details'));
      await tester.pumpAndSettle();

      // 7. Returned to Vendor Order Details with updated status
      expect(find.text('Order #YD-9612'), findsOneWidget);
      expect(find.text('Rider Assigned (Zack Colah)'), findsOneWidget);
      expect(find.text('Assigned to Zack Colah'), findsOneWidget);
      expect(order.isRiderBooked, isTrue);
      expect(order.pickupOtp, '5831');
    });
  });
}
