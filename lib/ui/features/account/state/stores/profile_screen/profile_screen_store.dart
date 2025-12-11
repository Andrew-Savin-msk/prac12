import 'package:mobx/mobx.dart';
import 'package:prac12/core/models/account/user_account_model.dart';
import 'package:prac12/domain/usecases/account/get_current_user_usecase.dart';

class ProfileScreenStore {
  ProfileScreenStore(this._getCurrentUserUseCase) {
    _isLoggedIn = Computed(() => user != null);
    loadCurrentUser();
  }

  final GetCurrentUserUseCase _getCurrentUserUseCase;

  final Observable<UserAccount?> _user = Observable(null);
  UserAccount? get user => _user.value;
  set user(UserAccount? value) => _user.value = value;

  late final Computed<bool> _isLoggedIn;
  bool get isLoggedIn => _isLoggedIn.value;

  void loadCurrentUser() {
    runInAction(() {
      user = _getCurrentUserUseCase();
    });
  }
}

