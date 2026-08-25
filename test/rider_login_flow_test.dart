import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yesdhobi_ridervendor/models/rider_registration_model.dart';
import 'package:yesdhobi_ridervendor/models/order_flow_model.dart';
import 'package:yesdhobi_ridervendor/services/rider_auth_service.dart';
import 'package:yesdhobi_ridervendor/screens/portal_selection_screen.dart';
import 'package:yesdhobi_ridervendor/screens/rider_login_screen.dart';
import 'package:yesdhobi_ridervendor/screens/rider_register_step1_screen.dart';
import 'package:yesdhobi_ridervendor/screens/rider_register_step2_screen.dart';
import 'package:yesdhobi_ridervendor/screens/rider_register_step3_screen.dart';
import 'package:yesdhobi_ridervendor/screens/application_review_screen.dart';
import 'package:yesdhobi_ridervendor/screens/rider_dashboard_screen.dart';
import 'package:yesdhobi_ridervendor/screens/order_request_screen.dart';
import 'package:yesdhobi_ridervendor/screens/rider_order_details_screen.dart';
import 'package:yesdhobi_ridervendor/screens/pickup_verification_screen.dart';
import 'package:yesdhobi_ridervendor/screens/confirm_pickup_screen.dart';
import 'package:yesdhobi_ridervendor/screens/order_status_screen.dart';
import 'package:yesdhobi_ridervendor/screens/confirm_vendor_dropoff_screen.dart';
import 'package:yesdhobi_ridervendor/screens/dropoff_confirmed_screen.dart';
import 'package:yesdhobi_ridervendor/widgets/custom_back_button.dart';

void main() {
  setUp(() {
    RiderAuthService.instance.resetForNewRider();
  });

  group('Complete Rider Registration & Normal Rider App Flows', () {
    testWidgets('1. Welcome -> Continue as Rider opens Personal Details (Step 1) directly (NOT Login)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: PortalSelectionScreen(),
        ),
      );

      // Verify Welcome screen
      expect(find.text('Welcome to Yes Dhobi'), findsOneWidget);
      expect(find.text('Continue as Rider'), findsOneWidget);

      // Tap Continue as Rider
      final continueBtn = find.text('Continue as Rider');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      // Verify destination is Personal Details (Step 1), NOT Rider Partner Login
      expect(find.byType(RiderRegisterStep1Screen), findsOneWidget);
      expect(find.text('Personal Details'), findsOneWidget);
      expect(find.text('STEP 1 OF 3'), findsOneWidget);
      expect(find.text('33% Complete'), findsOneWidget);
      expect(find.byType(RiderLoginScreen), findsNothing);
    });

    testWidgets('2. Full Registration Flow: Welcome -> Step 1 -> Step 2 -> Step 3 -> Under Review -> Rider Login',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: PortalSelectionScreen(),
        ),
      );

      // 1. Welcome -> Step 1
      final continueBtn = find.text('Continue as Rider');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      expect(find.byType(RiderRegisterStep1Screen), findsOneWidget);

      // Fill Step 1
      await tester.enterText(find.byType(TextField).at(0), 'Ramesh Kumar');
      await tester.enterText(find.byType(TextField).at(1), '9876543210');
      await tester.enterText(find.byType(TextField).at(2), 'ramesh@gmail.com');
      RiderAuthService.instance.registrationModel.dateOfBirth = DateTime(1998, 1, 1);
      RiderAuthService.instance.registrationModel.profilePhotoPath = '/mock/selfie.jpg';
      RiderAuthService.instance.registrationModel.profilePhotoSize = 500000;

      // 2. Step 1 -> Step 2
      final nextStep1Btn = find.text('Next: Vehicle Info');
      await tester.ensureVisible(nextStep1Btn);
      await tester.tap(nextStep1Btn);
      await tester.pumpAndSettle();

      expect(find.byType(RiderRegisterStep2Screen), findsOneWidget);
      expect(find.text('Vehicle Details'), findsOneWidget);
      expect(find.text('STEP 2 OF 3'), findsOneWidget);

      // Fill Step 2
      await tester.enterText(find.byType(TextField).at(0), 'MH 02 AA 1234');
      await tester.enterText(find.byType(TextField).at(1), 'DL-1420110012345');
      RiderAuthService.instance.registrationModel.drivingLicensePhotoPath = '/mock/dl.jpg';
      RiderAuthService.instance.registrationModel.drivingLicensePhotoSize = 500000;

      // 3. Step 2 -> Step 3
      final nextStep2Btn = find.text('Next: Verification Documents');
      await tester.ensureVisible(nextStep2Btn);
      await tester.tap(nextStep2Btn);
      await tester.pumpAndSettle();

      expect(find.byType(RiderRegisterStep3Screen), findsOneWidget);
      expect(find.text('Documents & Bank'), findsOneWidget);
      expect(find.text('STEP 3 OF 3'), findsOneWidget);

      // Fill Step 3
      await tester.enterText(find.byType(TextField).at(0), 'ABCDE1234F');
      await tester.enterText(find.byType(TextField).at(1), '50100123456789');
      await tester.enterText(find.byType(TextField).at(2), 'HDFC0000123');
      RiderAuthService.instance.registrationModel.aadhaarFrontPath = '/mock/front.jpg';
      RiderAuthService.instance.registrationModel.aadhaarFrontSize = 500000;
      RiderAuthService.instance.registrationModel.aadhaarBackPath = '/mock/back.jpg';
      RiderAuthService.instance.registrationModel.aadhaarBackSize = 500000;

      // 4. Step 3 -> Application Under Review
      final submitBtn = find.text('Submit Profile');
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.byType(ApplicationReviewScreen), findsOneWidget);
      expect(find.text('Application Under Review'), findsOneWidget);
      expect(find.text('Application Received'), findsOneWidget);

      // 5. Application Under Review -> Rider Partner Login
      final continueToLoginBtn = find.text('Continue to Rider Login');
      expect(continueToLoginBtn, findsOneWidget);
      await tester.ensureVisible(continueToLoginBtn);
      await tester.tap(continueToLoginBtn);
      await tester.pumpAndSettle();

      expect(find.byType(RiderLoginScreen), findsOneWidget);
      expect(find.text('Rider Partner Login'), findsOneWidget);
    });

    testWidgets('3. Back Navigation: Documents & Bank -> Vehicle Details -> Personal Details -> Welcome',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: PortalSelectionScreen(),
        ),
      );

      // Welcome -> Step 1
      final continueBtn = find.text('Continue as Rider');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      expect(find.byType(RiderRegisterStep1Screen), findsOneWidget);

      // Step 1 -> Step 2
      await tester.enterText(find.byType(TextField).at(0), 'Ramesh Kumar');
      await tester.enterText(find.byType(TextField).at(1), '9876543210');
      await tester.enterText(find.byType(TextField).at(2), 'ramesh@gmail.com');
      RiderAuthService.instance.registrationModel.dateOfBirth = DateTime(1998, 1, 1);
      RiderAuthService.instance.registrationModel.profilePhotoPath = '/mock/selfie.jpg';
      RiderAuthService.instance.registrationModel.profilePhotoSize = 500000;

      final nextStep1Btn = find.text('Next: Vehicle Info');
      await tester.ensureVisible(nextStep1Btn);
      await tester.tap(nextStep1Btn);
      await tester.pumpAndSettle();

      expect(find.byType(RiderRegisterStep2Screen), findsOneWidget);

      // Step 2 -> Step 3
      await tester.enterText(find.byType(TextField).at(0), 'MH 02 AA 1234');
      await tester.enterText(find.byType(TextField).at(1), 'DL-1420110012345');
      RiderAuthService.instance.registrationModel.drivingLicensePhotoPath = '/mock/dl.jpg';
      RiderAuthService.instance.registrationModel.drivingLicensePhotoSize = 500000;

      final nextStep2Btn = find.text('Next: Verification Documents');
      await tester.ensureVisible(nextStep2Btn);
      await tester.tap(nextStep2Btn);
      await tester.pumpAndSettle();

      expect(find.byType(RiderRegisterStep3Screen), findsOneWidget);

      // Test Back from Step 3 -> Step 2
      await tester.tap(find.byType(CustomBackButton));
      await tester.pumpAndSettle();
      expect(find.byType(RiderRegisterStep2Screen), findsOneWidget);

      // Test Back from Step 2 -> Step 1
      await tester.tap(find.byType(CustomBackButton));
      await tester.pumpAndSettle();
      expect(find.byType(RiderRegisterStep1Screen), findsOneWidget);

      // Test Back from Step 1 -> Welcome
      await tester.tap(find.byType(CustomBackButton));
      await tester.pumpAndSettle();
      expect(find.byType(PortalSelectionScreen), findsOneWidget);
    });

    testWidgets('4. Normal Login -> Rider Dashboard (Always enters normal rider app)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: RiderLoginScreen(),
        ),
      );

      await tester.enterText(find.byType(TextField).at(0), '9876543210');
      await tester.enterText(find.byType(TextField).at(1), 'password123');

      final loginBtn = find.text('Login to Portal');
      await tester.ensureVisible(loginBtn);
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      // Destination is Rider Dashboard (NOT Personal Details or Review)
      expect(find.byType(RiderDashboardScreen), findsOneWidget);
      expect(find.text('Rider Dashboard'), findsOneWidget);
    });

    testWidgets('5. Authenticated Rider Flow: Dashboard -> Order Request -> Order Details -> Pickup to Drop-off',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final orderState = OrderFlowState();

      // 1. Order Request Screen
      await tester.pumpWidget(
        MaterialApp(
          home: OrderRequestScreen(orderState: orderState),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Order Request'), findsOneWidget);
      expect(find.text('Accept Order Request'), findsOneWidget);

      // 2. Order Details Screen
      await tester.pumpWidget(
        MaterialApp(
          home: RiderOrderDetailsScreen(orderState: orderState),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Order Details'), findsOneWidget);

      // 3. Pickup Verification & Pricing Screen
      await tester.pumpWidget(
        MaterialApp(
          home: PickupVerificationScreen(orderState: orderState),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Pickup Verification'), findsOneWidget);

      // 4. Confirm Pickup Screen (OTP)
      await tester.pumpWidget(
        MaterialApp(
          home: ConfirmPickupScreen(orderState: orderState),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Confirm Pickup'), findsOneWidget);

      // 5. Order Status Screen
      await tester.pumpWidget(
        MaterialApp(
          home: OrderStatusScreen(orderState: orderState),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Order Status'), findsOneWidget);

      // 6. Vendor Drop-off Screen
      await tester.pumpWidget(
        MaterialApp(
          home: ConfirmVendorDropoffScreen(orderState: orderState),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Confirm Vendor Drop-off'), findsOneWidget);

      // 7. Drop-off Confirmed Screen
      await tester.pumpWidget(
        MaterialApp(
          home: DropoffConfirmedScreen(orderState: orderState),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Drop-off Confirmed!'), findsOneWidget);
    });
  });
}
