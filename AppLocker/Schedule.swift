//
//  Schedule.swift
//  AppLocker
//
//  Created by 오킹 on 2024/04/05.
//

import Foundation
import DeviceActivity

extension DeviceActivityName {
    static let daily = Self("daily")
}

extension DeviceActivityEvent.Name {
    static let encouraged = Self("encouraged")
}

let schedule = DeviceActivitySchedule(
    intervalStart: DateComponents(hour: 00, minute: 40),
    intervalEnd: DateComponents(hour: 01, minute: 20),
    repeats: true
)

class Schedule {
    
    var center = DeviceActivityCenter()
    
    public func setSchedule() {
        
        print("스케쥴 셋팅 시작...")
        print("현재 시간과 분: ", Calendar.current.dateComponents([.hour, .minute], from: Date()))

        do {
            print("스케줄 모니터링 시작...")
            try center.startMonitoring(.daily, during: schedule)
        } catch {
            print("스케쥴 모니터링 실패: ", error)
        }
    }
}
