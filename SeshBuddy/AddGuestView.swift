//
//  AddGuestView.swift
//  SeshBuddy
//
//  Created by Jake Gibbons on 03/06/2023.
//

import SwiftUI

struct AddGuestView: View {
    @Binding var guests: [Guest]
    @Environment(\.presentationMode) var presentationMode // Get the presentation mode of the current view
    @State private var name = ""
    @State private var alcoholAmount = 1.0
    
    var body: some View {
        Form {
            Section(header: Text("Add Guest Information")){
                TextField("Name", text: $name)
                Stepper(value: $alcoholAmount, in: 0...10, step: 0.1) {
                    Text("GHB Amount (ml): \(alcoholAmount, specifier: "%.1f")")
                }}
            Button(action: {
                addGuest()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Add Guest")
            }
        }
        .navigationBarTitle("Add Guest")
    }
    
    func addGuest() {
        let guest = Guest(name: name, alcoholAmount: alcoholAmount)
        guests.append(guest)
    }
}
