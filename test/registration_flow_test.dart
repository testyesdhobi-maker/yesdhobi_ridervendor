import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yesdhobi_ridervendor/models/rider_registration_model.dart';
import 'package:yesdhobi_ridervendor/screens/rider_register_step1_screen.dart';
import 'package:yesdhobi_ridervendor/screens/rider_register_step2_screen.dart';
import 'package:yesdhobi_ridervendor/screens/rider_register_step3_screen.dart';

void main() {
  group('Interactive Rider Registration Flow Test', () {
    testWidgets('Step 1 validation blocks invalid input and allows valid progression',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final model = RiderRegistrationModel();

      await tester.pumpWidget(
        MaterialApp(
          home: RiderRegisterStep1Screen(registrationModel: model),
        ),
      );

      // Tap Next without filling anything
      final nextBtn = find.text('Next: Vehicle Info');
      await tester.ensureVisible(nextBtn);
      await tester.tap(nextBtn);
      await tester.pump();

      // Verify errors
      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your mobile number'), findsOneWidget);
      expect(find.text('Please enter your email address'), findsOneWidget);
      expect(find.text('Please select your date of birth'), findsOneWidget);
      expect(find.text('Please take a selfie photo'), findsOneWidget);

      // Now fill invalid data
      await tester.enterText(find.byType(TextField).at(0), 'Ramesh123'); // Invalid name
      await tester.enterText(find.byType(TextField).at(1), '98765'); // Invalid mobile
      await tester.enterText(find.byType(TextField).at(2), 'notanemail'); // Invalid email

      await tester.ensureVisible(nextBtn);
      await tester.tap(nextBtn);
      await tester.pump();

      expect(find.text('Full name can only contain letters and spaces'), findsOneWidget);
      expect(find.text('Enter a valid 10-digit mobile number'), findsOneWidget);
      expect(find.text('Enter a valid email address'), findsOneWidget);

      // Provide valid data
      await tester.enterText(find.byType(TextField).at(0), 'Ramesh Kumar');
      await tester.enterText(find.byType(TextField).at(1), '9876543210');
      await tester.enterText(find.byType(TextField).at(2), 'ramesh@gmail.com');
      model.dateOfBirth = DateTime(1998, 5, 15);
      model.profilePhotoPath = '/mock/path/selfie.jpg';
      model.profilePhotoSize = 1024 * 500;

      await tester.pumpWidget(
        MaterialApp(
          home: RiderRegisterStep1Screen(registrationModel: model),
        ),
      );

      await tester.ensureVisible(nextBtn);
      await tester.tap(nextBtn);
      await tester.pumpAndSettle();

      // Should have navigated to Step 2
      expect(find.text('Vehicle Details'), findsOneWidget);
      expect(find.text('STEP 2 OF 3'), findsOneWidget);
    });

    testWidgets('Step 2 validation blocks invalid input and allows valid progression',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final model = RiderRegistrationModel(
        fullName: 'Ramesh Kumar',
        mobileNumber: '9876543210',
        email: 'ramesh@gmail.com',
        dateOfBirth: DateTime(1998, 5, 15),
        profilePhotoPath: '/mock/path/selfie.jpg',
        profilePhotoSize: 500000,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: RiderRegisterStep2Screen(registrationModel: model),
        ),
      );

      // Tap Next without filling vehicle fields
      final nextBtn = find.text('Next: Verification Documents');
      await tester.ensureVisible(nextBtn);
      await tester.tap(nextBtn);
      await tester.pump();

      expect(find.text('Please enter your vehicle registration number'), findsOneWidget);
      expect(find.text('Please enter your driving license number'), findsOneWidget);
      expect(find.text('Please upload the front of your driving license'), findsOneWidget);

      // Enter invalid format
      await tester.enterText(find.byType(TextField).at(0), '12345');
      await tester.enterText(find.byType(TextField).at(1), 'ABC');

      await tester.ensureVisible(nextBtn);
      await tester.tap(nextBtn);
      await tester.pump();

      expect(find.text('Enter a valid Indian vehicle number (e.g. MH 02 AA 1234)'), findsOneWidget);
      expect(find.text('Enter a valid driving license number (e.g. DL-1420110012345)'), findsOneWidget);

      // Enter valid format and photo
      await tester.enterText(find.byType(TextField).at(0), 'MH 02 AA 1234');
      await tester.enterText(find.byType(TextField).at(1), 'DL-1420110012345');
      model.drivingLicensePhotoPath = '/mock/path/dl.jpg';
      model.drivingLicensePhotoSize = 500000;

      await tester.pumpWidget(
        MaterialApp(
          home: RiderRegisterStep2Screen(registrationModel: model),
        ),
      );

      await tester.ensureVisible(nextBtn);
      await tester.tap(nextBtn);
      await tester.pumpAndSettle();

      // Should have navigated to Step 3
      expect(find.text('Documents & Bank'), findsOneWidget);
      expect(find.text('STEP 3 OF 3'), findsOneWidget);
    });

    testWidgets('Step 3 validation blocks invalid documents/bank details and submits',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final model = RiderRegistrationModel(
        fullName: 'Ramesh Kumar',
        mobileNumber: '9876543210',
        email: 'ramesh@gmail.com',
        dateOfBirth: DateTime(1998, 5, 15),
        profilePhotoPath: '/mock/path/selfie.jpg',
        profilePhotoSize: 500000,
        vehicleType: 'Motorcycle',
        vehicleNumber: 'MH 02 AA 1234',
        drivingLicenseNumber: 'DL-1420110012345',
        drivingLicensePhotoPath: '/mock/path/dl.jpg',
        drivingLicensePhotoSize: 500000,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: RiderRegisterStep3Screen(registrationModel: model),
        ),
      );

      // Tap Submit Profile without filling details
      final submitBtn = find.text('Submit Profile');
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pump();

      expect(find.text('Please upload Aadhaar card front photo'), findsOneWidget);
      expect(find.text('Please enter your PAN card number'), findsOneWidget);
      expect(find.text('Please enter your bank account number'), findsOneWidget);
      expect(find.text('Please enter your bank IFSC code'), findsOneWidget);

      // Enter invalid PAN, bank, IFSC
      await tester.enterText(find.byType(TextField).at(0), 'INVALID_PAN');
      await tester.enterText(find.byType(TextField).at(1), '123');
      await tester.enterText(find.byType(TextField).at(2), 'INVALID_IFSC');

      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pump();

      expect(find.text('Enter a valid 10-character PAN (e.g. ABCDE1234F)'), findsOneWidget);
      expect(find.text('Enter a valid 9 to 18 digit bank account number'), findsOneWidget);
      expect(find.text('Enter a valid IFSC code (e.g. HDFC0000123)'), findsOneWidget);

      // Set valid details
      await tester.enterText(find.byType(TextField).at(0), 'ABCDE1234F');
      await tester.enterText(find.byType(TextField).at(1), '50100123456789');
      await tester.enterText(find.byType(TextField).at(2), 'HDFC0000123');
      model.aadhaarFrontPath = '/mock/path/aadhaar_front.jpg';
      model.aadhaarFrontSize = 500000;
      model.aadhaarBackPath = '/mock/path/aadhaar_back.jpg';
      model.aadhaarBackSize = 500000;

      await tester.pumpWidget(
        MaterialApp(
          home: RiderRegisterStep3Screen(registrationModel: model),
        ),
      );

      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Successfully navigated to Application Under Review
      expect(find.text('Application Under Review'), findsOneWidget);
      expect(find.text('Application Received'), findsOneWidget);
      expect(find.text('Verification Call'), findsOneWidget);
      expect(find.text('1800-123-9090'), findsOneWidget);
    });
  });
}
