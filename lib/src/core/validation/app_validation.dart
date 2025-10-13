String? validator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Field can\'t be empty';
  }
  return null;
}

String? confirmPasswordValidator(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Confirm password can\'t be empty';
  }
  if (value != password) {
    return 'Passwords do not match';
  }
  return null;
}

String? phoneNumberValidation(String? value) {
  if (value == null) return 'Phone number is required';
  if (value.startsWith('923')) {
    /// exactly 11 digits: 923 + 8 digits
    if (RegExp(r'^923\d{9}$').hasMatch(value)) return null;
  } else if (value.startsWith('03')) {
    /// exactly 11 digits: 03 + 9 digits
    if (RegExp(r'^03\d{9}$').hasMatch(value)) return null;
  }
  return 'Incorrect phone number';
}
