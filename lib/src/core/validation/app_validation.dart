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
