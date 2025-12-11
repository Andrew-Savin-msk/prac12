import 'package:mobx/mobx.dart';
import 'package:prac12/domain/usecases/account/login_usecase.dart';

class LoginScreenStore {
  LoginScreenStore(this._loginUseCase) {
    _canLogin = Computed(() => email.isNotEmpty && password.isNotEmpty);
  }

  final LoginUseCase _loginUseCase;

  final Observable<String> _email = Observable('');
  String get email => _email.value;
  set email(String value) => _email.value = value;

  final Observable<String> _password = Observable('');
  String get password => _password.value;
  set password(String value) => _password.value = value;

  final Observable<String?> _errorMessage = Observable(null);
  String? get errorMessage => _errorMessage.value;
  set errorMessage(String? value) => _errorMessage.value = value;

  late final Computed<bool> _canLogin;
  bool get canLogin => _canLogin.value;

  void setEmail(String value) {
    runInAction(() {
      email = value;
      errorMessage = null;
    });
  }

  void setPassword(String value) {
    runInAction(() {
      password = value;
      errorMessage = null;
    });
  }

  void clearError() {
    runInAction(() {
      errorMessage = null;
    });
  }

  Future<bool> login() async {
    try {
      await _loginUseCase(
        email: email.trim(),
        password: password,
      );
      runInAction(() {
        errorMessage = null;
      });
      return true;
    } catch (e) {
      runInAction(() {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
      return false;
    }
  }
}

