import UIKit
import Flutter
import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let motionManager = CMMotionManager()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController

    // ✅ MethodChannel for device info
    let deviceChannel = FlutterMethodChannel(name: "device_channel", binaryMessenger: controller.binaryMessenger)
    deviceChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
        case "getBatteryLevel":
          UIDevice.current.isBatteryMonitoringEnabled = true
          let level = Int(UIDevice.current.batteryLevel * 100)
          result(level)
        case "getDeviceName":
          result(UIDevice.current.name)
        case "getOSVersion":
          result(UIDevice.current.systemVersion)
        default:
          result(FlutterMethodNotImplemented)
      }
    }

    // ✅ EventChannel for gyroscope
    let gyroChannel = FlutterEventChannel(name: "sensor_channel/gyroscope", binaryMessenger: controller.binaryMessenger)
    gyroChannel.setStreamHandler(GyroscopeStreamHandler(motionManager: motionManager))

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
class GyroscopeStreamHandler: NSObject, FlutterStreamHandler {
  private let motionManager: CMMotionManager

  init(motionManager: CMMotionManager) {
    self.motionManager = motionManager
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    if motionManager.isGyroAvailable {
      motionManager.gyroUpdateInterval = 0.1
      motionManager.startGyroUpdates(to: .main) { (data, error) in
        if let gyro = data {
          let values: [String: Double] = [
            "x": gyro.rotationRate.x,
            "y": gyro.rotationRate.y,
            "z": gyro.rotationRate.z
          ]
          events(values)
        }
      }
    } else {
      return FlutterError(code: "UNAVAILABLE", message: "Gyroscope not available", details: nil)
    }
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    motionManager.stopGyroUpdates()
    return nil
  }
}
