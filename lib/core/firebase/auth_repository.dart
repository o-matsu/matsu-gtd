// REF: https://medium.com/@jakob.prossinger/flutter-firebase-authentication-with-riverpod-2-5-and-gorouter-0311ad23550b
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return AuthRepository(auth);
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
Stream<User?> authStateChange(Ref ref) {
  final auth = ref.watch(authRepositoryProvider);
  return auth.authStateChanges();
}
