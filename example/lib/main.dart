import 'package:flutter/material.dart';
import 'package:caption_manager/caption_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _captionManager = CaptionManager();

  bool _isEnabled = false;
  double _fontScale = 1.0;
  CaptionStyle? _style;
  String _locale = 'Unknown';

  @override
  void initState() {
    super.initState();
    _loadCaptionSettings();
  }

  /// Fetch settings from the native side
  Future<void> _loadCaptionSettings() async {
    final enabled = await _captionManager.isEnabled() ?? false;
    final scale = await _captionManager.getFontScale() ?? 1.0;
    final style = await _captionManager.getUserStyle();
    final locale = await _captionManager.getLocale() ?? 'en-US';

    if (!mounted) return;

    setState(() {
      _isEnabled = enabled;
      _fontScale = scale;
      _style = style;
      _locale = locale;
    });
  }

  void _openCaptionSetting() async {
    await _captionManager.openCaptionSetting();
    print("Returned from settings");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Caption Manager Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoTile('Enabled', _isEnabled.toString()),
              _buildInfoTile('Font Scale', _fontScale.toStringAsFixed(2)),
              _buildInfoTile('Locale', _locale),
              const SizedBox(height: 32),
              const Text(
                '--- Preview ---',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildCaptionPreview(),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _openCaptionSetting,
                      child: const Text('Open Caption Settings'),
                    ),
                    ElevatedButton(
                      onPressed: _loadCaptionSettings,
                      child: const Text('Refresh Settings'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text('$label: $value'),
    );
  }

  /// A preview widget that mimics how captions look with current system settings
  Widget _buildCaptionPreview() {
    if (_style == null) return const Text('No style data available');

    return Container(
      padding: const EdgeInsets.all(8.0),
      color: _style?.windowColor ?? Colors.transparent, // Caption Window
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: _style?.backgroundColor ?? Colors.black54, // Text Background
        child: Text(
          'This is a caption preview text.',
          style: TextStyle(
            color: _style?.foregroundColor ?? Colors.white,
            fontSize: 18 * _fontScale,
            // Simple mapping for demonstration
            fontWeight: _style?.typeface?.isBold == true
                ? FontWeight.bold
                : FontWeight.normal,
            fontStyle: _style?.typeface?.isItalic == true
                ? FontStyle.italic
                : FontStyle.normal,
            fontFamily: _style?.typeface?.systemFontFamilyName,
            shadows: _buildEdgeEffect(_style?.edgeType, _style?.edgeColor),
          ),
        ),
      ),
    );
  }

  List<Shadow>? _buildEdgeEffect(EdgeType? type, Color? color) {
    if (type == null || type == EdgeType.none || color == null) return null;

    switch (type) {
      case EdgeType.outline:
        return [
          Shadow(offset: const Offset(-1, -1), color: color),
          Shadow(offset: const Offset(1, -1), color: color),
          Shadow(offset: const Offset(-1, 1), color: color),
          Shadow(offset: const Offset(1, 1), color: color),
        ];
      case EdgeType.dropShadow:
        return [
          Shadow(offset: const Offset(2, 2), color: color, blurRadius: 2),
        ];
      default:
        return null;
    }
  }
}
