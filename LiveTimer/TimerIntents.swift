//
//  TimerIntents.swift
//  LiveTimer
//
//  Created by Enzo Henrique Botelho Romão on 17/10/25.
//

import Foundation
import AppIntents
import ActivityKit

struct PauseIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Pausar Timer"
    
    @MainActor
    func perform() async throws -> some IntentResult {
        print("PauseIntent Chamado!")
        if let _ = Activity<TimerAttributes>.activities.first {
            LiveActivityManager.shared.pauseActivity()
        }
        return .result()
    }
}

struct ResumeIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Resume Timer"
    
    @MainActor
    func perform() async throws -> some IntentResult {
        print("ResumeIntent Chamado!")
        if let _ = Activity<TimerAttributes>.activities.first {
            LiveActivityManager.shared.resumeActivity()
        }
        
        return .result()
    }
}

struct FinishIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Finish Timer"
    
    @MainActor
    func perform() async throws -> some IntentResult {
        print("FinishIntent Chamado!")
        if let _ = Activity<TimerAttributes>.activities.first {
            LiveActivityManager.shared.stopActivity()
        }
        
        return .result()
    }
}


