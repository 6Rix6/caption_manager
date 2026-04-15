package com.example.caption_manager

import CaptionManagerApi
import NativeCaptionStyle
import Typeface
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import android.view.accessibility.CaptioningManager
import android.graphics.Typeface as AndroidTypeface

private const val REQUEST_CODE_CAPTIONING = 10001

class CaptionManagerApiImpl(
    context: Context,
    private val activityProvider: () -> Activity?,
    private val addActivityResultListener: (callback: (requestCode: Int, resultCode: Int, data: Intent?) -> Boolean) -> Unit
) : CaptionManagerApi {
    private val manager: CaptioningManager? =
        context.getSystemService(Context.CAPTIONING_SERVICE) as CaptioningManager?

    override fun getUserStyle(): NativeCaptionStyle? {
        if (manager == null) return null
        val style = manager.userStyle
        return NativeCaptionStyle(
            foregroundColor = style.foregroundColor.toLong(),
            backgroundColor = style.backgroundColor.toLong(),
            edgeColor = style.edgeColor.toLong(),
            edgeType = style.edgeType.toEdgeType(),
            windowColor = style.windowColor.toLong(),
            typeface = style.typeface?.toTypeFace()
        )
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
                callback(Result.success(Unit))
                true
            } else {
                false
            }
        }

        val intent = Intent(Settings.ACTION_CAPTIONING_SETTINGS)
        @Suppress("DEPRECATION")
        activity.startActivityForResult(intent, REQUEST_CODE_CAPTIONING)
    }
}

fun Int.toEdgeType() = when (this) {
    CaptioningManager.CaptionStyle.EDGE_TYPE_NONE -> EdgeType.NONE
    CaptioningManager.CaptionStyle.EDGE_TYPE_OUTLINE -> EdgeType.OUTLINE
    CaptioningManager.CaptionStyle.EDGE_TYPE_DROP_SHADOW -> EdgeType.DROP_SHADOW
    CaptioningManager.CaptionStyle.EDGE_TYPE_RAISED -> EdgeType.RAISED
    CaptioningManager.CaptionStyle.EDGE_TYPE_DEPRESSED -> EdgeType.DEPRESSED
    else -> EdgeType.UNSPECIFIED
}

fun Int.toTypefaceStyle() = when(this){
    AndroidTypeface.BOLD -> TypefaceStyle.BOLD
    AndroidTypeface.BOLD_ITALIC -> TypefaceStyle.BOLD_ITALIC
    AndroidTypeface.ITALIC -> TypefaceStyle.ITALIC
    AndroidTypeface.NORMAL -> TypefaceStyle.NORMAL
    else -> TypefaceStyle.NORMAL
}

fun AndroidTypeface.toTypeFace(): Typeface {

    val weight = if(Build.VERSION.SDK_INT >= 28)  this.weight.toLong() else null
    val systemFontFamilyName = if(Build.VERSION.SDK_INT >= 34) this.systemFontFamilyName else null

    return Typeface(
        style = this.style.toTypefaceStyle(),
        weight = weight,
        isBold = this.isBold,
        isItalic = this.isItalic,
        systemFontFamilyName = systemFontFamilyName
    )
}

