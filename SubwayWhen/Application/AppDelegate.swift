//
//  AppDelegate.swift
//  SubwayWhen
//
//  Created by 이윤수 on 2022/11/29.
//

import UIKit
import FirebaseCore
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var updateCount = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        // 네트워크 감지 class
        NetworkMonitor.shared.monitorStart()
        
        // LanchScreen 지연
        sleep(1)
        
        // 기존 LiveActivity 제거
        SubwayWhenDetailWidgetManager.shared.allLiveStop()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
        SubwayWhenDetailWidgetManager.shared.stop()
    }
}
