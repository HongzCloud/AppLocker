//
//  AppLockerApp.swift
//  AppLocker
//
//  Created by 오킹 on 2024/01/06.
//

import SwiftUI
import FamilyControls

@main
struct AppLockerApp: App {
    
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
