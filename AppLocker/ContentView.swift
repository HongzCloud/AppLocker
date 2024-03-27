//
//  ContentView.swift
//  AppLocker
//
//  Created by 오킹 on 2024/01/06.
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct ContentView: View {
 
    @EnvironmentObject var model: Model
    
    @State var isPresented = false
    
    var body: some View {
        
        VStack {
            Button {
                isPresented = true
                
            } label: {
                Text("앱 목록 보기")
            }
            .familyActivityPicker(isPresented: $isPresented, selection: $model.selectionToDiscourage)
        }
        .onChange(of: model.selectionToDiscourage, {
            Model.shared.setShieldRestrictions()
        })
    }
}

#Preview {
    ContentView()
}
