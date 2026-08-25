class RegistrationValidators {
  static const int maxFileSizeInBytes = 5 * 1024 * 1024; // 5 MB

  /// Validates Full Name
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Full name must be at least 2 characters';
    }
    // Only letters, spaces, hyphens, apostrophes
    final nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
    if (!nameRegex.hasMatch(trimmed)) {
      return 'Full name can only contain letters and spaces';
    }
    // Reject multiple consecutive spaces
    if (RegExp(r'\s{2,}').hasMatch(trimmed)) {
      return 'Full name cannot have multiple consecutive spaces';
    }
    return null;
  }

  /// Validates Mobile Number (10 Indian mobile digits)
  static String? validateMobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your mobile number';
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != 10) {
      return 'Enter a valid 10-digit mobile number';
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(digitsOnly)) {
      return 'Enter a valid 10-digit mobile number starting with 6-9';
    }
    return null;
  }

  /// Validates Email Address
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    final trimmed = value.trim();
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates Date of Birth (18+ requirement)
  static String? validateDateOfBirth(DateTime? dob) {
    if (dob == null) {
      return 'Please select your date of birth';
    }
    final now = DateTime.now();
    if (dob.isAfter(now)) {
      return 'Date of birth cannot be in the future';
    }

    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }

    if (age < 18) {
      return 'You must be at least 18 years old to register';
    }
    if (age > 100) {
      return 'Please enter a valid date of birth';
    }
    return null;
  }

  /// Validates Profile Photo (Selfie)
  static String? validateProfilePhoto(String? path, int? sizeInBytes) {
    if (path == null || path.trim().isEmpty) {
      return 'Please take a selfie photo';
    }
    if (sizeInBytes != null && sizeInBytes > maxFileSizeInBytes) {
      return 'Profile photo must be less than 5MB';
    }
    return null;
  }

  /// Validates Vehicle Number (Indian registration format)
  static String? validateVehicleNumber(String? value, String vehicleType) {
    if (vehicleType.toLowerCase() == 'bicycle') {
      return null; // Optional for bicycle
    }
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your vehicle registration number';
    }
    final normalized = value.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
    // Standard Indian vehicle format: 2 letters (state) + 1-2 digits (district) + 0-3 letters + 4 digits
    final vehicleRegex = RegExp(r'^[A-Z]{2}\d{1,2}[A-Z]{0,3}\d{4}$');
    if (!vehicleRegex.hasMatch(normalized)) {
      return 'Enter a valid Indian vehicle number (e.g. MH 02 AA 1234)';
    }
    return null;
  }

  /// Validates Driving License Number
  static String? validateDrivingLicenseNumber(String? value, String vehicleType) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your driving license number';
    }
    final normalized = value.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
    if (normalized.length < 9 || normalized.length > 18) {
      return 'Enter a valid driving license number (e.g. DL-1420110012345)';
    }
    if (!RegExp(r'^[A-Z]{2}[0-9A-Z]{7,16}$').hasMatch(normalized)) {
      return 'Enter a valid driving license number starting with state code';
    }
    return null;
  }

  /// Validates Driving License Photo
  static String? validateDrivingLicensePhoto(String? path, int? sizeInBytes) {
    if (path == null || path.trim().isEmpty) {
      return 'Please upload the front of your driving license';
    }
    if (sizeInBytes != null && sizeInBytes > maxFileSizeInBytes) {
      return 'Driving license photo must be less than 5MB';
    }
    return null;
  }

  /// Validates Aadhaar Front Photo
  static String? validateAadhaarFront(String? path, int? sizeInBytes) {
    if (path == null || path.trim().isEmpty) {
      return 'Please upload Aadhaar card front photo';
    }
    if (sizeInBytes != null && sizeInBytes > maxFileSizeInBytes) {
      return 'Aadhaar front photo must be less than 5MB';
    }
    return null;
  }

  /// Validates Aadhaar Back Photo
  static String? validateAadhaarBack(String? path, int? sizeInBytes) {
    if (path == null || path.trim().isEmpty) {
      return 'Please upload Aadhaar card back photo';
    }
    if (sizeInBytes != null && sizeInBytes > maxFileSizeInBytes) {
      return 'Aadhaar back photo must be less than 5MB';
    }
    return null;
  }

  /// Validates PAN Card Number (5 letters + 4 digits + 1 letter)
  static String? validatePanNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your PAN card number';
    }
    final normalized = value.trim().toUpperCase();
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
    if (!panRegex.hasMatch(normalized)) {
      return 'Enter a valid 10-character PAN (e.g. ABCDE1234F)';
    }
    return null;
  }

  /// Validates Bank Account Number
  static String? validateBankAccountNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your bank account number';
    }
    final trimmed = value.trim();
    if (!RegExp(r'^\d+$').hasMatch(trimmed)) {
      return 'Bank account number must contain only digits';
    }
    if (trimmed.length < 9 || trimmed.length > 18) {
      return 'Enter a valid 9 to 18 digit bank account number';
    }
    return null;
  }

  /// Validates Bank IFSC Code (4 letters + 0 + 6 alphanumeric)
  static String? validateIfscCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your bank IFSC code';
    }
    final normalized = value.trim().toUpperCase();
    final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (!ifscRegex.hasMatch(normalized)) {
      return 'Enter a valid IFSC code (e.g. HDFC0000123)';
    }
    return null;
  }
}
