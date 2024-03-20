//
//  Test.swift
//  Test
//
//  Created by 오킹 on 2024/01/07.
//

import DeviceActivity
import SwiftUI

@main
struct Test: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            TotalActivityView(totalActivity: totalActivity)
        }
        // Add more reports here...
    }
}
