import 'remote/auth_repository/firebase_auth_repo.dart';
import 'remote/user_repository/firebase_user_repository.dart';

class AppRepository {
  get authRepository {
    return FirebaseAuthRepository();
  }

  get userRepository {
    return FirebaseUserRepository();
  }

  /// Singleton factory Constructor
  AppRepository._internal();
  static final AppRepository _instance = AppRepository._internal();
  factory AppRepository() {
    return _instance;
  }
}
