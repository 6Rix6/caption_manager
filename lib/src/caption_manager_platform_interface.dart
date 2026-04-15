import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'caption_manager_method_channel.dart';
import 'models/caption_style.dart';

abstract class CaptionManagerPlatform extends PlatformInterface {
  /// Constructs a CaptionManagerPlatform.
  CaptionManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static CaptionManagerPlatform _instance = MethodChannelCaptionManager();

  /// The default instance of [CaptionManagerPlatform] to use.
  ///
  /// Defaults to [MethodChannelCaptionManager].
  static CaptionManagerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CaptionManagerPlatform] when
  /// they register themselves.
  static set instance(CaptionManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<CaptionStyle?> getUserStyle() {
    throw UnimplementedError('getUserStyle() has not been implemented.');
  }

  Future<bool?> isEnabled() {
    throw UnimplementedError('isEnabled() has not been implemented.');
  }

  Future<bool?> isCallCaptioningEnabled() {
    throw UnimplementedError(
      'isCallCaptioningEnabled() has not been implemented.',
    );
  }

  Future<bool?> isSystemAudioCaptioningEnabled() {
    throw UnimplementedError(
      'isSystemAudioCaptioningEnabled() has not been implemented.',
    );
  }

  Future<bool?> isSystemAudioCaptioningUiEnabled() {
    throw UnimplementedError(
      'isSystemAudioCaptioningUiEnabled() has not been implemented.',
    );
  }

  Future<double?> getFontScale() {
    throw UnimplementedError('getFontScale() has not been implemented.');
  }

  Future<String?> getLocale() {
    throw UnimplementedError('getLocale() has not been implemented.');
  }

  Future<void> openCaptionSetting() {
    throw UnimplementedError('openCaptionSetting() has not been implemented.');
  }
}
