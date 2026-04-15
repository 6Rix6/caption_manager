package com.example.caption_manager

import CaptionManagerApi
import CaptionManagerEvent
import NativeCaptionStyle
import OnCaptionChangedStreamHandler
import PigeonEventSink
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Looper
import android.provider.Settings
import android.view.accessibility.CaptioningManager
import androidx.core.os.HandlerCompat
import java.util.Locale

private const val REQUEST_CODE_CAPTIONING = 10001

class CaptionManagerApiImpl(
    context: Context,
    private val onCaptionChangedImpl: OnCaptionChangedImpl,
    private val activityProvider: () -> Activity?,
    private val addActivityResultListener: (callback: (requestCode: Int, resultCode: Int, data: Intent?) -> Boolean) -> Unit,
) : CaptionManagerApi {
    private val manager: CaptioningManager? =
        context.getSystemService(Context.CAPTIONING_SERVICE) as CaptioningManager?

    init {
        manager?.addCaptioningChangeListener(onCaptionChangedImpl.captioningChangeListener)
        refreshCaptionInfo()
    }

    fun dispose() {
        manager?.removeCaptioningChangeListener(
            onCaptionChangedImpl.captioningChangeListener
        )
    }

    fun refreshCaptionInfo() {
        onCaptionChangedImpl.sendEvent(CaptionManagerEvent(
            isEnabled = isEnabled(),
            isSystemAudioCaptioningEnabled = isSystemAudioCaptioningEnabled(),
            isSystemAudioCaptioningUiEnabled = isSystemAudioCaptioningUiEnabled(),
            fontScale = getFontScale(),
            locale = getLocale(),
            userStyle = getUserStyle()
        ))
    }

    override fun getUserStyle(): NativeCaptionStyle? {
        if (manager == null) return null

        return manager.userStyle.toNativeUserStyle()
    }

    override fun isEnabled(): Boolean? {
        if (manager == null) return null
        return manager.isEnabled
    }

    override fun isCallCaptioningEnabled(): Boolean? {
        if (manager == null || Build.VERSION.SDK_INT < 33) return null
        return manager.isCallCaptioningEnabled
    }

    override fun isSystemAudioCaptioningEnabled(): Boolean? {
        if (manager == null || Build.VERSION.SDK_INT < 33) return null
        return manager.isSystemAudioCaptioningEnabled
    }

    override fun isSystemAudioCaptioningUiEnabled(): Boolean? {
        if (manager == null || Build.VERSION.SDK_INT < 33) return null
        return manager.isSystemAudioCaptioningUiEnabled
    }

    override fun getFontScale(): Double? {
        if (manager == null) return null
        return manager.fontScale.toDouble()
    }

    override fun getLocale(): String? {
        if (manager == null) return null
        return manager.locale?.toLanguageTag()
    }

    override fun openCaptionSetting(callback: (Result<Unit>) -> Unit) {
        val activity = activityProvider() ?: run {
            callback(Result.failure(Exception("Activity is not available")))
            return
        }

        addActivityResultListener { requestCode, _, _ ->
            if (requestCode == REQUEST_CODE_CAPTIONING) {
                refreshCaptionInfo()

                callback(Result.success(Unit))
                true
            } else {
                false
            }
        }

        val intent = Intent(Settings.ACTION_CAPTIONING_SETTINGS)
        activity.startActivityForResult(intent, REQUEST_CODE_CAPTIONING)
    }
}

class OnCaptionChangedImpl: OnCaptionChangedStreamHandler() {
    private var captionManagerEvent: CaptionManagerEvent = CaptionManagerEvent()
    private val mainHandler = HandlerCompat.createAsync(Looper.getMainLooper())

    val captioningChangeListener = object : CaptioningManager.CaptioningChangeListener() {
        override fun onEnabledChanged(enabled: Boolean) {
            sendEvent(captionManagerEvent.copy(isEnabled = enabled))
        }

        override fun onSystemAudioCaptioningChanged(enabled: Boolean) {
            sendEvent(captionManagerEvent.copy(isSystemAudioCaptioningEnabled = enabled))
        }

        override fun onSystemAudioCaptioningUiChanged(enabled: Boolean) {
            sendEvent(captionManagerEvent.copy(isSystemAudioCaptioningUiEnabled = enabled))
        }

        override fun onFontScaleChanged(fontScale: Float) {
            sendEvent(captionManagerEvent.copy(fontScale = fontScale.toDouble()))
        }

        override fun onLocaleChanged(locale: Locale?) {
            sendEvent(captionManagerEvent.copy(locale = locale?.toLanguageTag()))
        }

        override fun onUserStyleChanged(userStyle: CaptioningManager.CaptionStyle) {
            sendEvent(captionManagerEvent.copy(userStyle = userStyle.toNativeUserStyle()))
        }
    }

    private var eventSink: PigeonEventSink<CaptionManagerEvent>? = null

    fun sendEvent(value: CaptionManagerEvent) {
        mainHandler.post {
            captionManagerEvent = value
            eventSink?.success(value)
        }
    }

    override fun onListen(p0: Any?, sink: PigeonEventSink<CaptionManagerEvent>) {
        eventSink = sink
        sendEvent(captionManagerEvent)
    }

    override fun onCancel(p0: Any?) {
        eventSink = null
    }
}