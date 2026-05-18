package com.example.little_closet

import android.content.ActivityNotFoundException
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.little_closet/gallery")
            .setMethodCallHandler { call, result ->
                if (call.method == "openGallery") {
                    openGallery()
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun openGallery() {
        // 1. Standard-Intent mit CATEGORY_APP_GALLERY
        try {
            startActivity(Intent(Intent.ACTION_MAIN).apply {
                addCategory(Intent.CATEGORY_APP_GALLERY)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            })
            return
        } catch (e: ActivityNotFoundException) {}

        // 2. Bekannte Galerie-Apps per Paketname (benötigt <queries> im Manifest)
        val galleryPackages = listOf(
            "com.google.android.apps.photos",
            "com.sec.android.gallery3d",
            "com.miui.gallery",
            "com.coloros.gallery3d",
            "com.android.gallery3d",
        )
        for (pkg in galleryPackages) {
            packageManager.getLaunchIntentForPackage(pkg)?.let { intent ->
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
                return
            }
        }

        // 3. Sicherer Fallback: System-Chooser (wirft nie ActivityNotFoundException)
        startActivity(
            Intent.createChooser(
                Intent(Intent.ACTION_VIEW).apply { type = "image/*" },
                null,
            ).apply { addFlags(Intent.FLAG_ACTIVITY_NEW_TASK) }
        )
    }
}
