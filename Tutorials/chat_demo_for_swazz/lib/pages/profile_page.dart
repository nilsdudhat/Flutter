import 'package:chat_demo_for_swazz/common_widgets/common_text_field.dart';
import 'package:chat_demo_for_swazz/helpers/screen_helper.dart';
import 'package:chat_demo_for_swazz/pages/verify_otp_page.dart';
import 'package:chat_demo_for_swazz/providers/firebase_provider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  String countryCode = "+91";

  final phoneKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();

  void openCountryCodePicker() {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        textStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      showPhoneCode: true,
      // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        setState(() {
          countryCode = "+${country.phoneCode}";
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuthReadProvider = ref.read(firebaseProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          if (ScreenHelper.isKeyboardVisible(context: context)) {
            FocusScope.of(context).requestFocus(FocusNode());
          } else {
            Get.back();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Profile",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 0.05.sh,
                    ),
                    Center(
                      child: SizedBox(
                        width: 0.40.sw,
                        height: 0.40.sw,
                        child: ClipOval(
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () {},
                            customBorder: const CircleBorder(),
                            child: Image.network(
                              firebaseAuthReadProvider.getUser().photoURL!,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.05.sh,
                    ),
                    Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.50),
                      ),
                    ),
                    Text(
                      firebaseAuthReadProvider.getUser().displayName!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if ((firebaseAuthReadProvider.getUser().email != null) &&
                        firebaseAuthReadProvider
                            .getUser()
                            .email!
                            .isNotEmpty) ...[
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      Text(
                        "Email ID",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.50),
                        ),
                      ),
                      Text(
                        firebaseAuthReadProvider.getUser().email!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ] else ...[
                      SizedBox(
                        height: 0.04.sh,
                      ),
                      Form(
                        key: emailKey,
                        child: CommonTextField(
                          validator: (value) {
                            if (emailController.text.isEmpty &&
                                GetUtils.isEmail(emailController.text)) {}
                            return null;
                          },
                          suffix: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.upload),
                          ),
                          controller: emailController,
                          labelText: "Email ID",
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.emailAddress,
                          borderRadius: 12,
                          maxLength: 20,
                          unfocusedColor: Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.25),
                        ),
                      ),
                    ],
                    if ((firebaseAuthReadProvider.getUser().phoneNumber !=
                            null) &&
                        firebaseAuthReadProvider
                            .getUser()
                            .phoneNumber!
                            .isNotEmpty) ...[
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      Text(
                        "Phone Number",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.50),
                        ),
                      ),
                      Text(
                        firebaseAuthReadProvider.getUser().phoneNumber!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ] else ...[
                      SizedBox(
                        height: 0.04.sh,
                      ),
                      Form(
                        key: phoneKey,
                        child: CommonTextField(
                          validator: (value) {
                            return null;
                          },
                          suffix: IconButton(
                            onPressed: () async {
                              if ((phoneKey.currentState != null) &&
                                  phoneKey.currentState!.validate()) {
                                await Get.to(
                                  () => VerifyOTPPage(
                                    phoneNumber:
                                        "$countryCode${phoneController.text.toString()}",
                                    isRegister: false,
                                  ),
                                );
                                if ((firebaseAuthReadProvider
                                            .getUser()
                                            .phoneNumber !=
                                        null) &&
                                    firebaseAuthReadProvider
                                        .getUser()
                                        .phoneNumber!
                                        .isNotEmpty) {

                                }
                              }
                            },
                            icon: const Icon(
                              Icons.upload,
                              color: Colors.white,
                            ),
                          ),
                          prefix: InkWell(
                            onTap: () {
                              openCountryCodePicker();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 12.r),
                                Text(countryCode,
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.white)),
                                SizedBox(width: 8.r),
                              ],
                            ),
                          ),
                          controller: phoneController,
                          labelText: "Phone Number",
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.phone,
                          borderRadius: 12,
                          maxLength: 20,
                          unfocusedColor: Colors.white.withOpacity(0.25),
                        ),
                      ),
                    ],
                    SizedBox(
                      height: 0.05.sh,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
