class Validators {
  static String? licensePlateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Plaka zorunludur';
    }
    if (value.length < 3) {
      return 'Plaka en az 4 karakter olmalıdır';
    }
    return null;
  }

  static String? modelYearValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Model Yılı zorunludur';
    }
    if (value.length != 4) {
      return 'Geçersiz Model Yılı';
    }

    return null;
  }

  static String? brandValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Marka zorunludur';
    }
    if (value.length < 3) {
      return 'Marka en az 3 karakter olmalıdır';
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefon zorunludur';
    }
    if (value.length <= 10) {
      return 'Telefon no 11 karakter olmalıdır';
    }
    return null;
  }

  static String? modelValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Model zorunludur';
    }
    if (value.length < 3) {
      return 'Model en az 3 karakter olmalıdır';
    }
    return null;
  }

  static String? tcNoValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Müşteri Tc Kimlik No zorunludur';
    }
    if (value.length != 11) {
      return 'Geçersiz Tc Kimlik No';
    }

    return null;
  }

  static String? customerNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Müşteri Adı Soyadı zorunludur';
    }
    return null;
  }

  static String? customerPhoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Müşteri Telefon zorunludur';
    }
    if (value.length < 10) {
      return 'Telefon en az 10 karakter olmalıdır';
    }
    return null;
  }

  static String? issueValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Yaşanılan Sorun zorunludur';
    }
    return null;
  }

  static String? mileageValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kilometre zorunludur';
    }
    return null;
  }
}
