//
//  AppLockerApp.swift
//  AppLocker
//
//  Created by 오킹 on 2024/01/06.
//

import SwiftUI
import FamilyControls
import UserNotifications

@main
struct AppLockerApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @StateObject var model = Model.shared
    
    let center = AuthorizationCenter.shared
    let schedule = Schedule()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .onAppear {
                    schedule.setSchedule()
                    
                    Task {
                        do {
                            try await center.requestAuthorization(for: .individual)
                        } catch {
                            print("Failed to enroll Aniyah with error: \(error)")
                        }
                    }
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
            
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        
        return [.badge, .banner, .sound]
    }
}
