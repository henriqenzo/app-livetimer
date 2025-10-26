//
//  TimerAttributes.swift
//  LiveTimerWidgetExtension
//
//  Created by Enzo Henrique Botelho Romão on 17/10/25.
//

import ActivityKit
import SwiftUI

struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        enum State: Codable, Hashable {
            case running(endTime: Date)
            case paused(remainingTime: TimeInterval)
        }
        var state: State
    }
}
