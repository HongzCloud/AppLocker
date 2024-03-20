//
//  AppLockerApp.swift
//  AppLocker
//
//  Created by 오킹 on 2024/01/06.
//

import SwiftUI
import FamilyControls
import DeviceActivity

@main
struct AppLockerApp: App {
    
    let center = AuthorizationCenter.shared
//    @State private var context: DeviceActivityReport.Context =
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

