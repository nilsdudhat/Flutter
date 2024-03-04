import 'dart:developer';
import 'dart:io';

import 'package:chat_demo_for_swazz/enums/loading_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  void sendOTP({
    required BuildContext context,
    required Function(LoadingStatus loadingStatus) loadingStatus,
    required String phoneNumber,
    required Function(String? error) onError,
    required Function(PhoneAuthCredential phoneAuthCredential)
        onVerificationCompleted,
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
        loadingStatus.call(LoadingStatus.done);

        onVerificationCompleted.call(phoneAuthCredential);
      },
    )
        .catchError(
      (error) {
        loadingStatus.call(LoadingStatus.errorWhileLoading);
        onError.call(onError.toString());
      },
    );
  }

  void signInWithPhoneCredential({
    required PhoneAuthCredential phoneAuthCredential,
    required Function(LoadingStatus loadingStatus) loadingStatus,
    required Function(UserCredential userCredential) onSuccessfulSignIn,
    required Function(String? error) onError,
  }) {
    loadingStatus.call(LoadingStatus.loading);

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
  }

  PhoneAuthCredential getAuthCredentialFromOTP({
    required String verificationId,
    required String otp,
  }) {
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);

    return credential;
  }

  void getGoogleAuthCredential({
    required Function(LoadingStatus loadingStatus) loadingStatus,
    required Function(OAuthCredential authCredential) onSuccess,
    required Function(String error) onError,
  }) async {
    loadingStatus.call(LoadingStatus.loading);

    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      loadingStatus.call(LoadingStatus.done);
      onSuccess.call(credential);
    } catch (error) {
      loadingStatus.call(LoadingStatus.errorWhileLoading);
      onError.call(error.toString());
    }
  }

  void signInWithGoogleAuthCredential({
    required OAuthCredential credential,
    required Function(LoadingStatus loadingStatus) loadingStatus,
    required Function(UserCredential userCredential) onSuccessfulSignIn,
    required Function(String error) onError,
  }) {
    loadingStatus.call(LoadingStatus.loading);

    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      loadingStatus.call(LoadingStatus.done);
      onSuccessfulSignIn.call(value);
    }).catchError((error) {
      loadingStatus.call(LoadingStatus.errorWhileLoading);
      onError.call(error);
    });
  }

  String getUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  User getUser() {
    return FirebaseAuth.instance.currentUser!;
  }

  Future<bool> isUserExistInFirestore() async {
    final result = await FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: getUserId())
        .get();

    if (result.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> isEmailAlreadyInUse({
    required String enteredEmailID,
  }) async {
    final result = await FirebaseFirestore.instance
        .collection("users")
        .where("emailID", isEqualTo: enteredEmailID)
        .get();

    if (result.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> needToUpdateProfile() async {
    try {
      if (!isUserLoggedIn()) {
        return false;
      }
      if (!(await isUserExistInFirestore())) {
        return false;
      }
      final user = await FirebaseFirestore.instance
          .collection("users")
          .doc(getUserId())
          .get();

      if (user.data() == null) {
        return false;
      }
      Map<String, dynamic> dataMap = user.data()!;
      String? profileImage =
          dataMap.containsKey("profileImage") ? dataMap["profileImage"] : null;
      String? userName =
          dataMap.containsKey("userName") ? dataMap["userName"] : null;
      String? description =
          dataMap.containsKey("description") ? dataMap["description"] : null;

      if (profileImage == null ||
          profileImage.isEmpty ||
          (userName == null) ||
          userName.isEmpty ||
          (description == null) ||
          description.isEmpty) {
        return true;
      }
      return false;
    } catch (error) {
      log("isUserProfileImageAvailable: Error: $error");
      return false;
    }
  }

  void uploadProfileImage({
    required File file,
    required Function(LoadingStatus loadingStatus) loadingStatus,
    required Function(String error) onError,
    required Function(String imageUrl) onSuccess,
  }) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("users")
          .child(getUserId())
          .child("profileImage.jpg");

      loadingStatus.call(LoadingStatus.loading);

      await storageRef.putFile(file);
      final imageUrl = await storageRef.getDownloadURL();

      await getUser().updatePhotoURL(imageUrl);

      loadingStatus.call(LoadingStatus.done);

      onSuccess.call(imageUrl);
    } catch (error) {
      loadingStatus.call(LoadingStatus.errorWhileLoading);
      onError.call(error.toString());
    }
  }

  void registerUserWithFirestore({
    required String profileImage,
    required String displayName,
    required String? description,
    required Function(LoadingStatus loadingStatus) loadingStatus,
    required Function(String error) onError,
    required Function() onSuccess,
  }) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;

      loadingStatus.call(LoadingStatus.loading);

      await getUser().updateDisplayName(displayName);

      FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "userName": displayName,
        "profileImage": profileImage,
        "userId": user.uid,
        "createdOn": DateTime.now(),
        "emailID": user.email,
        "phoneNumber": user.phoneNumber,
        "description": description,
        "chatters": null
      }).then((value) {
        loadingStatus.call(LoadingStatus.done);
        onSuccess.call();
      }).catchError((error) {
        loadingStatus.call(LoadingStatus.errorWhileLoading);
        onError.call(error.toString());
      });
    } catch (error) {
      loadingStatus.call(LoadingStatus.errorWhileLoading);
      onError.call(error.toString());
    }
  }

  void updatePhoneNumberWithCredential({
    required PhoneAuthCredential phoneAuthCredential,
    required Function(LoadingStatus loadingStatus) loadingStatus,
    required Function(String error) onError,
    required Function() onSuccess,
  }) {
    try {
      loadingStatus.call(LoadingStatus.loading);

      getUser().updatePhoneNumber(phoneAuthCredential).then((value) {
        loadingStatus.call(LoadingStatus.done);
        onSuccess.call();
      }).catchError((error) {
        loadingStatus.call(LoadingStatus.errorWhileLoading);
        onError.call(error.toString());
      });
    } catch (error) {
      loadingStatus.call(LoadingStatus.errorWhileLoading);
      onError.call(error.toString());
    }
  }

  void updateProfileData({
    required Map<String, dynamic> params,
    required Function(LoadingStatus loadingStatus) loadingStatus,
    required Function(String error) onError,
    required Function() onSuccess,
  }) {
    try {
      loadingStatus.call(LoadingStatus.loading);
      params["modifiedOn"] = DateTime.now();

      FirebaseFirestore.instance
          .collection("users")
          .doc(getUserId())
          .update(params)
          .then((value) {
        loadingStatus.call(LoadingStatus.done);
        onSuccess.call();
      }).catchError((error) {
        loadingStatus.call(LoadingStatus.errorWhileLoading);
        onError.call(error.toString());
      });
    } catch (error) {
      loadingStatus.call(LoadingStatus.errorWhileLoading);

      onError.call(error.toString());
    }
  }

  void getProfileDataFromFirestore({
    required Function(LoadingStatus loadingStatus) loadingStatus,
    required Function(String error) onError,
    required Function(Map<String, dynamic>? userDataMap) onSuccess,
  }) {
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(getUserId())
          .get()
          .then((value) {
        Map<String, dynamic>? map = value.data();
        onSuccess.call(map);
      }).catchError((error) {
        loadingStatus.call(LoadingStatus.errorWhileLoading);

        onError.call(error.toString());
      });
    } catch (error) {
      loadingStatus.call(LoadingStatus.errorWhileLoading);

      onError.call(error.toString());
    }
  }
}
