//
//  MinutesPickerView.swift
//  LiveTimer
//
//  Created by Enzo Henrique Botelho Romão on 17/10/25.
//

import SwiftUI

struct MinutesPickerView: View {
    
    @State var viewModel: TimerViewModel
    
    var minutesOptions: [Int] {
        Array(stride(from: 1, through: 120, by: 1))
    }
    
    var body: some View {
        
        ZStack {
        
            Picker("Minutos", selection: $viewModel.selectedMinutes) {
                ForEach(minutesOptions, id: \.self) { value in
                    Text("\(value)").tag(value)
                        .font(.system(size: 24))
                        .padding(.vertical, 8)
                        .foregroundStyle(.black)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 90)
            
            HStack {
                Spacer()
                    .frame(width: 135)
                
                Text("min")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.grey)
            }
            
        }
        .frame(width: 200, height: 150)
        .padding(.vertical, 4)
        
    }
}

#Preview {
    MinutesPickerView(viewModel: TimerViewModel())
}
