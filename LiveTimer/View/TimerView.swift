//
//  TimerView.swift
//  LiveTimer
//
//  Created by Enzo Henrique Botelho Romão on 17/10/25.
//

import SwiftUI

struct TimerView: View {
    
    let viewModel: TimerViewModel
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            Color.lightGrey
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 64) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 4)
                        .frame(width: 284, height: 284)
                        .foregroundStyle(Color.grey)
                    Circle()
                        .trim(from: 0, to: viewModel.progress)
                        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 284, height: 284)
                        .rotationEffect(.degrees(-90))
                        .foregroundStyle(Color.pastelRed)
                        .animation(viewModel.isRunning ? .spring().speed(0.2) : nil, value: viewModel.timeRemaining)
                    Button(action: {
                        viewModel.showSelectTimeModal = true
                    }) {
                        Text(viewModel.getFormattedTime())
                            .font(.system(size: 48))
                            .foregroundStyle(Color.black)
                            .fontWeight(.light)
                            .contentTransition(.numericText())
                            .animation(.linear, value: viewModel.timeRemaining)
                    }
                    .disabled(viewModel.isRunning == true)
                    
                    if viewModel.isPaused {
                        Text("Pausado")
                            .padding(.top, 80)
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                            .foregroundStyle(Color.gray)
                    }
                }
                .animation(.bouncy(duration: 0.2), value: viewModel.showSelectTimeModal)
                
                if viewModel.isStarted {
                    VStack(spacing: 64) {
                        HStack(spacing: 100) {
                            Button(action: {
                                viewModel.resetTimer()
                            }) {
                                Image(systemName: "stop.fill")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 26))
                                    .frame(width: 80, height: 80)
                                    .background(Color.gray)
                                    .cornerRadius(40)
                            }
                        
                            Button(action: {
                                if viewModel.isRunning {
                                    if viewModel.isPaused {
                                        viewModel.startTimer()
                                    } else {
                                        viewModel.pauseTimer()
                                    }
                                } else {
                                    viewModel.startTimer()
                                }
                            }) {
                                Image(systemName: viewModel.isPaused || !viewModel.isRunning ? "play.fill" : "pause.fill")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 26))
                                    .frame(width: 80, height: 80)
                                    .background(Color.pastelRed)
                                    .cornerRadius(40)
                            }
                        }
                    }
                } else {
                        Button(action: {
                            viewModel.startTimer()
                        }) {
                            Image(systemName: "play.fill")
                                .foregroundColor(Color.white)
                            Text("Começar")
                                .font(.headline)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 133, height: 50)
                        .background(Color.pastelRed)
                        .cornerRadius(12)
                }
            }
            
            if viewModel.showSelectTimeModal {
               Color.black.opacity(0.4)
                   .ignoresSafeArea()
                   .onTapGesture {
                       viewModel.showSelectTimeModal = false
                       viewModel.resetSelectedTime()
                   }
                
                VStack {
                    SelectTimeModalView(viewModel: viewModel)
                    Spacer()
                        .frame(height: 80)
                }
            }
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                if viewModel.isRunning {
                    viewModel.syncWithLiveActivity()
                }
            }
        }
    }
}

#Preview {
    return TimerView(viewModel: TimerViewModel())
}
