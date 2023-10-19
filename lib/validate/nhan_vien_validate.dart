class NhanVienValidate {
  RegExp expName = RegExp(r"<[^>]*>");
  RegExp expEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  RegExp expPhone = RegExp(r"^\d{1,4}-\d{1,4}-\d{1,4}$");

  String? validateName(String? name){
    if (name == null || name.isEmpty) {
      return 'Vui lòng nhập name';
    } else if (expName.hasMatch(name)) {
      return 'Vui lòng nhập name hợp lệ';
    }
    return null;
  }

  String? validateEmail(String? email){
    if (email == null || email.isEmpty) {
      return 'Vui lòng nhập email';
    } else if (!expEmail.hasMatch(email)) {
      return 'Vui lòng nhập email hợp lệ';
    }
    return null;
  }

  String? validatePhone(String? phone){
    if (phone == null || phone.isEmpty) {
      return 'Vui lòng nhập phone';
    } else if (!expPhone.hasMatch(phone)) {
      return 'Vui lòng nhập phone hợp lệ';
    }
    return null;
  }
}