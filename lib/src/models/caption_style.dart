import 'dart:ui';

import '../caption_manager_api.g.dart';

class CaptionStyle {
  /// The color of the caption text.
  final Color? foregroundColor;

  /// The color of the background directly behind the text.
  final Color? backgroundColor;

  /// The color used for the text edge effect.
  final Color? edgeColor;

  /// The type of edge effect (e.g., outline, drop shadow).
  final EdgeType? edgeType;

  /// The color of the window surrounding the captions.
  final Color? windowColor;

  /// Information about the font used for captions.
  final Typeface? typeface;

  const CaptionStyle({
    this.foregroundColor,
    this.backgroundColor,
    this.edgeColor,
    this.edgeType,
    this.windowColor,
    this.typeface,
  });

  factory CaptionStyle.fromNative(NativeCaptionStyle native) {
    return CaptionStyle(
      foregroundColor: native.foregroundColor != null
          ? Color(native.foregroundColor!)
          : null,
      backgroundColor: native.backgroundColor != null
          ? Color(native.backgroundColor!)
          : null,
      edgeColor: native.edgeColor != null ? Color(native.edgeColor!) : null,
      edgeType: native.edgeType,
      windowColor: native.windowColor != null
          ? Color(native.windowColor!)
          : null,
      typeface: native.typeface,
    );
  }
}
