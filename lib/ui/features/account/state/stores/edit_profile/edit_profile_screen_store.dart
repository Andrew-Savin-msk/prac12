import 'package:mobx/mobx.dart';
import 'package:prac12/domain/usecases/account/get_current_user_usecase.dart';
import 'package:prac12/domain/usecases/account/update_profile_usecase.dart';

class EditProfileScreenStore {
  EditProfileScreenStore(
    this._getCurrentUserUseCase,
    this._updateProfileUseCase,
  ) {
    _canSave = Computed(() => name.isNotEmpty && email.isNotEmpty);
    final currentUser = _getCurrentUserUseCase();
    if (currentUser != null) {
      runInAction(() {
        name = currentUser.name;
        email = currentUser.email;
        avatarUrl = currentUser.avatarUrl;
      });
    }
  }

  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  final Observable<String> _name = Observable('');
  String get name => _name.value;
  set name(String value) => _name.value = value;

  final Observable<String> _email = Observable('');
  String get email => _email.value;
  set email(String value) => _email.value = value;

  final Observable<String?> _avatarUrl = Observable(null);
  String? get avatarUrl => _avatarUrl.value;
  set avatarUrl(String? value) => _avatarUrl.value = value;

  final Observable<String?> _errorMessage = Observable(null);
  String? get errorMessage => _errorMessage.value;
  set errorMessage(String? value) => _errorMessage.value = value;

  late final Computed<bool> _canSave;
  bool get canSave => _canSave.value;

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

  void setAvatarUrl(String? value) {
    runInAction(() {
      avatarUrl = value;
      errorMessage = null;
    });
  }

  void clearError() {
    runInAction(() {
      errorMessage = null;
    });
  }

  Future<bool> save() async {
    try {
      _updateProfileUseCase(
        name: name.trim(),
        email: email.trim(),
        avatarUrl: avatarUrl,
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

