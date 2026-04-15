import 'caption_manager_platform_interface.dart';
import 'models/caption_style.dart';

class CaptionManager {
  /// Returns whether system captioning is enabled.
  Future<bool?> isEnabled() {
    return CaptionManagerPlatform.instance.isEnabled();
  }

  /// Returns whether call captioning is enabled.
  Future<bool?> isCallCaptioningEnabled() {
    return CaptionManagerPlatform.instance.isCallCaptioningEnabled();
  }

  /// Returns whether system audio captioning (Live Caption) is enabled.
  Future<bool?> isSystemAudioCaptioningEnabled() {
    return CaptionManagerPlatform.instance.isSystemAudioCaptioningEnabled();
  }

  /// Returns whether the UI for system audio captioning is enabled.
  Future<bool?> isSystemAudioCaptioningUiEnabled() {
    return CaptionManagerPlatform.instance.isSystemAudioCaptioningUiEnabled();
  }

  /// Returns the user's preferred font scale for captions.
  Future<double?> getFontScale() {
    return CaptionManagerPlatform.instance.getFontScale();
  }

  /// Returns the current locale tag (e.g., "en-US", "ja-JP").
  Future<String?> getLocale() {
    return CaptionManagerPlatform.instance.getLocale();
  }

  /// Returns the user's preferred caption appearance settings.
  Future<CaptionStyle?> getUserStyle() {
    return CaptionManagerPlatform.instance.getUserStyle();
  }

  /// Opens system caption settings screen
  Future<void> openCaptionSetting() {
    return CaptionManagerPlatform.instance.openCaptionSetting();
  }
}
