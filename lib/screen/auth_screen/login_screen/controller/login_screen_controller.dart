import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zena_app/core/api_endpoints/api_endpoints.dart';
import 'package:zena_app/core/app_route/app_route.dart';

import '../../../../utils/shared_prefe.dart';

class LoginScreenController extends GetxController {
  RxBool isLoading = false.obs;
  late TextEditingController phoneNumberController;
  var countryCode = '+971'.obs; // Default country code

  /// Referral code passed via deep link (may be empty)
  RxString referralCode = ''.obs;

  /// Phone number validation (must be 9 digits for UAE, as +971 is fixed)
  RxBool isPhoneValid = false.obs;
  late VoidCallback _phoneListener;

  @override
  void onInit() {
    phoneNumberController = TextEditingController();
    // Phone number validation listener
    _phoneListener = () {
      AppLogger.apiDebug(phoneNumberController.text);
      final text = phoneNumberController.text.trim();
      isPhoneValid.value = text.length == 9;
      AppLogger.apiDebug(isPhoneValid.value.toString());
    };
    phoneNumberController.addListener(_phoneListener);

    // Read referral code from deep-link arguments if available
    final args = Get.arguments;
    if (args is Map && args['referralCode'] != null) {
      referralCode.value = args['referralCode'].toString();
      AppLogger.debug(
        'LoginScreen: referral code from deep link = "${referralCode.value}"',
        tag: 'Login',
      );
    }
    super.onInit();
  }

  void onCountryChange(String code) {
    countryCode.value = code;
  }

  Future<void> login() async {
    isLoading.value = true;
    final response = await DioService.instance.request<dynamic>(
      input: RequestInput(
        endpoint: ApiEndpoints.sendOtp,
        // endpoint: "/auth/login",
        method: RequestMethod.POST,
        jsonBody: {
          // "phoneNumber": "+8801868030247",
          "phoneNumber": countryCode + phoneNumberController.text.trim(),
          if (referralCode.value.isNotEmpty) "referralCode": referralCode.value,
        },
      ),
      responseBuilder: (data) {
        return data;
      },
    );
    isLoading.value = false;
    // SharePrefsHelper.setString(SharedPreferenceValue.token, response.data['accessToken']);
    // SharePrefsHelper.setString(SharedPreferenceValue.refreshToken, response.data['refreshToken']);
    // SharePrefsHelper.setString(SharedPreferenceValue.userId, response.data['userId']);
    // AppLogger.apiDebug(response.data.toString());
    // AppLogger.apiDebug(response.data['accessToken'].toString());
    // AppLogger.apiDebug(response.data['userId'].toString());

    if (response.isSuccess) {
      // showSnackBar('Otp Send Successfully', type: .success);
      // showSnackBar('Login Successfully', type: .success);
      Get.toNamed(
        AppRoute.otpScreen,
        arguments: phoneNumberController.text.trim(),
      );
      // Get.toNamed(AppRoute.bottomNav,);
    } else {
      showSnackBar(response.message ?? 'Something Went Wrong', type: .error);
    }
  }

  @override
  void dispose() {
    phoneNumberController.removeListener(_phoneListener);
    phoneNumberController.dispose();
    super.dispose();
  }
}
