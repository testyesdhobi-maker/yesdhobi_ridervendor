import 'package:flutter/material.dart';
import 'package:yesdhobi_ridervendor/theme.dart';
import 'package:yesdhobi_ridervendor/widgets/app_logo.dart';
import 'package:yesdhobi_ridervendor/widgets/custom_text_field.dart';
import 'package:yesdhobi_ridervendor/screens/application_review_screen.dart';
import 'package:yesdhobi_ridervendor/widgets/custom_back_button.dart';
import 'package:yesdhobi_ridervendor/widgets/dashed_border_painter.dart';

class RiderRegisterStep3Screen extends StatelessWidget {
  const RiderRegisterStep3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CustomBackButton(),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogo(
              size: 28,
              borderRadius: 6,
              iconSize: 18,
              backgroundColor: AppTheme.primaryColor,
            ),
            SizedBox(width: 8),
            Text(
              'Yes Dhobi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Documents & Bank',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Step 3: Verification documents and payout bank account details',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              
              // Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'STEP 3 OF 3',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Text(
                    '100% Complete',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 1.0,
                backgroundColor: const Color(0xFFE2E8F0),
                color: AppTheme.secondaryColor,
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
              const SizedBox(height: 32),
              
              RichText(
                text: const TextSpan(
                  text: 'Aadhaar Card Verification',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Manrope',
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDocumentUploadBox('Front Photo'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDocumentUploadBox('Back Photo'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              const CustomTextField(
                label: 'PAN Card Number',
                hint: 'ABCDE1234F',
              ),
              const SizedBox(height: 24),
              
              const CustomTextField(
                label: 'Bank Account Number',
                hint: '50100123456789',
              ),
              const SizedBox(height: 24),
              
              const CustomTextField(
                label: 'Bank IFSC Code',
                hint: 'HDFC0000123',
              ),
              
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to final review screen (or pop to root and show it)
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ApplicationReviewScreen(),
                      ),
                      (route) => false, // Clears the stack to avoid going back to auth steps
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Submit Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B), // Dark text on yellow
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentUploadBox(String label) {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: const Color(0xFFCBD5E1),
        borderRadius: 12,
        dashWidth: 6,
        dashSpace: 4,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const Icon(
              Icons.description_outlined,
              color: Color(0xFF64748B),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
