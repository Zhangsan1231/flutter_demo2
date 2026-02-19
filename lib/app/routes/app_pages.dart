import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../core/service/storage_service.dart';
import '../modules/bluetooth/blue_user/bindings/blue_user_binding.dart';
import '../modules/bluetooth/blue_user/views/blue_user_view.dart';
import '../modules/bluetooth/bluetooth_connect/bindings/bluetooth_connect_binding.dart';
import '../modules/bluetooth/bluetooth_connect/views/bluetooth_connect_view.dart';
import '../modules/bluetooth/bluetooth_devices/bindings/bluetooth_devices_binding.dart';
import '../modules/bluetooth/bluetooth_devices/views/bluetooth_devices_view.dart';
import '../modules/bluetooth/bluetooth_setting/bindings/bluetooth_setting_binding.dart';
import '../modules/bluetooth/bluetooth_setting/views/bluetooth_setting_view.dart';
import '../modules/bluetooth/connect_device/bindings/connect_device_binding.dart';
import '../modules/bluetooth/connect_device/views/connect_device_view.dart';
import '../modules/bluetooth/my_bluetooth/bindings/my_bluetooth_binding.dart';
import '../modules/bluetooth/my_bluetooth/views/my_bluetooth_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/information/bindings/information_binding.dart';
import '../modules/information/views/information_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navigation/bindings/navigation_binding.dart';
import '../modules/navigation/views/navigation_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/user/bindings/user_binding.dart';
import '../modules/user/user_profile/bindings/user_profile_binding.dart';
import '../modules/user/user_profile/views/profile_name_view.dart';
import '../modules/user/user_profile/views/user_profile_view.dart';
import '../modules/user/views/user_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static String get INITIAL {
    final idToken = SecureStorageService().getIdToken();
    final user = SecureStorageService().getUserInfo();
    // print('username --------------${user?.name}');
    // print('idtoken ======= ${idToken}');
    return idToken != null ? Routes.BLUETOOTH_CONNECT : Routes.SPLASH;
  }
  // static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.USER,
      page: () => UserView(),
      binding: UserBinding(),
      children: [
        GetPage(
          name: _Paths.USER_PROFILE,
          page: () => UserProfileView(),
          binding: UserProfileBinding(),
          children: [
            GetPage(
              name: _Paths.PROFILE_NAME,
              page: () => ProfileNameView(),
            )
          ],
        ),
      ],
    ),
    GetPage(
      name: _Paths.NAVIGATION,
      page: () => NavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: _Paths.INFORMATION,
      page: () => InformationView(),
      binding: InformationBinding(),
    ),
    GetPage(
      name: _Paths.BLUE_USER,
      page: () => BlueUserView(),
      binding: BlueUserBinding(),
    ),
    GetPage(
      name: _Paths.MY_BLUETOOTH,
      page: () => MyBluetoothView(),
      binding: MyBluetoothBinding(),
    ),
    GetPage(
      name: _Paths.BLUETOOTH_DEVICES,
      page: () => BluetoothDevicesView(),
      binding: BluetoothDevicesBinding(),
    ),
    GetPage(
      name: _Paths.BLUETOOTH_CONNECT,
      page: () => BluetoothConnectView(),
      binding: BluetoothConnectBinding(),
    ),
    GetPage(
      name: _Paths.CONNECT_DEVICE,
      page: () => ConnectDeviceView(),
      binding: ConnectDeviceBinding(),
    ),
    GetPage(
      name: _Paths.BLUETOOTH_SETTING,
      page: () =>  BluetoothSettingView(),
      binding: BluetoothSettingBinding(),
    ),
  ];
}
