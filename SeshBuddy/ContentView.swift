//
//  ContentView.swift
//  SeshBuddy
//
//  Created by Jake Gibbons on 03/06/2023.

import SwiftUI

struct Guest {
    let id = UUID()
    var name: String
    var alcoholAmount: Double
    var timerCountdown: Int
    var timer: Timer?
    
    init(name: String, alcoholAmount: Double) {
        self.name = name
        self.alcoholAmount = alcoholAmount
        self.timerCountdown = 0
    }
}

struct ContentView: View {
    @State var guests = [
        Guest(name: "John", alcoholAmount: 0.5),
        Guest(name: "Jane", alcoholAmount: 0.3),
        Guest(name: "Bob", alcoholAmount: 0.8),
    ]
    
    @State private var showingTermsOfUse = false
    @State private var showingAddGuest = false
    @State private var showingEditGuest = false
    @State private var selectedGuest: Guest?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(guests.indices, id: \.self) { index in
                    TimerView(guests: $guests, index: index, startTimer: startTimer)
                        .onTapGesture {
                            selectedGuest = guests[index]
                            showingEditGuest = true
                        }
                }
                .onDelete { indexSet in
                    guests.remove(atOffsets: indexSet)
                }
                
                Button(action: {
                    showingAddGuest = true
                }) {
                    Label("Add Guest", systemImage: "plus")
                }
            }
            .navigationBarTitle("Sesh Buddy")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingTermsOfUse = true
                    }) {
                        Image(systemName: "info.circle")
                    }
                    .sheet(isPresented: $showingTermsOfUse) {
                        Text("Terms of Use")
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditGuest) {
            if let selectedGuest = selectedGuest, let index = guests.firstIndex(where: { $0.id == selectedGuest.id }) {
                NavigationView {
                    EditGuestView(guest: $selectedGuest)
                        .onDisappear {
                            if guests.isEmpty {
                                showingEditGuest = false
                            }
                        }
                }
            }
        }
        .sheet(isPresented: $showingTermsOfUse) {
            HelpSheetView()
        }
    }
    
    func startTimer(for index: Int) { // Update function signature to accept index as Int
        if guests[index].timer == nil && guests[index].timerCountdown > 0 {
            guests[index].timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                guests[index].timerCountdown -= 1
                if guests[index].timerCountdown <= 0 {
                    guests[index].timer?.invalidate()
                    guests[index].timer = nil
                }
            }
        }
    }
    func editGuest(at index: Int) {
            selectedGuestIndex = index
            selectedGuestId = guests[index].id // Set the selectedGuestId
            showingEditGuest = true
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
