//
//  ContentView.swift
//  AppLocker
//
//  Created by 오킹 on 2024/01/06.
//

import SwiftUI
import FamilyControls

struct ContentView: View {
    
    @State var isPresented = false
    
    var body: some View {
        
        VStack {
            Button {
                isPresented = true
                
            } label: {
                Text("앱 목록 보기")
            }
            
        }
    }
}

#Preview {
    ContentView()
}
