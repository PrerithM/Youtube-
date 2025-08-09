package com.yourcompany.ytfilterkids

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback

class MainApplication : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
    }

    override fun registerWith(registry: PluginRegistry?) {
        // Register plugins if needed
    }
}