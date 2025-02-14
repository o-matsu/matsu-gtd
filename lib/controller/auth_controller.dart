import 'package:matsu_gtd/controller/loading_state.dart';
import 'package:matsu_gtd/core/firebase_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AuthLoadingState build() {
    return const AuthLoadingState(LoadingStateEnum.initial, null);
  }

  Future<void> signInWithGoogle() async {
    state = const AuthLoadingState(LoadingStateEnum.loading, null);
    try {
      final authRepository = ref.watch(authRepositoryProvider);
      await authRepository.signInWithGoogle();
      state = const AuthLoadingState(LoadingStateEnum.success, null);
    } on Exception catch (e) {
      state = AuthLoadingState(LoadingStateEnum.error, e);
    }
  }

  Future<void> signOut() async {
    state = const AuthLoadingState(LoadingStateEnum.loading, null);

    final authRepository = ref.watch(authRepositoryProvider);
    try {
      await authRepository.signOut();
      state = const AuthLoadingState(LoadingStateEnum.success, null);
    } on Exception catch (e) {
      state = AuthLoadingState(LoadingStateEnum.error, e);
    }
  }
}
