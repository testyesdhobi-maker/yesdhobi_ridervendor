import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yesdhobi_ridervendor/models/order_flow_model.dart';
import 'package:yesdhobi_ridervendor/screens/confirm_pickup_screen.dart';
import 'package:yesdhobi_ridervendor/screens/pickup_verification_screen.dart';
import 'package:yesdhobi_ridervendor/screens/order_status_screen.dart';
import 'package:yesdhobi_ridervendor/screens/rider_order_details_screen.dart';
import 'package:yesdhobi_ridervendor/screens/confirm_vendor_dropoff_screen.dart';
import 'package:yesdhobi_ridervendor/screens/dropoff_confirmed_screen.dart';

void main() {
  group('Pickup Verification & Pricing Screen & Correct Order Flow Tests', () {
    testWidgets('1. Order Details -> Pickup Verification & Pricing navigation',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final orderState = OrderFlowState(
        orderId: '#YD-90823',
        customerName: 'Rahul Sharma',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: RiderOrderDetailsScreen(orderState: orderState),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Order Details'), findsOneWidget);
      expect(find.text('PickUp Laundry'), findsOneWidget);

      await tester.tap(find.text('PickUp Laundry'));
      await tester.pumpAndSettle();

      // Verified: Opens Pickup Verification & Pricing directly without requiring OTP
      expect(find.text('Pickup Verification'), findsOneWidget);
      expect(find.text('Order #YD-90823'), findsOneWidget);
      expect(find.text('IN PROGRESS'), findsOneWidget);
    });

    testWidgets('2. PickupVerificationScreen renders 3 service rows and breakdown',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final orderState = OrderFlowState(
        orderId: '#YD-90823',
        customerName: 'Rahul Sharma',
        estimatedPrice: 450.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: PickupVerificationScreen(orderState: orderState),
        ),
      );
      await tester.pumpAndSettle();

      // Check the 3 Service rows
      expect(find.text('+ Add Wash & Fold items'), findsOneWidget);
      expect(find.text('₹80/kg'), findsOneWidget);

      expect(find.text('+ Add Shoes items'), findsOneWidget);
      expect(find.text('₹200/pair'), findsOneWidget);

      expect(find.text('+ Add Dry Clean item'), findsOneWidget);
      expect(find.text('₹150/kg'), findsOneWidget);

      // Check Confirm button
      expect(find.text('Confirm Pickup & Price'), findsOneWidget);

      // Check Price Breakdown
      expect(find.text('Price Breakdown'), findsOneWidget);
      expect(find.text('Total Actual Price'), findsOneWidget);
      expect(find.text('Estimated Price'), findsOneWidget);
      expect(find.text('₹450'), findsOneWidget);
    });

    testWidgets('3. Adding items updates prices dynamically and calculates Total Actual Price',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final orderState = OrderFlowState(
        orderId: '#YD-90823',
        estimatedPrice: 450.0,
      );

      // Add 2 kg Wash & Fold (₹160)
      orderState.items.add(LaundryItem(
        id: '1',
        category: 'Wash & Fold',
        quantity: 2.0,
        rate: 80.0,
        unit: 'kg',
        title: 'Wash & Fold (2.0 kg)',
      ));

      // Add 1 pair Shoes (₹200)
      orderState.items.add(LaundryItem(
        id: '2',
        category: 'Shoes',
        quantity: 1.0,
        rate: 200.0,
        unit: 'pair',
        title: 'Shoes (1 pair)',
      ));

      // Add 1 kg Dry Clean (₹150)
      orderState.items.add(LaundryItem(
        id: '3',
        category: 'Dry Clean',
        quantity: 1.0,
        rate: 150.0,
        unit: 'kg',
        title: 'Dry Clean (1.0 kg)',
      ));

      expect(orderState.washAndFoldTotal, 160.0);
      expect(orderState.shoesTotal, 200.0);
      expect(orderState.dryCleanTotal, 150.0);
      expect(orderState.totalActualPrice, 510.0);

      await tester.pumpWidget(
        MaterialApp(
          home: PickupVerificationScreen(orderState: orderState),
        ),
      );
      await tester.pumpAndSettle();

      // Check item cards
      expect(find.text('2 kg • ₹160'), findsOneWidget);
      expect(find.text('1 pair • ₹200'), findsOneWidget);
      expect(find.text('1 kg • ₹150'), findsOneWidget);

      // Check price breakdown values
      expect(find.text('₹160'), findsOneWidget);
      expect(find.text('₹200'), findsOneWidget);
      expect(find.text('₹150'), findsOneWidget);
      expect(find.text('₹510'), findsOneWidget); // Total Actual Price
      expect(find.text('₹450'), findsOneWidget); // Estimated Price
    });

    testWidgets('4. Confirm Pickup & Price validates empty items and proceeds to Confirm Pickup (OTP)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final orderState = OrderFlowState(
        orderId: '#YD-90823',
        items: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: PickupVerificationScreen(orderState: orderState),
        ),
      );
      await tester.pumpAndSettle();

      // Tap confirm with no items
      await tester.tap(find.text('Confirm Pickup & Price'));
      await tester.pump();

      expect(
        find.text('Please add at least one item before continuing.'),
        findsOneWidget,
      );

      // Now add item and tap confirm
      orderState.items.add(LaundryItem(
        id: '1',
        category: 'Wash & Fold',
        quantity: 2.0,
        rate: 80.0,
        unit: 'kg',
        title: 'Wash & Fold (2.0 kg)',
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: PickupVerificationScreen(orderState: orderState),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm Pickup & Price'));
      await tester.pumpAndSettle();

      // Should transition to Confirm Pickup (OTP) screen
      expect(find.text('Confirm Pickup'), findsOneWidget);
      expect(find.text('Enter Pickup Confirmation OTP'), findsOneWidget);
      expect(find.text('Verify & Confirm Pickup'), findsOneWidget);
    });

    testWidgets('5. Full End-to-End Order Lifecycle: Request -> Details -> Verification -> OTP -> Status -> Drop-off',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final orderState = OrderFlowState(
        orderId: '#YD-90823',
        customerName: 'Rahul Sharma',
        customerOtp: '5812',
        vendorOtp: '5812',
      );

      // 1. Order Details Screen
      await tester.pumpWidget(
        MaterialApp(home: RiderOrderDetailsScreen(orderState: orderState)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Order Details'), findsOneWidget);

      // 3. Pickup Verification & Pricing Screen
      orderState.items.add(LaundryItem(
        id: '1',
        category: 'Wash & Fold',
        quantity: 2.0,
        rate: 80.0,
        unit: 'kg',
        title: 'Wash & Fold (2.0 kg)',
      ));
      await tester.pumpWidget(
        MaterialApp(home: PickupVerificationScreen(orderState: orderState)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Pickup Verification'), findsOneWidget);
      expect(find.text('+ Add Wash & Fold items'), findsOneWidget);
      expect(find.text('+ Add Shoes items'), findsOneWidget);
      expect(find.text('+ Add Dry Clean item'), findsOneWidget);
      expect(find.text('Confirm Pickup & Price'), findsOneWidget);

      // 4. Confirm Pickup Screen (OTP)
      await tester.pumpWidget(
        MaterialApp(home: ConfirmPickupScreen(orderState: orderState)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Confirm Pickup'), findsOneWidget);

      // 5. Order Status Screen
      await tester.pumpWidget(
        MaterialApp(home: OrderStatusScreen(orderState: orderState)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Order Status'), findsOneWidget);

      // 6. Confirm Vendor Drop-off Screen
      await tester.pumpWidget(
        MaterialApp(home: ConfirmVendorDropoffScreen(orderState: orderState)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Confirm Vendor Drop-off'), findsOneWidget);

      // 7. Drop-off Confirmed Screen
      await tester.pumpWidget(
        MaterialApp(home: DropoffConfirmedScreen(orderState: orderState)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Drop-off Confirmed!'), findsOneWidget);
    });
  });
}
