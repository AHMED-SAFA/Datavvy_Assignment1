import '../constants/app_strings.dart';

class Validators {
  static String? validateRequired(String? value, [String? customMessage]) {
    if (value == null || value.trim().isEmpty) {
      return customMessage ?? AppStrings.valRequired;
    }
    return null;
  }

  static String? validateVehicleNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.valVehicleNumberRequired;
    }
    final trimmed = value.trim();
    if (trimmed.length < 2 || trimmed.length > 50) {
      return AppStrings.valVehicleNumberLength;
    }
    return null;
  }

  static String? validateBrand(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.valBrandRequired;
    }
    if (value.trim().length > 100) {
      return 'Brand must not exceed 100 characters';
    }
    return null;
  }

  static String? validateModel(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.valModelRequired;
    }
    if (value.trim().length > 100) {
      return 'Model must not exceed 100 characters';
    }
    return null;
  }

  static String? validateType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.valTypeRequired;
    }
    return null;
  }

  static String? validateColor(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.valColorRequired;
    }
    if (value.trim().length > 50) {
      return 'Color must not exceed 50 characters';
    }
    return null;
  }

  static String? validateYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.valYearRequired;
    }
    final year = int.tryParse(value.trim());
    if (year == null) {
      return 'Please enter a valid year number';
    }
    if (year < 1886 || year > 2100) {
      return AppStrings.valYearRange;
    }
    return null;
  }

  static String? validateOwnerName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.valOwnerRequired;
    }
    if (value.trim().length > 150) {
      return 'Owner name must not exceed 150 characters';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    return null;
  }
}
