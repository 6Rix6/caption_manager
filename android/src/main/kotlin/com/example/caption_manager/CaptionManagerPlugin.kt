package com.example.caption_manager

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** CaptionManagerPlugin */
class CaptionManagerPlugin :
    FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        CaptionManagerApi.setUp(binding.binaryMessenger, CaptionManagerApiImpl(binding.applicationContext))
    }
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        CaptionManagerApi.setUp(binding.binaryMessenger, null)
    }
}
