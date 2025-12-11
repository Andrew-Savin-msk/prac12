import 'package:mobx/mobx.dart';
import 'package:prac12/domain/usecases/account/register_usecase.dart';

class RegistrationScreenStore {
  RegistrationScreenStore(this._registerUseCase) {
    _canRegister = Computed(() =>
        name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword);
  }

  final RegisterUseCase _registerUseCase;

  final Observable<String> _name = Observable('');
  String get name => _name.value;
  set name(String value) => _name.value = value;

  final Observable<String> _email = Observable('');
  String get email => _email.value;
  set email(String value) => _email.value = value;

  final Observable<String> _password = Observable('');
  String get password => _password.value;
  set password(String value) => _password.value = value;

  final Observable<String> _confirmPassword = Observable('');
  String get confirmPassword => _confirmPassword.value;
  set confirmPassword(String value) => _confirmPassword.value = value;

  final Observable<String?> _errorMessage = Observable(null);
  String? get errorMessage => _errorMessage.value;
  set errorMessage(String? value) => _errorMessage.value = value;

  late final Computed<bool> _canRegister;
  bool get canRegister => _canRegister.value;

  void setName(String value) {
    runInAction(() {
      name = value;
      errorMessage = null;
    });
  }

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

  void setConfirmPassword(String value) {
    runInAction(() {
      confirmPassword = value;
      errorMessage = null;
    });
  }

  void clearError() {
    runInAction(() {
      errorMessage = null;
    });
  }

  Future<bool> register() async {
    try {
      await _registerUseCase(
        name: name.trim(),
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

