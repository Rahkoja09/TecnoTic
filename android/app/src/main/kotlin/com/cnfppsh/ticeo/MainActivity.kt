package com.cnfppsh.ticeo

import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.view.accessibility.AccessibilityManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "accessibility_service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "isTalkBackEnabled") {
                result.success(isTalkBackEnabled())
            } else if (call.method == "requestTalkBackActivation") {
                requestTalkBackActivation()
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun isTalkBackEnabled(): Boolean {
        val am = getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager
        val isEnabled = am.isEnabled
        val isTouchExplorationEnabled = am.isTouchExplorationEnabled
        return isEnabled && isTouchExplorationEnabled
    }

    private fun requestTalkBackActivation() {
        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        startActivity(intent)
    }
}
