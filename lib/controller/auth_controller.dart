import 'package:matsu_gtd/controller/loading_state.dart';
import 'package:matsu_gtd/core/firebase/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  LoadingState build() {
    return const LoadingState(LoadingStateEnum.initial, null);
  }

  Future<void> signInWithGoogle() async {
    state = const LoadingState(LoadingStateEnum.loading, null);
    try {
      final authRepository = ref.watch(authRepositoryProvider);
      await authRepository.signInWithGoogle();
      state = const LoadingState(LoadingStateEnum.success, null);
    } on Exception catch (e) {
      state = LoadingState(LoadingStateEnum.error, e);
    }
  }

  Future<void> signOut() async {
    state = const LoadingState(LoadingStateEnum.loading, null);

    final authRepository = ref.watch(authRepositoryProvider);
    try {
      await authRepository.signOut();
      state = const LoadingState(LoadingStateEnum.success, null);
    } on Exception catch (e) {
      state = LoadingState(LoadingStateEnum.error, e);
    }
  }
}
