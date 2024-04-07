//
//  Model.swift
//  AppLocker
//
//  Created by 오킹 on 2024/03/27.
//

import Foundation
import FamilyControls
import ManagedSettings

class Model: ObservableObject {
    
    static var shared = Model()
    
    let store = ManagedSettingsStore()
    @Published var selectionToDiscourage: FamilyActivitySelection
    
    init() {
        selectionToDiscourage = FamilyActivitySelection()

    }
    
    func setShieldRestrictions() {
        let applications = Model.shared.selectionToDiscourage
        
        store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
        store.shield.applicationCategories = applications.categoryTokens.isEmpty
        ? nil
        : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
        
        saveSelection()
    }
    
    
    func saveSelection() {
        let documentsDirectory = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.HongzCloud.AppLocker")

        let archiveURL = documentsDirectory?.appendingPathComponent("selection.plist")

        let encoder = PropertyListEncoder()

        if let dataToSave = try? encoder.encode(selectionToDiscourage) {
            do {
                try dataToSave.write(to: archiveURL!)
                print("저장 성공")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getSelection() -> FamilyActivitySelection {
        let documentsDirectory = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.HongzCloud.AppLocker")
        
        guard let archiveURL = documentsDirectory?.appendingPathComponent("selection.plist") else {
            print("가져오기 실패: selection.plist 없음")
            return FamilyActivitySelection()
        }
        
        guard let codeData = try? Data(contentsOf: archiveURL) else {
            print("가져오기 실패: dodeData 없음")
           
            return FamilyActivitySelection()
        }
        
        print("가져오기 성공")
        let decoder = PropertyListDecoder()
        
        let loadedSelection = (try! decoder.decode(FamilyActivitySelection.self, from: codeData))
        print("loadedSelection: \(loadedSelection.applicationTokens)")
        
        return loadedSelection
    }
}
