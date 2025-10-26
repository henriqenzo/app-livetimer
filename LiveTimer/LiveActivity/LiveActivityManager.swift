//
//  LiveActivityManager.swift
//  LiveTimer
//
//  Created by Enzo Henrique Botelho Romão on 17/10/25.
//

import Foundation
import ActivityKit
import BackgroundTasks

class LiveActivityManager {
    static let shared = LiveActivityManager()
    private var activity: Activity<TimerAttributes>?
    
    func startActivity(duration: TimeInterval) -> Activity<TimerAttributes>? {
        let attributes = TimerAttributes()
        let endTime = Date().addingTimeInterval(duration)
        let state = TimerAttributes.ContentState(state: .running(endTime: endTime))
        
        do {
            let activity = try Activity<TimerAttributes>.request(
                attributes: attributes,
                content: ActivityContent(state: state, staleDate: nil),
                pushType: nil
            )
            return activity
        } catch {
            print("Erro ao iniciar a Live Activity: \(error.localizedDescription)")
            return nil
        }
    }

    func pauseActivity() {
        guard let activityToPause = Activity<TimerAttributes>.activities.first,
              case .running(let endTime) = activityToPause.content.state.state else {
            return
        }
        
        let remainingTime = endTime.timeIntervalSinceNow
        
        let newState = TimerAttributes.ContentState(state: .paused(remainingTime: remainingTime))
        
        Task {
            await activityToPause.update(ActivityContent(state: newState, staleDate: nil))
        }
    }

    func resumeActivity() {
        guard let activityToResume = Activity<TimerAttributes>.activities.first,
              case .paused(let remainingTime) = activityToResume.content.state.state else {
            return
        }
        
        let newEndTime = Date().addingTimeInterval(remainingTime)
        
        let newState = TimerAttributes.ContentState(state: .running(endTime: newEndTime))
        
        Task {
            await activityToResume.update(ActivityContent(state: newState, staleDate: nil))
        }
    }

    func stopActivity() {
        guard let activityToEnd = Activity<TimerAttributes>.activities.first else { return }
        let lastState = activityToEnd.content.state
        
        Task {
            await activityToEnd.end(
                ActivityContent(state: lastState, staleDate: nil),
                dismissalPolicy: .immediate
            )
        }
    }
    
}
