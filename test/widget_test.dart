import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yesdhobi_ridervendor/models/rider_registration_model.dart';
import 'package:yesdhobi_ridervendor/models/order_flow_model.dart';
import 'package:yesdhobi_ridervendor/screens/rider_login_screen.dart';
import 'package:yesdhobi_ridervendor/screens/rider_register_step1_screen.dart';
import 'package:yesdhobi_ridervendor/screens/rider_register_step2_screen.dart';
import 'package:yesdhobi_ridervendor/screens/rider_register_step3_screen.dart';
import 'package:yesdhobi_ridervendor/screens/application_review_screen.dart';
import 'package:yesdhobi_ridervendor/screens/rider_order_details_screen.dart';
import 'package:yesdhobi_ridervendor/screens/dropoff_confirmed_screen.dart';

void main() {
  testWidgets('Complete Rider Partner Registration and Order Flow Tests',
      (WidgetTester tester) async {
    // 1. Test RiderLoginScreen
    await tester.pumpWidget(
      const MaterialApp(
        home: RiderLoginScreen(),
      ),
    );
    expect(find.text('Rider Partner Login'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);

    // 2. Test Step 1: Personal Details
    final regModel = RiderRegistrationModel(
      fullName: 'Ramesh Kumar',
      mobileNumber: '9876543210',
      email: 'ramesh@gmail.com',
      dateOfBirth: DateTime(1998, 1, 1),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: RiderRegisterStep1Screen(registrationModel: regModel),
      ),
    );
    expect(find.text('Personal Details'), findsOneWidget);
    expect(find.text('STEP 1 OF 3'), findsOneWidget);
    expect(find.text('33% Complete'), findsOneWidget);
    expect(find.textContaining('Full Name'), findsWidgets);
    expect(find.text('Take Selfie'), findsOneWidget);
    expect(find.text('Next: Vehicle Info'), findsOneWidget);

    // 3. Test Step 2: Vehicle Details
    regModel.vehicleType = 'Motorcycle';
    regModel.vehicleNumber = 'MH 02 AA 1234';
    regModel.drivingLicenseNumber = 'DL-1420110012345';

    await tester.pumpWidget(
      MaterialApp(
        home: RiderRegisterStep2Screen(registrationModel: regModel),
      ),
    );
    expect(find.text('Vehicle Details'), findsOneWidget);
    expect(find.text('STEP 2 OF 3'), findsOneWidget);
    expect(find.text('67% Complete'), findsOneWidget);
    expect(find.text('Motorcycle'), findsOneWidget);
    expect(find.text('Scooter'), findsOneWidget);
    expect(find.text('Bicycle'), findsOneWidget);
    expect(find.text('Next: Verification Documents'), findsOneWidget);

    // 4. Test Step 3: Documents & Bank
    regModel.panNumber = 'ABCDE1234F';
    regModel.bankAccountNumber = '50100123456789';
    regModel.ifscCode = 'HDFC0000123';

    await tester.pumpWidget(
      MaterialApp(
        home: RiderRegisterStep3Screen(registrationModel: regModel),
      ),
    );
    expect(find.text('Documents & Bank'), findsOneWidget);
    expect(find.text('STEP 3 OF 3'), findsOneWidget);
    expect(find.text('100% Complete'), findsOneWidget);
    expect(find.textContaining('Aadhaar Card Verification'), findsWidgets);
    expect(find.text('Front Photo'), findsOneWidget);
    expect(find.text('Back Photo'), findsOneWidget);
    expect(find.text('Submit Profile'), findsOneWidget);

    // 5. Test Screen 4: Application Under Review
    await tester.pumpWidget(
      const MaterialApp(
        home: ApplicationReviewScreen(),
      ),
    );
    expect(find.text('Application Under Review'), findsOneWidget);
    expect(find.text('Application Received'), findsOneWidget);
    expect(find.text('Verification Call'), findsOneWidget);
    expect(find.text('1800-123-9090'), findsOneWidget);

    // 6. Test Order Flow Screen components
    final orderState = OrderFlowState();
    await tester.pumpWidget(
      MaterialApp(
        home: RiderOrderDetailsScreen(orderState: orderState),
      ),
    );
    expect(find.text('Order Details'), findsOneWidget);
    expect(find.text('Navigate to Pickup Location'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: DropoffConfirmedScreen(orderState: orderState),
      ),
    );
    expect(find.text('Drop-off Confirmed!'), findsOneWidget);
  });
}
