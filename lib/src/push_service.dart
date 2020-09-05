import 'dart:io';

import 'package:apn_push/src/device_request.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_udid/flutter_udid.dart';

class PushService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void initialize({
    @required ValueChanged<Map<String, dynamic>> onForeground,
    @required ValueChanged<Map<String, dynamic>> onBackground,
  }) {
    _firebaseMessaging.configure(
      onMessage: onForeground,
      onLaunch: onBackground,
      onResume: onBackground,
    );
  }

  Future<bool> requestPermissions() async {
    final result = await _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
    ));

    return result == true;
  }

  Future<String> getFirebaseToken() async => await _firebaseMessaging.getToken();

  Future<DeviceRequest> getDeviceRequest() async {
    final token = await getFirebaseToken();

    if (Platform.isIOS) return _getIOSDevice(token);
    if (Platform.isAndroid) return _getAndroidDevice(token);

    return null;
  }

  Future<DeviceRequest> _getIOSDevice(String token) async {
    final iosInfo = await DeviceInfoPlugin().iosInfo;

    return DeviceRequest()
      ..deviceId = iosInfo.identifierForVendor
      ..deviceName = iosInfo.name
      ..platform = 'i'
      ..platformVersion = iosInfo.systemVersion
      ..model = iosInfo.model
      ..registrationToken = token;
  }

  Future<DeviceRequest> _getAndroidDevice(String token) async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    final deviceId = await FlutterUdid.udid;

    return DeviceRequest()
      ..deviceId = deviceId
      ..deviceName = deviceInfo.device
      ..platform = 'a'
      ..platformVersion = 'Android ${deviceInfo.version.release} (API ${deviceInfo.version.sdkInt})'
      ..model = deviceInfo.model
      ..registrationToken = token;
  }
}
