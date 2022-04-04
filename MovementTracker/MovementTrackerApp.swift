//
//  MovementTrackerApp.swift
//  MovementTracker
//
//  Created by Beau Nouvelle on 7/3/2022.
//

import SwiftUI

@main
struct MovementTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = true
                }
        }
    }
}
