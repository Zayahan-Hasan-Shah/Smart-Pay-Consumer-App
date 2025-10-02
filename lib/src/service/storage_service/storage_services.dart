import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageServices {
  final _storage = const FlutterSecureStorage();

  get _androidOption => const AndroidOptions(
    encryptedSharedPreferences: true,
    keyCipherAlgorithm:
        KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
    storageCipherAlgorithm: StorageCipherAlgorithm.AES_CBC_PKCS7Padding,
  );

  get _iOptions => const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
    synchronizable: true,
    accountName: "SmartPayBU",
    groupId: "sP12",
  );

  String? value;

  Future<String?> read(key) async {
    value = await _storage.read(
      key: key,
      aOptions: _androidOption,
      iOptions: _iOptions,
    );

    if (value != null) {
      return value;
    }
    return null;
  }

  Future<bool> write(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      aOptions: _androidOption,
      iOptions: _iOptions,
    );
    return true;
  }

  Future<bool> delete(String key) async {
    await _storage.delete(
      key: key,
      aOptions: _androidOption,
      iOptions: _iOptions,
    );
    value = null;
    return true;
  }
}
