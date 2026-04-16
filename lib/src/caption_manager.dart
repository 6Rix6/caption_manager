import 'caption_manager_api.g.dart';
import 'caption_manager_platform_interface.dart';
import 'models/caption_style.dart';

class CaptionManager {
  factory CaptionManager() => _instance;
  CaptionManager._();

  static final CaptionManager _instance = CaptionManager._();

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

  /// Stream for receiving all caption manager events.
  Stream<CaptionManagerEvent> get captionChanges =>
      CaptionManagerPlatform.instance.captionChanges;

  /// Stream that emits whenever the system captioning enabled state changes.
  Stream<bool?> get enabledChanges =>
      CaptionManagerPlatform.instance.enabledChanges;

  /// Stream that emits whenever the system audio captioning (Live Caption) enabled state changes.
  Stream<bool?> get systemAudioCaptioningEnabledChanges =>
      CaptionManagerPlatform.instance.systemAudioCaptioningEnabledChanges;

  /// Stream that emits whenever the visibility of the system audio captioning UI changes.
  Stream<bool?> get systemAudioCaptioningUiEnabledChanges =>
      CaptionManagerPlatform.instance.systemAudioCaptioningUiEnabledChanges;

  /// Stream that emits whenever the user's preferred font scale changes.
  Stream<double?> get fontScaleChanges =>
      CaptionManagerPlatform.instance.fontScaleChanges;

  /// Stream that emits whenever the system caption locale changes.
  Stream<String?> get localeChanges =>
      CaptionManagerPlatform.instance.localeChanges;

  /// Stream that emits whenever the user's preferred caption appearance settings change.
  Stream<CaptionStyle?> get userStyleChanges =>
      CaptionManagerPlatform.instance.userStyleChanges;
}
