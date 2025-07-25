import 'dart:io';

import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/custom/btn.dart';
import 'package:active_ecommerce_cms_demo_app/custom/device_info.dart';
import 'package:active_ecommerce_cms_demo_app/custom/google_recaptcha.dart';
import 'package:active_ecommerce_cms_demo_app/custom/input_decorations.dart';
import 'package:active_ecommerce_cms_demo_app/custom/intl_phone_input.dart';
import 'package:active_ecommerce_cms_demo_app/custom/toast_component.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/other_config.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/auth_repository.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/profile_repository.dart';
import 'package:active_ecommerce_cms_demo_app/screens/auth/login.dart';
import 'package:active_ecommerce_cms_demo_app/screens/common_webview_screen.dart';
import 'package:active_ecommerce_cms_demo_app/ui_elements/auth_ui.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:validators/validators.dart';

import '../../custom/loading.dart';
import '../../helpers/auth_helper.dart';
import '../../repositories/address_repository.dart';
import '../home/home.dart';
import 'otp.dart';
import 'package:go_router/go_router.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String initialCountry = 'EG';

  List<String?> countries_code = <String?>[];

  String _phone = "";
  bool _isValidPhoneNumber = false;
  bool? _isAgree = false;
  bool _isCaptchaShowing = false;
  String googleRecaptchaKey = "";

  //controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
    fetch_country();
  }

  fetch_country() async {
    final data = await AddressRepository().getCountryList();
    data.countries?.forEach((c) => countries_code.add(c.code));
    setState(() {});
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> onPressSignUp() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String passwordConfirm = _passwordConfirmController.text;

    if (name == "") {
      ToastComponent.showDialog(
        'enter_your_name'.tr(context: context),
        isError: true,
      );
      return;
    } else if (email.isNotEmpty && !isEmail(email)) {
      ToastComponent.showDialog(
        'enter_correct_email'.tr(context: context),
        isError: true,
      );
      return;
    } else if (_phoneNumberController.text.trim() == "") {
      ToastComponent.showDialog(
        'enter_phone_number'.tr(context: context),
        isError: true,
      );
      return;
    } else if (_isValidPhoneNumber) {
      ToastComponent.showDialog(
        'invalid_phone_number'.tr(context: context),
        isError: true,
      );
      return;
    } else if (password == "") {
      ToastComponent.showDialog(
        'enter_password'.tr(context: context),
        isError: true,
      );
      return;
    } else if (passwordConfirm == "") {
      ToastComponent.showDialog(
        'confirm_your_password'.tr(context: context),
        isError: true,
      );
      return;
    } else if (password.length < 6) {
      ToastComponent.showDialog(
        'password_must_contain_at_least_6_characters'.tr(context: context),
        isError: true,
      );
      return;
    } else if (password != passwordConfirm) {
      ToastComponent.showDialog(
        'passwords_do_not_match'.tr(context: context),
        isError: true,
      );
      return;
    }
    Loading.show(context);

    final String tempEmail =
        email.trim().isEmpty ? "$_phone@email.com" : email.trim();

    final signupResponse = await AuthRepository().getSignupResponse(
      name,
      tempEmail,
      _phone,
      password,
      passwordConfirm,
      googleRecaptchaKey,
    );
    Loading.close();

    if (signupResponse.result == false) {
      var message = "";
      signupResponse.message.forEach((value) {
        message += value + "\n";
      });

      ToastComponent.showDialog(message, isError: true);
    } else {
      ToastComponent.showDialog(
        signupResponse.message,
      );
      AuthHelper().setUserData(signupResponse);

      // redirect to main
      // Navigator.pushAndRemoveUntil(context,
      //     MaterialPageRoute(builder: (context) {
      //       return Main();
      //     }), (newRoute) => false);
      // context.go("/");

      // push notification starts
      if (OtherConfig.USE_PUSH_NOTIFICATION) {
        final FirebaseMessaging _fcm = FirebaseMessaging.instance;
        await _fcm.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

        final String? fcmToken = await _fcm.getToken();

        print("--fcm token--");
        print("fcmToken $fcmToken");
        if (is_logged_in.$ == true) {
          // update device token
          await ProfileRepository().getDeviceTokenUpdateResponse(fcmToken!);
        }
      }

      // context.go("/");

      if (AppConfig.businessSettingsData.mailVerificationStatus ||
          AppConfig.businessSettingsData.mustOtp) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const Otp(
            fromRegistration: true,
            // verify_by: _register_by,
            // user_id: signupResponse.user_id,
          );
        }));
      } else {
        if (AppConfig.businessSettingsData.sellerWiseShipping) {
          await homeData.handleAddressNavigation();
        }
        context.push("/");

        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return Home();
        // }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screen_width = MediaQuery.of(context).size.width;
    return AuthScreen.buildScreen(
        context,
        "${'join_ucf'.tr(context: context)} " + 'app_name'.tr(context: context),
        buildBody(context, _screen_width));
  }

  Column buildBody(BuildContext context, double _screen_width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: _screen_width * (3 / 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    bottom: AppDimensions.paddingSmallExtra),
                child: Text(
                  'name_ucf'.tr(context: context),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                child: Container(
                  height: 36,
                  child: TextField(
                    controller: _nameController,
                    autofocus: false,
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: 'name_ucf'.tr(context: context)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: AppDimensions.paddingSmallExtra),
                child: Text(
                  'email_ucf'.tr(context: context),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 36,
                      child: TextField(
                        controller: _emailController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "johndoe@example.com"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: AppDimensions.paddingSmallExtra),
                child: Text(
                  'phone_ucf'.tr(context: context),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 36,
                      child: CustomInternationalPhoneNumberInput(
                        countries: countries_code,
                        hintText: 'phone_number_ucf'.tr(context: context),
                        errorMessage:
                            'invalid_phone_number'.tr(context: context),
                        initialValue:
                            PhoneNumber(isoCode: AppConfig.default_country),
                        onInputChanged: (PhoneNumber number) {
                          _phoneNumberController.text = number.parseNumber();
                          setState(() {
                            if (number.isoCode != null)
                              AppConfig.default_country = number.isoCode!;
                            _phone = number.phoneNumber ?? '';
                          });
                        },
                        onInputValidated: (bool isNotValid) {
                          print(isNotValid);
                          _isValidPhoneNumber = !isNotValid;
                        },
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.DIALOG,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle:
                            const TextStyle(color: MyTheme.font_grey),
                        // initialValue: PhoneNumber(
                        //     isoCode: countries_code[0].toString()),
                        formatInput: true,
                        inputDecoration:
                            InputDecorations.buildInputDecoration_phone(
                          hint_text: "01XXX XXX XXX",
                        ),
                        onSaved: (PhoneNumber number) {
                          //print('On Saved: $number');
                        },
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     setState(() {
                    //       _register_by = "email";
                    //     });
                    //   },
                    //   child: Text(
                    //     '//'.tr(context: context)         .or_register_with_an_email,
                    //     style: TextStyle(
                    //         color: MyTheme.accent_color,
                    //         fontStyle: FontStyle.italic,
                    //         decoration: TextDecoration.underline),
                    //   ),
                    // )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: AppDimensions.paddingSmallExtra),
                child: Text(
                  'password_ucf'.tr(context: context),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 36,
                      child: TextField(
                        controller: _passwordController,
                        autofocus: false,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "• • • • • • • •"),
                      ),
                    ),
                    Text(
                      'password_must_contain_at_least_6_characters'
                          .tr(context: context),
                      style: const TextStyle(
                          color: MyTheme.textfield_grey,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: AppDimensions.paddingSmallExtra),
                child: Text(
                  'retype_password_ucf'.tr(context: context),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                child: Container(
                  height: 36,
                  child: TextField(
                    controller: _passwordConfirmController,
                    autofocus: false,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: "• • • • • • • •"),
                  ),
                ),
              ),
              if (AppConfig.businessSettingsData.googleRecaptcha)
                Container(
                  height: _isCaptchaShowing ? 350 : 50,
                  width: 300,
                  child: Captcha(
                    (keyValue) {
                      googleRecaptchaKey = keyValue;
                      setState(() {});
                    },
                    handleCaptcha: (data) {
                      if (_isCaptchaShowing.toString() != data) {
                        _isCaptchaShowing = data;
                        setState(() {});
                      }
                    },
                    isIOS: Platform.isIOS,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: AppDimensions.paddingLarge),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 15,
                      width: 15,
                      child: Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusHalfSmall)),
                          value: _isAgree,
                          onChanged: (newValue) {
                            _isAgree = newValue;
                            setState(() {});
                          }),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsetsDirectional.only(start: 8.0),
                        width: DeviceInfo(context).width! - 130,
                        child: RichText(
                            maxLines: 2,
                            text: TextSpan(
                                style: const TextStyle(
                                    color: MyTheme.font_grey, fontSize: 12),
                                children: [
                                  TextSpan(
                                    text: 'i_agree_to_the'.tr(context: context),
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CommonWebviewScreen(
                                                      page_name:
                                                          'terms_conditions_ucf'
                                                              .tr(
                                                                  context:
                                                                      context),
                                                      url:
                                                          "${AppConfig.RAW_BASE_URL}/mobile-page/terms",
                                                    )));
                                      },
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                    text:
                                        " ${'terms_conditions_ucf'.tr(context: context)}",
                                  ),
                                  const TextSpan(
                                    text: " &",
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CommonWebviewScreen(
                                                      page_name:
                                                          'privacy_policy_ucf'
                                                              .tr(
                                                                  context:
                                                                      context),
                                                      url:
                                                          "${AppConfig.RAW_BASE_URL}/mobile-page/privacy-policy",
                                                    )));
                                      },
                                    text:
                                        " ${'privacy_policy_ucf'.tr(context: context)}",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )
                                ])),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: AppDimensions.paddingExtraLarge),
                child: Container(
                  height: 45,
                  child: Btn.minWidthFixHeight(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
                    color: Theme.of(context).primaryColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppDimensions.radiusHalfSmall))),
                    child: Text(
                      'sign_up_ucf'.tr(context: context),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: _isAgree!
                        ? () {
                            onPressSignUp();
                          }
                        : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: AppDimensions.paddingLarge),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      'already_have_an_account'.tr(context: context),
                      style: const TextStyle(
                          color: MyTheme.font_grey, fontSize: 12),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Text(
                        'log_in'.tr(context: context),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Login();
                        }));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
