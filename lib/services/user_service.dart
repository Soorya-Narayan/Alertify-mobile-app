class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() => _instance;

  UserService._internal();

  String userEmail = '';
  int alertCount = 0;

  void login(String email) {
    userEmail = email;
  }

  void incrementAlertCount() {
    alertCount++;
  }
}
