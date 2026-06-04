extension StringExtension on String {
  bool get hasLetter {
    return contains(RegExp(r'[A-Za-z]'));
  }

  bool get hasNumber {
    return contains(RegExp(r'\d'));
  }

  bool get hasSymbol {
    return contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=~`[\]\\;/]'));
  }
}
