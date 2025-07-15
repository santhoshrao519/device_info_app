
package com.example.device_sensor_app

import android.os.BatteryManager
import android.os.Build
import android.content.Context
import android.hardware.camera2.CameraManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    private val DEVICE_CHANNEL = "device_channel"
    private val SENSOR_CHANNEL = "sensor_channel"
    private val GYROSCOPE_CHANNEL = "sensor_channel/gyroscope"

    private var sensorManager: SensorManager? = null
    private var gyroscopeListener: SensorEventListener? = null
    private var isFlashOn: Boolean = false  // Internal state tracking

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Device Info
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVICE_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getBatteryLevel" -> {
                    val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
                    val batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
                    result.success(batteryLevel)
                }
                "getDeviceName" -> {
                    val deviceName = "${Build.MANUFACTURER} ${Build.MODEL}"
                    result.success(deviceName)
                }
                "getOSVersion" -> {
                    result.success(Build.VERSION.RELEASE)
                }
                else -> result.notImplemented()
            }
        }

        // Flashlight toggle + status
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SENSOR_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "toggleFlashlight" -> {
                    val turnOn = call.argument<Boolean>("turnOn") ?: false
                    try {
                        val cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
                        val cameraId = cameraManager.cameraIdList[0]
                        cameraManager.setTorchMode(cameraId, turnOn)
                        isFlashOn = turnOn
                        result.success(true)
                    } catch (e: Exception) {
                        Log.e("Flashlight", "Error toggling flashlight", e)
                        result.success(false)
                    }
                }

                "getFlashlightStatus" -> {
                    result.success(isFlashOn)  // Returns tracked state
                }

                "hasFlashlight" -> {
                    try {
                        val cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
                        val cameraId = cameraManager.cameraIdList[0]
                        val hasFlash = cameraManager.getCameraCharacteristics(cameraId)
                            .get(android.hardware.camera2.CameraCharacteristics.FLASH_INFO_AVAILABLE) == true
                        result.success(hasFlash)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }

                else -> result.notImplemented()
            }
        }

        // Gyroscope streaming
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, GYROSCOPE_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
                    val gyroscope = sensorManager?.getDefaultSensor(Sensor.TYPE_GYROSCOPE)

                    gyroscopeListener = object : SensorEventListener {
                        override fun onSensorChanged(event: SensorEvent) {
                            val data = mapOf(
                                "x" to event.values[0],
                                "y" to event.values[1],
                                "z" to event.values[2]
                            )
                            events?.success(data)
                        }

                        override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
                    }

                    sensorManager?.registerListener(
                        gyroscopeListener,
                        gyroscope,
                        SensorManager.SENSOR_DELAY_NORMAL
                    )
                }

                override fun onCancel(arguments: Any?) {
                    sensorManager?.unregisterListener(gyroscopeListener)
                    gyroscopeListener = null
                }
            }
        )
    }
}
