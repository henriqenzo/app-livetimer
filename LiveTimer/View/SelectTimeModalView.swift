//
//  SelectTimeModalView.swift
//  LiveTimer
//
//  Created by Enzo Henrique Botelho Romão on 17/10/25.
//

import SwiftUI
import SwiftData

struct SelectTimeModalView: View {
    
    var viewModel: TimerViewModel
    
    var isDisabledButton: Bool {
        if (viewModel.selectedMinutes * 60) == Int(viewModel.length) {
            return true
        } else {
            return viewModel.selectedMinutes != Int(viewModel.selectedMinutes)
        }
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            VStack {
                Text("Duração do Timer")
                    .font(.headline)
                    .foregroundStyle(Color.black)
                
                MinutesPickerView(viewModel: viewModel)
                
            }
            .padding(16)
            
            Divider().background(Color.grey)
            
            HStack {
                HStack {
                    Button(action: {
                        viewModel.showSelectTimeModal = false
                        viewModel.resetSelectedTime()
                    }) {
                        Text("Cancelar")
                            .foregroundStyle(Color.pastelRed)
                    }
                    .frame(width: 115, height: 48)
                }
                
                Divider().background(Color.grey)
                    .frame(height: 53)
                
                HStack {
                    Button(action: {
                        viewModel.selectFocusDuration()
                    }) {
                        Text("Confirmar")
                            .foregroundStyle(isDisabledButton ? Color.grey : Color.pastelRed)
                            .fontWeight(.semibold)
                            .animation(.easeInOut(duration: 0.2), value: isDisabledButton)
                    }
                    .disabled(isDisabledButton)
                    .frame(width: 115, height: 48)
                }
                
            }
            
            
        }
        .frame(width: 250)
        .background(Color.lightGrey)
        .cornerRadius(12)
        
    }
    
}

#Preview {
    SelectTimeModalView(viewModel: TimerViewModel())
}
