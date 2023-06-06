////
////  AddGuestView.swift
////  SeshBuddy
////
////  Created by Jake Gibbons on 03/06/2023.
////
//
import SwiftUI

struct AddGuestView: View {
    @Binding var guests: [Guest]
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var alcoholAmount = 0.0
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Add Guest Name")) {
                    TextField("Name", text: $name)
                }
                
                Section(header: Text("Add GHB Amount")) {
                    Stepper(value: $alcoholAmount, in: 0...10, step: 0.1) {
                        Text("GHB Amount (ml): \(alcoholAmount, specifier: "%.1f")")
                    }
                }
                
                Button(action: {
                    let newGuest = Guest(name: name, alcoholAmount: alcoholAmount)
                    guests.append(newGuest)
                    dismiss()
                }) {
                    Text("Add Guest")
                }
            }
        }
        .navigationBarTitle("Add Guest")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Text("Close")
                    Image(systemName: "xmark")
                }
            }
        }
    }
}

struct AddGuestView_Previews: PreviewProvider {
    static var previews: some View {
        AddGuestView(guests: .constant([]))
    }
}
