//
//  DeviceActivityMonitorExtension.swift
//  AppLockerDeviceActivityMonitor
//
//  Created by 오킹 on 2024/04/04.
//

import UserNotifications
import DeviceActivity
import FamilyControls
import ManagedSettings

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    let sharedStorage = UserDefaults(suiteName: "test_my_storage")!
    let store = ManagedSettingsStore()
    
    func getSelection() -> FamilyActivitySelection {
        let documentsDirectory = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.HongzCloud.AppLocker")
        
        guard let archiveURL = documentsDirectory?.appendingPathComponent("selection.plist") else {
            print("FamilyActivitySelection 가져오기 실패: selection.plist 없음")
            return FamilyActivitySelection()
        }
        
        guard let codeData = try? Data(contentsOf: archiveURL) else {
            print("FamilyActivitySelection 가져오기 실패: dodeData 없음")
           
            return FamilyActivitySelection()
        }
        
        print("FamilyActivitySelection 가져오기 성공")
        
        let decoder = PropertyListDecoder()
        let loadedSelection = (try! decoder.decode(FamilyActivitySelection.self, from: codeData))
        print("loadedSelection: \(loadedSelection.applicationTokens)")
        
        return loadedSelection
    }
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        // Handle the start of the interval.

        let selection = getSelection()
        
        let applications = selection
            store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
            store.shield.applicationCategories = applications.categoryTokens.isEmpty
            ? nil
            : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
        showLocalNotification(title: "intervalDidStart", desc: "\(applications.applicationTokens)")
        
        
        
        
        
        
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
        showLocalNotification(title: "intervalDidEnd", desc: "intervalDidEnd")
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
        showLocalNotification(title: "eventDidReachThreshold", desc: "eventDidReachThreshold")
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
        showLocalNotification(title: "intervalWillStartWarning", desc: "intervalWillStartWarning")
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
        showLocalNotification(title: "intervalWillEndWarning", desc: "intervalWillEndWarning")
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
        showLocalNotification(title: "eventWillReachThresholdWarning", desc: "eventWillReachThresholdWarning")
    }
    
    func showLocalNotification(title: String, desc: String) {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = desc
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
              if let error = error {
                  print("로컬 푸시 실패: \(error.localizedDescription)")
              } else {
                  print("로컬 푸시 성공")
              }
            }
      }

}

