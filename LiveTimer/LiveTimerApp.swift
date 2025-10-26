//
//  LiveTimerApp.swift
//  LiveTimer
//
//  Created by Enzo Henrique Botelho Romão on 17/10/25.
//

import SwiftUI

@main
struct LiveTimerApp: App {
    var body: some Scene {
        WindowGroup {
            TimerView(viewModel: TimerViewModel())
        }
    }
}
