import 'package:flutter/foundation.dart';

import 'caption_manager_platform_interface.dart';
import 'caption_manager_api.g.dart';
import 'models/caption_style.dart';

class MethodChannelCaptionManager extends CaptionManagerPlatform {
  @visibleForTesting
  final api = CaptionManagerApi();

  @visibleForTesting
  late final Stream<CaptionManagerEvent> captionChangedStream =
      onCaptionChanged();

  @override
  Future<CaptionStyle?> getUserStyle() async {
    final native = await api.getUserStyle();
    if (native == null) return null;
    return CaptionStyle.fromNative(native);
  }

  @override
  Future<bool?> isEnabled() {
    return api.isEnabled();
  }

  @override
  Future<bool?> isCallCaptioningEnabled() {
    return api.isCallCaptioningEnabled();
  }

  @override
  Future<bool?> isSystemAudioCaptioningEnabled() {
    return api.isSystemAudioCaptioningEnabled();
  }

  @override
  Future<bool?> isSystemAudioCaptioningUiEnabled() {
    return api.isSystemAudioCaptioningUiEnabled();
  }

  @override
  Future<double?> getFontScale() {
    return api.getFontScale();
  }

  @override
  Future<String?> getLocale() {
    return api.getLocale();
  }

  @override
  Future<void> openCaptionSetting() {
    return api.openCaptionSetting();
  }

  @override
  Stream<CaptionManagerEvent> get captionChanges => captionChangedStream;

  @override
  Stream<bool?> get enabledChanges =>
      captionChangedStream.map((e) => e.isEnabled).distinct();

  @override
  Stream<bool?> get systemAudioCaptioningEnabledChanges => captionChangedStream
      .map((e) => e.isSystemAudioCaptioningEnabled)
      .distinct();

  @override
  Stream<bool?> get systemAudioCaptioningUiEnabledChanges =>
      captionChangedStream
          .map((e) => e.isSystemAudioCaptioningUiEnabled)
          .distinct();

  @override
  Stream<double?> get fontScaleChanges =>
      captionChangedStream.map((e) => e.fontScale).distinct();

  @override
  Stream<String?> get localeChanges =>
      captionChangedStream.map((e) => e.locale).distinct();

  @override
  Stream<CaptionStyle?> get userStyleChanges => captionChangedStream
      .map(
        (e) =>
            e.userStyle != null ? CaptionStyle.fromNative(e.userStyle!) : null,
      )
      .distinct();
}
