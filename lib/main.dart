import 'package:core_kit/core_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zena_app/core/api_endpoints/api_endpoints.dart';
import 'package:zena_app/core/app_bindings/app_bindings.dart';
import 'package:zena_app/core/services/deep_link_service.dart';
import 'package:zena_app/core/services/location_controller.dart';
import 'package:zena_app/utils/shared_prefe.dart';
import 'package:zena_app/widget/app_device_utils/app_deviceutils.dart';
import 'package:zena_app/widget/app_observer/app_observer.dart';

import 'core/app_route/app_route.dart';
import 'core/app_translations/app_translations.dart';
import 'core/services/notificaiton_service.dart';
import 'firebase_options.dart';
import 'screen/splash_screen/splash_screen.dart';
import 'utils/app_colors/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //! Device Utils
  DeviceUtils.lockDevicePortrait();
  //! Deep link service — captures cold-start link BEFORE runApp so splash can read it immediately
  await DeepLinkService.init();
  //! Location controller — start fetching NOW so it's ready when any screen opens
  Get.put(LocationController());

  String savedLang = await SharePrefsHelper.getString(
    SharedPreferenceValue.language,
  );
  if (savedLang.isEmpty) {
    savedLang = 'en';
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔔 Init local notifications plugin + Android channel
  NotificationService.initLocalNotifications();
  // 🔥 Setup FCM AFTER Firebase init
  await NotificationService().setupFCM();

  runApp(MyApp(savedLang: savedLang));
}

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  final String savedLang;
  const MyApp({super.key, required this.savedLang});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslations(),
      locale: Locale(savedLang),
      fallbackLocale: const Locale('en'),
      initialBinding: AppInitialBindings(),
      navigatorObservers: [NavigationObserver()],
      scaffoldMessengerKey: scaffoldMessengerKey,
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 200),
      initialRoute: AppRoute.splashscreen,
      navigatorKey: Get.key,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',

        scaffoldBackgroundColor: AppColor.screenBackgroundColor,
        appBarTheme: AppBarTheme(
          surfaceTintColor: Colors.white,
          centerTitle: true,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.whiteColor,
          primary: AppColor.primaryColor, // button
          onPrimary: AppColor.darkColor, // text on button
          secondary: AppColor.textColor, // unselected radio
          onSurface: AppColor.textColor, //text on card
          surface: AppColor.secondaryColor, //card color
          outline: AppColor.textColor, // border color
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.transparent,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(40),
          //   borderSide: BorderSide(color: AppColor.outlineColor, width: 1.5),
          // ),
          hintStyle: TextStyle(
            color: AppColor.textColor,
            fontStyle: FontStyle.normal,
          ), //hint and prefix color
        ),
        snackBarTheme: SnackBarThemeData(backgroundColor: AppColor.whiteColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(80, 48),
            backgroundColor: AppColor.primaryColor, //button background
            foregroundColor: Colors.orangeAccent, //loader color
            textStyle: const TextStyle(
              color: AppColor.darkColor,
              fontSize: 16,
            ), //title color
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1.5, color: Colors.transparent),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
      ),
      getPages: AppRoute.appRoutes,
      unknownRoute: GetPage(
        name: AppRoute.splashscreen,
        page: () => SplashScreen(),
      ),
      builder: (context, child) {
        return corekitInit(child);
      },
    );
  }

  Widget corekitInit(Widget? child) {
    return CoreKit.init(
      navigatorKey: Get.key,
      //scaffoldMessangeKey: scaffoldMessengerKey,
      // back: () {
      //   Get.back();
      // },
      appbarConfig: AppbarConfig(
        onBack: () {
          Get.back();
        },
        backButton: AppBackButton(),
      ),

      designSize: const Size(428, 926),
      imageBaseUrl: ApiEndpoints.domain,
      // backButton: Icon(Icons.arrow_back_ios, color: Colors.red),
      //navigatorKey: Get.key,
      dioServiceConfig: DioServiceConfig(
        baseUrl: ApiEndpoints.baseUrl,
        refreshTokenEndpoint: ApiEndpoints.refreshToken,
        onLogout: () {
          // StorageService().removeTokens();
          Get.offAllNamed(AppRoute.splashscreen);
        },
        enableDebugLogs: kDebugMode,
      ),
      tokenProvider: TokenProvider(
        accessToken: () async =>
            SharePrefsHelper.getString(SharedPreferenceValue.token),
        refreshToken: () async =>
            SharePrefsHelper.getString(SharedPreferenceValue.refreshToken),
        updateTokens: (data) async {
          await SharePrefsHelper.setString(
            SharedPreferenceValue.token,
            data['accessToken'],
          );
          await SharePrefsHelper.setString(
            SharedPreferenceValue.refreshToken,
            data['refreshToken'],
          );
        }, // clearTokens: () => StorageService().removeTokens()
      ),
      child: child,
    );
  }
}

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFE7FEF0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.arrow_back_ios_new,
        size: 18,
        color: AppColor.darkColor,
      ),
    );
  }
}

