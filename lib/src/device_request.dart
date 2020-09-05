class DeviceRequest {
  DeviceRequest();

  String deviceId;
  String deviceName;
  String model;
  String platform;
  String platformVersion;
  String registrationToken;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'device_id': deviceId,
        'device_name': deviceName,
        'model': model,
        'platform': platform,
        'platform_version': platformVersion,
        'registration_token': registrationToken,
      };
}
