# caption_manager

A Flutter plugin for accessing Android system-wide captioning settings. This allows your app's media player to respect user preferences for subtitles, including colors, font scaling, and edge effects.

> This plugin is currently **Android-only**. It leverages the `android.view.accessibility.CaptioningManager` API to retrieve system-level subtitle preferences.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  caption_manager: ^1.0.0
```

## Usage

```dart
import 'package:caption_manager/caption_manager.dart';

final _captionManager = CaptionManager();

void fetchSettings() async {
  // Check if captioning is enabled
  bool isEnabled = await _captionManager.isEnabled() ?? false;

  // Get the user's preferred font scale (e.g., 1.0, 1.5)
  double fontScale = await _captionManager.getFontScale() ?? 1.0;

  // Get the preferred locale tag
  String? locale = await _captionManager.getLocale(); // Returns "en-US", etc.

  // Get the full visual style
  CaptionStyle? style = await _captionManager.getUserStyle();

  if (style != null) {
    print('Foreground Color: ${style.foregroundColor}');
    print('Edge Type: ${style.edgeType}');
  }
}

void openSettings() async {
    // Open system caption settings.
    // Wait until the user returns from the settings screen.
    await _captionManager.openCaptionSetting();

    print("Returned from settings");
}
```
