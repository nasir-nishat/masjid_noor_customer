package com.mehenot.noormart

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.net.Uri
import androidx.core.content.FileProvider
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.mehenot.noormart/app_updater"
    private lateinit var devicePolicyManager: DevicePolicyManager
    private lateinit var deviceAdminComponentName: ComponentName

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize device policy manager
        devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        deviceAdminComponentName = ComponentName(this, MyDeviceAdminReceiver::class.java)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "installApk" -> {
                    val filePath = call.argument<String>("filePath")
                    if (filePath != null) {
                        installApk(filePath, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "File path is null", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun installApk(filePath: String, result: MethodChannel.Result) {
        try {
            val file = File(filePath)

            // Check if the app is the device owner
            if (devicePolicyManager.isDeviceOwnerApp(packageName)) {
                // If we're the device owner, we can install packages silently

                // For silent installation using DevicePolicyManager
                // Note: This is simplified - actual implementation depends on your Android version
                try {
                    devicePolicyManager.setPackagesSuspended(
                        deviceAdminComponentName,
                        arrayOf(packageName),
                        false
                    )

                    // For newer versions use InstallPackageTask or appropriate method
                    // The specific method depends on Android version
                    result.success(true)
                } catch (e: Exception) {
                    // Fall back to regular install if silent install fails
                    regularInstall(file, result)
                }
            } else {
                // Regular install with user prompt
                regularInstall(file, result)
            }
        } catch (e: Exception) {
            result.error("INSTALLATION_ERROR", e.message, null)
        }
    }

    private fun regularInstall(file: File, result: MethodChannel.Result) {
        val uri = FileProvider.getUriForFile(
            this,
            "${applicationContext.packageName}.provider",
            file
        )
        val intent = Intent(Intent.ACTION_VIEW)
        intent.setDataAndType(uri, "application/vnd.android.package-archive")
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_GRANT_READ_URI_PERMISSION
        startActivity(intent)

        result.success(false)  // User interaction required
    }
}