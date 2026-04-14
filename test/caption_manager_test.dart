// import 'package:flutter_test/flutter_test.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// import 'package:caption_manager/caption_manager.dart';
// import 'package:caption_manager/src/caption_manager_platform_interface.dart';
// import 'package:caption_manager/src/caption_manager_method_channel.dart';

// class MockCaptionManagerPlatform
//     with MockPlatformInterfaceMixin
//     implements CaptionManagerPlatform {
//   @override
//   Future<CaptionStyle?> getUserStyle() => Future.value(CaptionStyle());
// }

// void main() {
//   final CaptionManagerPlatform initialPlatform =
//       CaptionManagerPlatform.instance;

//   test('$MethodChannelCaptionManager is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelCaptionManager>());
//   });

//   test('getCaptionStyle', () async {
//     CaptionManager captionManagerPlugin = CaptionManager();
//     MockCaptionManagerPlatform fakePlatform = MockCaptionManagerPlatform();
//     CaptionManagerPlatform.instance = fakePlatform;

//     final captionStyle = await captionManagerPlugin.getUserStyle();
//     expect(captionStyle, isNotNull);
//   });
// }
