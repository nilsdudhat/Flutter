import 'package:chat_demo_for_swazz/common_widgets/common_filled_button.dart';
import 'package:chat_demo_for_swazz/common_widgets/common_outlined_button.dart';
import 'package:chat_demo_for_swazz/common_widgets/common_text_field.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final phoneFieldController = TextEditingController();
  String countryCode = "+91";

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.all(16.r),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 0.05.sh,
                  ),
                  SizedBox(
                    height: 0.15.sh,
                    child: Image.asset("assets/images/telephone.png"),
                  ),
                  SizedBox(
                    height: 0.05.sh,
                  ),
                  CommonTextField(
                    controller: phoneFieldController,
                    labelText: "Phone Number",
                    hintText: "Ex. 96364465633",
                    textInputAction: TextInputAction.done,
                    maxLength: 10,
                    borderRadius: 12,
                    unfocusedColor: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.25),
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
                  ),
                  SizedBox(
                    height: 0.05.sh,
                  ),
                  CommonFilledButton(
                    isFullWidth: true,
                    onPressed: () {},
                    text: "Sign In",
                    radius: 12,
                  ),
                  SizedBox(
                    height: 0.05.sh,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
