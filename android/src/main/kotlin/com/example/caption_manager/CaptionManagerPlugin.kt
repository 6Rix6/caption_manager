package com.example.caption_manager

import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener

/** CaptionManagerPlugin */
class CaptionManagerPlugin : FlutterPlugin, ActivityAware, ActivityResultListener {
    private var activityBinding: ActivityPluginBinding? = null

    private val resultListeners =
        mutableListOf<(requestCode: Int, resultCode: Int, data: Intent?) -> Boolean>()

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        CaptionManagerApi.setUp(
            binding.binaryMessenger,
            CaptionManagerApiImpl(
                context = binding.applicationContext,
                activityProvider = { activityBinding?.activity },
                addActivityResultListener = { resultListeners.add(it) }
            )
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        CaptionManagerApi.setUp(binding.binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addActivityResultListener(this)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        val iterator = resultListeners.iterator()
        while (iterator.hasNext()) {
            val consumed = iterator.next().invoke(requestCode, resultCode, data)
            if (consumed) iterator.remove()
        }
        return false
    }
}