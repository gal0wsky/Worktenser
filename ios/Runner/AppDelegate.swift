import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
      let METHOD_CHANNEL_NAME = "dev.gawlowski.worktenser/notifications"
      let notificationChannel = FlutterMethodChannel(
        name: METHOD_CHANNEL_NAME,
        binaryMessenger: controller.binaryMessenger)
      
      notificationChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
          case "localNotification":
              guard let args = call.arguments as? [String: String] else {return}
              let title = args["title"]!
              let body = args["body"]!
              
              let identifier = "worktenser-active-project-notification"
              
              let notificationCenter = UNUserNotificationCenter.current()
              
              let content = UNMutableNotificationContent()
              content.title = title
              content.body = body
              content.sound = .none
              
              let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
              
              let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
              
              notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
              notificationCenter.add(request)
              
              result(true)
              
          default:
              result(FlutterMethodNotImplemented)
          }
      })
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
//    private func displayForegroundNotification(title: String, body: String) {
//        let identifier = "worktenser-active-project-notification"
//
//        let notificationCenter = UNUserNotificationCenter.current()
//
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .none
//
//        let trigger = UNNotificationTrigger()
//
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
//        notificationCenter.add(request)
//    }
}
