//
//  TimerViewModel.swift
//  LiveTimer
//
//  Created by Enzo Henrique Botelho Romão on 17/10/25.
//

import SwiftUI
import ActivityKit

@Observable
class TimerViewModel {
    
    var timer: Timer? = nil
    private let liveActivityManager = LiveActivityManager.shared
    
    private var activityObserver: Task<Void, Error>?
    
    var selectedMinutes: Int = 1
    var length: Int = 1 * 60
    var timeRemaining: Int = 1 * 60
    
    var isRunning = false
    var isPaused = false
    var isStarted = false
    
    var showSelectTimeModal: Bool = false
    
    var progress: CGFloat {
        CGFloat(length - timeRemaining) / CGFloat(length)
    }
    
    func startTimer() {
        if isStarted {
            liveActivityManager.resumeActivity()
        } else {
            if let activity = liveActivityManager.startActivity(duration: TimeInterval(length)) {
                self.observeActivityChanges(activity: activity)
            }
        }
        
        isStarted = true
        isRunning = true
        isPaused = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.resetTimer()
                }
            }
        }
    }
    
    func pauseTimer() {
        if isRunning {
            isPaused = true
            timer?.invalidate()
            isRunning = false
            
            liveActivityManager.pauseActivity()
        }
    }
    
    func resetTimer() {
        timeRemaining = length
        
        isStarted = false
        isRunning = false
        isPaused = false
        timer?.invalidate()
        
        liveActivityManager.stopActivity()
    }
    
    func getFormattedTime() -> String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func selectFocusDuration() {
        length = selectedMinutes * 60
        showSelectTimeModal = false
    }
    
    func resetSelectedTime() {
        if (selectedMinutes * 60) != length {
            selectedMinutes = length / 60
        }
    }
    
    func observeActivityChanges(activity: Activity<TimerAttributes>) {
        activityObserver = Task {
            Task {
                for await content in activity.contentUpdates {
                    let newState = content.state
                    await MainActor.run {
                        handleActivityUpdate(newState: newState)
                    }
                }
            }
            
            Task {
                for await state in activity.activityStateUpdates {
                    if state == .ended || state == .dismissed {
                        await MainActor.run {
                            handleActivityEnded()
                        }
                    }
                }
            }
        }
    }
    
    func handleActivityUpdate(newState: TimerAttributes.ContentState) {
        switch newState.state {
        case .paused:
            if self.isRunning {
                self.timer?.invalidate()
                self.isPaused = true
                self.isRunning = false
            }
        case .running(let endTime):
            let updatedTimeRemaining = endTime.timeIntervalSinceNow
            self.timeRemaining = Int(updatedTimeRemaining)
            
            if !self.isRunning {
                self.startTimer()
            }
        }
    }
    
    func handleActivityEnded() {
        guard isStarted else { return }
    
        timeRemaining = length
        isStarted = false
        isRunning = false
        isPaused = false
        timer?.invalidate()
        activityObserver?.cancel()
    }
    
    func syncWithLiveActivity() {
        if let activity = Activity<TimerAttributes>.activities.first {
            if case .running(let endTime) = activity.content.state.state {
                let updatedTimeRemaining = endTime.timeIntervalSinceNow
                self.timeRemaining = Int(updatedTimeRemaining)
            }
        } else {
            print("Nenhuma LiveActivity encontrada.")
        }
    }
    
}
