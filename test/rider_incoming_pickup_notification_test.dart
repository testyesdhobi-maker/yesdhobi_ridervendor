import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yesdhobi_ridervendor/models/pickup_request_notification_model.dart';
import 'package:yesdhobi_ridervendor/services/rider_notification_service.dart';
import 'package:yesdhobi_ridervendor/widgets/incoming_pickup_request_dialog.dart';
import 'package:yesdhobi_ridervendor/screens/rider_order_details_screen.dart';
import 'package:yesdhobi_ridervendor/screens/rider_dashboard_screen.dart';

void main() {
  setUp(() {
    RiderNotificationService.instance.reset();
  });

  group('Rider Incoming Pickup Request Notification System Tests', () {
    test('1. PickupRequestNotificationModel properties and conversion to OrderFlowState', () {
      final request = PickupRequestNotificationModel(
        requestId: 'REQ-9624',
        orderId: '#YD-9624',
        customerName: 'Sneha Kapoor',
        customerType: 'Regular Customer',
        customerTag: 'VIP',
        previousOrdersCount: 24,
        pickupAddress: 'Flat 4B, Silver Oak Apartments',
        pickupArea: 'Sector 6, HSR Layout, Bengaluru',
        distanceKm: 1.8,
        estimatedItemsText: '8–12 items',
        payout: 120.0,
        totalSeconds: 12,
      );

      expect(request.formattedPayout, '₹120');
      expect(request.formattedDistance, '1.8 km away');
      expect(request.fullAddress,
          'Flat 4B, Silver Oak Apartments, Sector 6, HSR Layout, Bengaluru');
      expect(request.isExpired, isFalse);

      final orderState = request.toOrderFlowState();
      expect(orderState.orderId, '#YD-9624');
      expect(orderState.customerName, 'Sneha Kapoor');
      expect(orderState.customerAddress,
          'Flat 4B, Silver Oak Apartments, Sector 6, HSR Layout, Bengaluru');
      expect(orderState.customerInitials, 'SK');
      expect(orderState.payout, '₹120.00');
    });

    testWidgets('2. In-App Incoming Request Dialog (Android Style) UI & Decline Flow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final request = PickupRequestNotificationModel.createDefaultSample();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncomingPickupRequestDialog(request: request),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify UI matching Reference 1
      expect(find.text('New Request!'), findsOneWidget);
      expect(find.text('Urgent response needed'), findsOneWidget);
      expect(find.text('PAYOUT'), findsOneWidget);
      expect(find.text('₹120'), findsOneWidget);
      expect(find.text('Sneha Kapoor'), findsOneWidget);
      expect(find.text('VIP'), findsOneWidget);
      expect(find.text('Regular Customer • 24 previous orders'), findsOneWidget);
      expect(find.text('PICKUP ADDRESS'), findsOneWidget);
      expect(find.text('Flat 4B, Silver Oak Apartments'), findsOneWidget);
      expect(find.text('Sector 6, HSR Layout, Bengaluru'), findsOneWidget);
      expect(find.text('DISTANCE'), findsOneWidget);
      expect(find.text('1.8 km away'), findsOneWidget);
      expect(find.text('EST. CLOTHES'), findsOneWidget);
      expect(find.text('8–12 items'), findsOneWidget);
      expect(find.text('Decline'), findsOneWidget);
      expect(find.text('Accept Pickup'), findsOneWidget);

      // Tap Decline
      await tester.tap(find.text('Decline'));
      await tester.pumpAndSettle();

      expect(request.status, PickupRequestStatus.declined);
    });

    testWidgets('3. In-App Incoming Request Dialog (iOS Blue Style) UI',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final request = PickupRequestNotificationModel.createDefaultSample();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncomingPickupRequestDialog(
              request: request,
              isIosStyle: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify UI matching Reference 2
      expect(find.text('YES DHOBI'), findsOneWidget);
      expect(find.text('Incoming Pickup Request'), findsOneWidget);
      expect(find.text('RESPONSE TIME'), findsOneWidget);
      expect(find.text('Sneha Kapoor'), findsOneWidget);
      expect(find.text('1.8 km away'), findsOneWidget);
      expect(find.text('8–12 items'), findsOneWidget);
      expect(find.text('ESTIMATED PAYOUT'), findsOneWidget);
      expect(find.text('₹120'), findsOneWidget);
      expect(find.text('Decline'), findsOneWidget);
      expect(find.text('Accept Pickup'), findsOneWidget);
    });

    testWidgets('4. Accept Pickup navigates directly to RiderOrderDetailsScreen with customer order',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final request = PickupRequestNotificationModel.createDefaultSample();

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: RiderNotificationService.instance.navigatorKey,
          home: Scaffold(
            body: IncomingPickupRequestDialog(request: request),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Accept Pickup
      await tester.tap(find.text('Accept Pickup'));
      await tester.pumpAndSettle();

      // Verifies destination is RiderOrderDetailsScreen with Sneha Kapoor's pickup
      expect(find.byType(RiderOrderDetailsScreen), findsOneWidget);
      expect(find.text('Order Details'), findsOneWidget);
      expect(find.text('Sneha Kapoor'), findsOneWidget);
      expect(find.text('Navigate to Pickup Location'), findsOneWidget);
      expect(find.text('PickUp Laundry'), findsOneWidget);
      expect(request.status, PickupRequestStatus.accepted);
    });

    testWidgets('5. Countdown expiration disables Accept Pickup',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Create request with 1 second duration
      final request = PickupRequestNotificationModel(
        requestId: 'REQ-EXP-1',
        orderId: '#YD-9999',
        customerName: 'Sneha Kapoor',
        pickupAddress: 'Flat 4B, Silver Oak Apartments',
        pickupArea: 'Sector 6, HSR Layout, Bengaluru',
        totalSeconds: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IncomingPickupRequestDialog(request: request),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Advance timer past 1 second
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verified expired state
      expect(find.text('Request Expired'), findsOneWidget);
      expect(request.isExpired, isTrue);
    });

    testWidgets('6. Rider Dashboard Incoming Request Trigger shows Alert Dialog',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: RiderNotificationService.instance.navigatorKey,
          home: const RiderDashboardScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Incoming Pickup Requests'), findsOneWidget);
      expect(find.text('Test Alert'), findsOneWidget);

      // Tap Test Alert on Dashboard
      await tester.tap(find.text('Test Alert'));
      await tester.pumpAndSettle();

      // Incoming request modal dialog opens
      expect(find.byType(IncomingPickupRequestDialog), findsOneWidget);
      expect(find.text('New Request!'), findsOneWidget);
      expect(
          find.descendant(
            of: find.byType(IncomingPickupRequestDialog),
            matching: find.text('Sneha Kapoor'),
          ),
          findsOneWidget);
      expect(
          find.descendant(
            of: find.byType(IncomingPickupRequestDialog),
            matching: find.text('₹120'),
          ),
          findsOneWidget);
    });
  });
}
