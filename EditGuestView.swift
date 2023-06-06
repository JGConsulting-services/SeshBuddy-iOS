//
//  EditGuestView.swift
//  SeshBuddy
//
//  Created by Jake Gibbons on 05/06/2023.
//

import SwiftUI

struct EditGuestView: View {
    @Binding var guest: Guest
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Edit Guest Name")) {
                    TextField("Name", text: $guest.name)
                }
                
                Section(header: Text("Edit GHB Amount")) {
                    Stepper(value: $guest.alcoholAmount, in: 0...10, step: 0.1) {
                        Text("GHB Amount (ml): \(guest.alcoholAmount, specifier: "%.1f")")
                    }
                }
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Save Changes")
                }
            }
        }
        .navigationBarTitle("Edit Guest")
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

struct EditGuestView_Previews: PreviewProvider {
    static var previews: some View {
        EditGuestView(guest: .constant(Guest(name: "John", alcoholAmount: 0.5)))
    }
}
