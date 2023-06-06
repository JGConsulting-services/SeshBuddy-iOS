//
//  TimerView.swift
//  SeshBuddy
//
//  Created by Jake Gibbons on 05/06/2023.
//

import SwiftUI

struct TimerView: View {
    @Binding var guests: [Guest]
    let index: Int
    let startTimer: (Int) -> Void
    
    var body: some View {
        VStack {
            Text(guests[index].name)
            Text("\(guests[index].timerCountdown) seconds")
        }
        .onAppear {
            if guests[index].timer == nil {
                startTimer(index)
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(guests: .constant([Guest(name: "John", alcoholAmount: 0.5)]), index: 0, startTimer: { _ in })
    }
}
