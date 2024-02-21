import 'package:chat_demo_for_swazz/enums/loading_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../common_widgets/common_filled_button.dart';

final firebaseAuthProvider = ChangeNotifierProvider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

class FirebaseAuthService extends ChangeNotifier {
  bool isUserLoggedIn() {
    return (FirebaseAuth.instance.currentUser != null);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void signInWithPhone({
    required BuildContext context,
    required Function(LoadingStatus loadingStatus) loadingStatus,
    required String phoneNumber,
    required Function(String? error) onError,
    required Function(UserCredential userCredential) onSuccessfulSignIn,
    required Function(String verificationId) otpSent,
  }) {
    loadingStatus.call(LoadingStatus.loading);

    FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationFailed: (FirebaseAuthException error) {
        loadingStatus.call(LoadingStatus.errorWhileLoading);
        onError.call(error.toString());
      },
      codeSent: (String verificationId, int? forceResendingToken) async {
        loadingStatus.call(LoadingStatus.done);

        otpSent.call(verificationId);
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
        FirebaseAuth.instance.signInWithCredential(phoneAuthCredential).then(
          (value) {
            loadingStatus.call(LoadingStatus.done);
            onSuccessfulSignIn.call(value);
          },
        ).catchError(
          (error) {
            loadingStatus.call(LoadingStatus.errorWhileLoading);
            onError.call(onError.toString());
          },
        );
      },
    )
        .onError(
      (error, stackTrace) {
        loadingStatus.call(LoadingStatus.errorWhileLoading);
        onError.call(onError.toString());
      },
    );
  }

  void verifyOTP({
    required String verificationId,
    required String otp,
    required Function(LoadingStatus loadingStatus) loadingStatus,
    required Function(UserCredential userCredential) onSuccessfulSignIn,
    required Function(String error) onError,
  }) {
    loadingStatus.call(LoadingStatus.loading);

    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);

    FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) {
      loadingStatus.call(LoadingStatus.done);
      onSuccessfulSignIn.call(value);
    }).catchError((error) {
      loadingStatus.call(LoadingStatus.errorWhileLoading);
      onError.call(error.toString());
    });
  }
}
