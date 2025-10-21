import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceIdHelper {
  static Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceId = 'unknown';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'unknown';
      }
    } catch (e) {
      deviceId = 'unknown';
    }

    return deviceId;
  }
}
