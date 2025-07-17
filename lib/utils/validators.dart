String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
  }
  
  // Remove spaces and special characters
  String cleanedValue = value.replaceAll(RegExp(r'[^\d+]'), '');
  
  // Check for Indian phone number format
  final phoneRegExp = RegExp(r'^(\+91)?\d{10}$');
  if (!phoneRegExp.hasMatch(cleanedValue)) {
    return 'Enter a valid 10-digit Indian phone number';
  }
  
  return null;
}

String? validateOTP(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter the OTP';
  }
  
  // Remove spaces and non-digits
  String cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');
  
  if (cleanedValue.length != 6) {
    return 'OTP must be 6 digits';
  }
  
  return null;
}