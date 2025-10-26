//
//  LiveWidget.swift
//
//  Created by Enzo Henrique Botelho Romão on 17/10/25.
//

import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents

struct TimerActivityView : View {
    var context: ActivityViewContext<TimerAttributes>
    
    var isRunning: Bool {
        if case .running = context.state.state {
            return true
        }
        return false
    }
    
    var body: some View {
        HStack {
            switch context.state.state {
                case .running(let endTime):
                    Text(timerInterval: Date.now...endTime, countsDown: true)
                        .font(.system(size: 40))
                        .monospacedDigit()
                        .foregroundStyle(Color.pastelRed)
                        
                case .paused(let remainingTime):
                    Text(formatTimeInterval(remainingTime))
                        .font(.system(size: 40))
                        .monospacedDigit()
                        .foregroundStyle(Color.pastelRed)
            }
            
            Spacer()
            
            if isRunning {
                Button(intent: PauseIntent()) {
                    Image(systemName: "pause.fill")
                        .font(.system(size: 24))
                        .fontWeight(.regular)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                .frame(width: 50, height: 50)
                .background(.white.opacity(0.3))
                .cornerRadius(25)
            } else {
                HStack(spacing: 18) {
                    Button(intent: ResumeIntent()) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 24))
                            .fontWeight(.regular)
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 50, height: 50)
                    .background(Color.pastelRed)
                    .cornerRadius(25)
                    
                    Button(intent: FinishIntent()) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                    .frame(width: 50, height: 50)
                    .background(.white.opacity(0.3))
                    .cornerRadius(25)
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(24)
        .background(.black)
    }
    
}

struct LiveWidget: Widget {
    let kind: String = "Widget"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            TimerActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    switch context.state.state {
                        case .running(let endTime):
                        Text(endTime, style: .timer)
                            .frame(maxHeight: 50, alignment: .center)
                            .font(.system(size: 20, weight: .semibold))
                            .monospaced()
                            .foregroundStyle(Color.white)
                            .multilineTextAlignment(.leading)
                            .offset(y: 5)
                            .padding(.leading, 10)
                                
                        case .paused(let remainingTime):
                            Text(formatTimeInterval(remainingTime))
                                .frame(maxHeight: 50, alignment: .center)
                                .font(.system(size: 20, weight: .semibold))
                                .monospaced()
                                .foregroundStyle(Color.white)
                                .multilineTextAlignment(.leading)
                                .offset(y: 5)
                                .padding(.leading, 10)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    ZStack {
                        Circle()
                            .frame(width: 60)
                            .foregroundStyle(Color.pastelRed.opacity(0.1))
                            
                        Circle()
                            .frame(maxWidth: 40)
                            .foregroundStyle(Color.pastelRed.opacity(0.1))
                        
                        Image("TimerIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18)
                    }
                }
            } compactLeading: {
                switch context.state.state {
                    case .running(let endTime):
                    Text(endTime, style: .timer)
                        .frame(maxWidth: 40)
                        .font(.system(size: 12, weight: .medium))
                        .scaleEffect(x: 1, y: 1.1)
                        .monospaced()
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(Color.white)
                            
                    case .paused(let remainingTime):
                    Text(formatTimeInterval(remainingTime))
                        .frame(maxWidth: 40)
                        .font(.system(size: 12, weight: .medium))
                        .scaleEffect(x: 1, y: 1.1)
                        .monospaced()
                        .foregroundStyle(Color.white)
                        .padding(.leading, 3)
                    
                }
            } compactTrailing: {
                Image("TimerIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                    .padding(.trailing, 5)
            } minimal: {
                Image("TimerIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
            }
            .keylineTint(Color.pastelRed)
        }
    }
}

private func formatTimeInterval(_ interval: TimeInterval) -> String {
    let time = max(interval, 0)
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    
    return String(format: "%d:%02d", minutes, seconds)
}

#Preview("Lock-Normal", as: .content, using: TimerAttributes()) {
    LiveWidget()
} contentStates: {
    TimerAttributes.ContentState(state: .running(endTime: Date().addingTimeInterval(60 * 15)))
    TimerAttributes.ContentState(state: .paused(remainingTime: 120))
}

#Preview("Island-Compact", as: .dynamicIsland(.compact), using: TimerAttributes()) {
    LiveWidget()
} contentStates: {
    TimerAttributes.ContentState(state: .running(endTime: Date().addingTimeInterval(60 * 15)))
    TimerAttributes.ContentState(state: .paused(remainingTime: 60 * 15))
}

#Preview("Island-Minimal", as: .dynamicIsland(.minimal), using: TimerAttributes()) {
    LiveWidget()
} contentStates: {
    TimerAttributes.ContentState(state: .running(endTime: Date().addingTimeInterval(60 * 2)))
    TimerAttributes.ContentState(state: .paused(remainingTime: 120))
}

#Preview("Island-Expanded", as: .dynamicIsland(.expanded), using: TimerAttributes()) {
    LiveWidget()
} contentStates: {
    TimerAttributes.ContentState(state: .running(endTime: Date().addingTimeInterval(60 * 2)))
    TimerAttributes.ContentState(state: .paused(remainingTime: 120))
}


