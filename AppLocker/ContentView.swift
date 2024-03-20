//
//  ContentView.swift
//  AppLocker
//
//  Created by 오킹 on 2024/01/06.
//

import SwiftUI
import FamilyControls
import DeviceActivity

struct ContentView: View {
    
    var monitor = MyMonitor()
    let deviceCenter = DeviceActivityCenter()
    let center = AuthorizationCenter.shared
    @State var isPresented = false
    @ObservedObject var model = MyModel()
    @State private var context: DeviceActivityReport.Context = .init(rawValue: "Total Activity")
    @State private var filter = DeviceActivityFilter(
        segment: .daily(
            during: Calendar.current.dateInterval(
               of: .day, for: .now
            )!
        ),
        users: .all,
        devices: .init([.iPhone, .iPad])
    )
    let schedule = DeviceActivitySchedule(
        intervalStart: DateComponents(
            hour: 0,
            minute: 0
        ),
        intervalEnd: DateComponents(
            hour: 23,
            minute: 59
        ),
        repeats: true
    )
    
    var body: some View {
        VStack {
                    // 2 will do next logic - add
                DeviceActivityReport(context, filter: filter)
            
            Button {
                isPresented = true
                monitor.model = self.model
                startMonitoer()

                monitor.intervalDidStart(for: .daily)

            } label: {
                Text("눌러")
            }

        } .onAppear {
            Task {
                do {
                    try await center.requestAuthorization(for: .individual)
                } catch {
                    print("Failed to enroll Aniyah with error: \(error)")
                }
            }
        }
        .familyActivityPicker(isPresented: $isPresented, selection: $model.selectionToDiscourage)
    }
    
    func requestAuthorization() {
        Task {
            do {
                try await center.requestAuthorization(for: .individual)
            } catch {
                print("Failed to enroll Aniyah with error: \(error)")
            }
        }
    }
    
    func startMonitoer() {

        do {
            deviceCenter.stopMonitoring()
            try deviceCenter.startMonitoring(.daily, during: schedule,
                                           events: [.encouraged : .init(applications: model.selectionToDiscourage.applicationTokens,
                                                                        threshold: DateComponents(minute: 15))])
        
                                                                            
        } catch {
            print("안됐어")
        }
    }
}

#Preview {
    ContentView()
}

import DeviceActivity
import ManagedSettings // 추가

//class MyMonitor: DeviceActivityMonitor {
//        let store = ManagedSettingsStore() // 추가
//
//        override func intervalDidStart(for activity: DeviceActivityName) {
//                super.intervalDidStart(for: activity)
//
//                //let model = MyModel() // 모델 인스턴스
//            let applications = FamilyActivitySelection().applications // 선택된 앱 List
//            
//            store.shield.applications = applications
//        }
//
//        override func intervalDidEnd(for activity: DeviceActivityName) {
//                super.intervalDidEnd(for: activity)
//
//                store.shield.applications = nil
//        }
//}

extension DeviceActivityName {
        static let daily = Self("daily")
}

extension DeviceActivityEvent.Name { // 이벤트 이름 등록
        static let encouraged = Self("encouraged")
}

class MyMonitor: DeviceActivityMonitor {
    let store = ManagedSettingsStore(named: .default) // 추가
        var model: MyModel? = nil
    
        override func intervalDidStart(for activity: DeviceActivityName) {
                super.intervalDidStart(for: activity)

                
            if let applications = model?.selectionToDiscourage {
                store.shield.applications = applications.applicationTokens // store 등록
            } // 선택된 앱 List

            
        }

        override func intervalDidEnd(for activity: DeviceActivityName) {
                super.intervalDidEnd(for: activity)

                store.shield.applications = nil
        }
}

class MyModel: ObservableObject {
    @Published var selectionToDiscourage: FamilyActivitySelection = .init()
}
