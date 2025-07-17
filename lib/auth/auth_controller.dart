import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref),
);

class AuthState {
  final bool isLoading;
  final String? verificationId;
  final String? error;
  final User? user;

  AuthState({
    this.isLoading = false,
    this.verificationId,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? verificationId,
    String? error,
    User? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      verificationId: verificationId ?? this.verificationId,
      error: error,
      user: user ?? this.user,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final Ref ref;
  AuthController(this.ref) : super(AuthState());

  Future<void> verifyPhone(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref
          .read(authServiceProvider)
          .verifyPhoneNumber(
            phoneNumber: phone,
            codeSent: (verificationId) {
              state = state.copyWith(
                isLoading: false,
                verificationId: verificationId,
              );
            },
            verificationFailed: (e) {
              state = state.copyWith(isLoading: false, error: e.message);
            },
            codeAutoRetrievalTimeout: (verificationId, _) {
              state = state.copyWith(verificationId: verificationId);
            },
            verificationCompleted: (credential) async {
              final userCred = await FirebaseAuth.instance.signInWithCredential(
                credential,
              );
              state = state.copyWith(isLoading: false, user: userCred.user);
            },
          );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signInWithOTP(String smsCode) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userCred = await ref
          .read(authServiceProvider)
          .signInWithOTP(
            verificationId: state.verificationId!,
            smsCode: smsCode,
          );
      state = state.copyWith(isLoading: false, user: userCred.user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
    state = AuthState();
  }
}
