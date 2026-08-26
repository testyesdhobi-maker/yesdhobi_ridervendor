import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yesdhobi_ridervendor/screens/portal_selection_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_login_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_home_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_new_orders_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_order_details_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_active_orders_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_earnings_screen.dart';
import 'package:yesdhobi_ridervendor/screens/vendor_profile_screen.dart';

void main() {
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
  });
}
