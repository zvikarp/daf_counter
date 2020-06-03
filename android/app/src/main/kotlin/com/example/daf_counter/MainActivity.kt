package com.zektec.daf_plus_plus

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import android.os.Bundle
import android.content.ContentResolver
import android.content.Context

class MainActivity : FlutterActivity() {
    override protected fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
//        MethodChannel(getFlutterView(), "crossingthestreams.io/resourceResolver").setMethodCallHandler(
//                object : MethodCallHandler() {
//                    fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
//                        if ("drawableToUri" == call.method) {
//                            val resourceId: Int = this@MainActivity.getResources().getIdentifier(call.arguments as String, "drawable", this@MainActivity.getPackageName())
//                            val uriString = resourceToUriString(this@MainActivity.getApplicationContext(), resourceId)
//                            result.success(uriString)
//                        }
//                    }
//                })
    }

    companion object {
        private fun resourceToUriString(context: Context, resId: Int): String {
            return (ContentResolver.SCHEME_ANDROID_RESOURCE
                    + "://"
                    + context.getResources().getResourcePackageName(resId)
                    + "/"
                    + context.getResources().getResourceTypeName(resId)
                    + "/"
                    + context.getResources().getResourceEntryName(resId))
        }
    }
}
