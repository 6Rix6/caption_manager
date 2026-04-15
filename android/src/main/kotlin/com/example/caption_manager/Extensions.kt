package com.example.caption_manager

import NativeCaptionStyle
import Typeface
import android.graphics.Typeface as AndroidTypeface
import android.os.Build
import android.view.accessibility.CaptioningManager


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

fun CaptioningManager.CaptionStyle.toNativeUserStyle() : NativeCaptionStyle {
    return NativeCaptionStyle(
        foregroundColor = foregroundColor.toLong(),
        backgroundColor = backgroundColor.toLong(),
        edgeColor = edgeColor.toLong(),
        edgeType = edgeType.toEdgeType(),
        windowColor = windowColor.toLong(),
        typeface = typeface?.toTypeFace()
    )
}

fun AndroidTypeface.toTypeFace(): Typeface {
    val weight = if(Build.VERSION.SDK_INT >= 28)  weight.toLong() else null
    val systemFontFamilyName = if(Build.VERSION.SDK_INT >= 34) systemFontFamilyName else null

    return Typeface(
        style = style.toTypefaceStyle(),
        weight = weight,
        isBold = isBold,
        isItalic = isItalic,
        systemFontFamilyName = systemFontFamilyName
    )
}

