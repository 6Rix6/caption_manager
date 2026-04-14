import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/caption_manager_api.g.dart',
    kotlinOptions: KotlinOptions(),
    kotlinOut:
        'android/src/main/kotlin/com/example/caption_manager/CaptionManagerApi.kt',
  ),
)
/// Styles for the typeface used in captions.
enum TypefaceStyle { normal, bold, italic, boldItalic }

/// Represents typeface details including weight and family name.
class Typeface {
  /// The style of the typeface (normal, bold, etc.).
  final TypefaceStyle? style;

  /// The numerical weight of the typeface (e.g., 400, 700).
  final int? weight;

  /// Whether the typeface is bold.
  final bool? isBold;

  /// Whether the typeface is italic.
  final bool? isItalic;

  /// The name of the system font family.
  final String? systemFontFamilyName;

  const Typeface({
    this.style,
    this.weight,
    this.isBold,
    this.isItalic,
    this.systemFontFamilyName,
  });
}

/// The type of edge effect for caption text.
enum EdgeType {
  /// Edge type is not specified.
  unspecified,

  /// No edge effect.
  none,

  /// Outline edge effect.
  outline,

  /// Drop shadow edge effect.
  dropShadow,

  /// Raised edge effect.
  raised,

  /// Depressed edge effect.
  depressed,
}

class NativeCaptionStyle {
  final int? foregroundColor;
  final int? backgroundColor;
  final int? edgeColor;
  final EdgeType? edgeType;
  final int? windowColor;
  final Typeface? typeface;

  const NativeCaptionStyle({
    this.foregroundColor,
    this.backgroundColor,
    this.edgeColor,
    this.edgeType,
    this.windowColor,
    this.typeface,
  });
}

@HostApi()
abstract class CaptionManagerApi {
  bool? isEnabled();

  bool? isCallCaptioningEnabled();

  bool? isSystemAudioCaptioningEnabled();

  bool? isSystemAudioCaptioningUiEnabled();

  double? getFontScale();

  String? getLocale();

  NativeCaptionStyle? getUserStyle();
}
