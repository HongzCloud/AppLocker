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
    }
}
