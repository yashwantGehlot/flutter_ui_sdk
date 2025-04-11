import 'package:finvu_flutter_sdk/common/utils/remote_config_service.dart';
import 'package:otp/otp.dart';

class TOTPGenerator {
  final remoteConfig = RemoteConfigService();

  String generateTOTP(String secret) {
    return OTP
        .generateTOTPCode(
          secret,
          DateTime.now().millisecondsSinceEpoch,
          length: 6,
          interval: remoteConfig.totpGenerationInterval,
          algorithm: Algorithm.SHA1,
          isGoogle: true,
        )
        .toString()
        .padLeft(6, '0');
  }
}
