import 'dart:async';
import 'dart:developer';

import 'package:chat_demo_for_swazz/common_widgets/common_filled_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../enums/loading_status.dart';
import '../providers/firebase_provider.dart';
import 'home_page.dart';

class VerifyOTPPage extends ConsumerStatefulWidget {
  const VerifyOTPPage(
      {super.key, required this.phoneNumber, required this.isRegister});

  final String phoneNumber;
  final bool isRegister;

  @override
  ConsumerState<VerifyOTPPage> createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends ConsumerState<VerifyOTPPage> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  String otp = "";
  String verificationId = "";
  int remainingTime = 30;

  Timer? timer;

  void startCountDown() {
    remainingTime = 30;

    if (timer != null) {
      timer!.cancel();
    }

    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (remainingTime == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            remainingTime--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    sendOTP();
  }

  void sendOTP() {
    ref.read(firebaseProvider).sendOTP(
          context: context,
          loadingStatus: (loadingStatus) {
            log("loading_status----- $loadingStatus");
            if (loadingStatus == LoadingStatus.loading) {
              isLoading = true;
            } else {
              isLoading = false;
            }
            setState(() {});
          },
          phoneNumber: widget.phoneNumber,
          onError: (error) {
            log("auth------- ${error.toString()}");
            Fluttertoast.showToast(msg: "Error: ${error.toString()}");
          },
          onVerificationCompleted: (phoneAuthCredential) {
            log("auth------- verification completed");

            if (widget.isRegister) {
              Get.offAll(() => const HomePage());
            } else {
              Get.back(result: phoneAuthCredential);
            }
          },
          otpSent: (verificationId) {
            this.verificationId = verificationId;
            startCountDown();
          },
        );
  }

  void verifyOTP() {
    PhoneAuthCredential phoneAuthCredential =
        ref.read(firebaseProvider).getAuthCredentialFromOTP(
              verificationId: verificationId,
              otp: otp,
            );

    if (widget.isRegister) {
      ref.read(firebaseProvider).signInWithPhoneCredential(
            phoneAuthCredential: phoneAuthCredential,
            loadingStatus: (loadingStatus) {
              setState(() {
                if (loadingStatus == LoadingStatus.loading) {
                  isLoading = true;
                } else {
                  isLoading = false;
                }
              });
            },
            onSuccessfulSignIn: (userCredential) {
              if (timer != null) {
                timer!.cancel();
              }

              Get.back();
            },
            onError: (error) {
              Fluttertoast.showToast(msg: "Error: $error");
            },
          );
    } else {
      ref.read(firebaseProvider).updatePhoneNumberWithCredential(
            phoneAuthCredential: phoneAuthCredential,
            loadingStatus: (loadingStatus) {
              setState(() {
                if (loadingStatus == LoadingStatus.loading) {
                  isLoading = true;
                } else {
                  isLoading = false;
                }
              });
            },
            onError: (String error) {
              Fluttertoast.showToast(msg: "Error: $error");
            },
            onSuccess: () {
              if (timer != null) {
                timer!.cancel();
              }

              Get.back();
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 0.10.sw,
      height: 0.10.sw,
      textStyle: TextStyle(
          fontSize: 20.sp,
          color: const Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(4),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(16.r),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox.fromSize(
                        size: Size(0, 0.05.sh),
                      ),
                      Text(
                        "OTP Verification",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white.withOpacity(0.75),
                          ),
                          children: <TextSpan>[
                            const TextSpan(text: 'OTP sent to '),
                            TextSpan(
                              text: widget.phoneNumber,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      Expanded(
                        child: Pinput(
                          length: 6,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          onCompleted: (pin) {
                            otp = pin;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      CommonFilledButton(
                        isFullWidth: true,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (otp.isNotEmpty && verificationId.isNotEmpty) {
                              verifyOTP();
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        text: "Verify OTP",
                      ),
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      if (!isLoading)
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                            children: <TextSpan>[
                              if (remainingTime != 0) ...[
                                const TextSpan(text: 'Resend OTP in '),
                                TextSpan(
                                  text: remainingTime.toString(),
                                ),
                                const TextSpan(text: ' seconds'),
                              ] else ...[
                                TextSpan(
                                  text: "Resend OTP",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      sendOTP();
                                    },
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                )
                              ]
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.50),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
