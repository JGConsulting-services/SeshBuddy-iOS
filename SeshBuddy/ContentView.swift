//
//  ContentView.swift
//  SeshBuddy
//
//  Created by Jake Gibbons on 03/06/2023.
//

import SwiftUI

struct Guest: Identifiable {
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
    
struct TimerView: View {
    @Binding var guests: [Guest]
    var index: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(guests[index].name)
                    .font(.headline)
                    .padding(.bottom, 1)
                Text(String(format: "%.2fml", guests[index].alcoholAmount))
                    .font(.subheadline)
                    .padding(.bottom, 1)
                Text(timeString(time: guests[index].timerCountdown))
                    .font(.subheadline)
                    .foregroundColor(guests[index].timerCountdown <= 600 ? Color.red : Color.black)
                                        .bold()
            }
            Spacer()
            Button(action: {
                startTimer(for: index, guests: $guests) // Pass the guests array as a parameter
            }) {
                Text("Start Timer")
                .foregroundColor(guests[index].timerCountdown > 0 ? Color.gray : Color.blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .cornerRadius(8)
            }

            .disabled(guests[index].timerCountdown > 0)
        }
    }
}

func startTimer(for index: Int, guests: Binding<[Guest]>) { // Add a parameter for the guests array
    guests.wrappedValue[index].timer = Timer.scheduledTimer(withTimeInterval: 3600.0, repeats: false) { _ in
        // Timer has finished
    }
}

    func timeString(time: Int) -> String {
            let hours = time / 3600
            let minutes = (time % 3600) / 60
            let seconds = (time % 3600) % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }


struct EditGuestView: View {
    @Binding var guest: Guest // A binding to the guest to be edited
    @Environment(\.dismiss) var dismiss // A reference to the dismiss function of the sheet
    
    var body: some View {
        Form {
            Section(header: Text("Edit Guest Information")){
                TextField("Name", text: $guest.name) // A text field for editing the name
                TextField("GHB Amount", value: $guest.alcoholAmount, formatter: NumberFormatter()) // A text field for editing the alcohol amount
                Button(action: {
                    dismiss() // Dismiss the sheet after editing
                }) {
                    Text("Save")
                }
            }
        }
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
    @State private var showingEditGuest = false // A state variable for showing the edit guest sheet
    @State private var selectedGuestIndex = 0 // A state variable for storing the index of the selected guest
    
    var body: some View {
        NavigationView {
            List(guests, id: \.id) { guest in // Use the List view
                TimerView(guests: $guests, index: guests.firstIndex(where: { $0.id == guest.id })!)
                    .swipeActions(edge: .leading) { // Add swipe actions from the leading edge
                        Button(action: {
                            startTimer(for: index, guests: $guests) // Start the timer for the guest
                        }) {
                            Label("Start Timer", systemImage: "timer")
                        }
                        .tint(.green)
                    }
                    .swipeActions(edge: .trailing) { // Add swipe actions from the trailing edge
                        Button(action: {
                            deleteGuest(at: index) // Delete the guest from the array
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                    .contextMenu { // Add a context menu
                        Group { // Wrap the buttons in a group
                            Button(action: {
                                editGuest(at: index, showingEditGuest: $showingEditGuest, selectedGuestIndex: $selectedGuestIndex) // Pass the showingEditGuest and selectedGuestIndex state variables as parameters
                            }) {
                                Label("Edit Guest", systemImage: "pencil")
                            }
                            Button(action: {
                                startTimer(for: index, guests: $guests) // Start the timer for the guest
                            }) {
                                Label("Start Timer", systemImage: "timer")
                            }
                            Button(action: {
                                deleteGuest(at: index) // Delete the guest from the array
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
            }
            .navigationBarTitle("SeshBuddy")
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.showingTermsOfUse.toggle()
                    }) {
                        Image(systemName: "questionmark.circle.fill")
                        Text("Help")
                    },
                trailing:
                    NavigationLink(destination: AddGuestView(guests: $guests)) {
                        Image(systemName: "plus")
                    }            )
            
        }
        .sheet(isPresented: $showingTermsOfUse) {
            HelpSheetView()
        }
        .sheet(isPresented: $showingEditGuest) { // Present a sheet for editing a guest
            EditGuestView(guest: $guests[selectedGuestIndex]) // Pass a binding to the selected guest
        }
    }

}

func deleteGuest(at index: Int) {
    guests.remove(at: index) // Remove the guest from the array
}


// Add a parameter for the selectedGuestIndex state variable
func editGuest(at index: Int, showingEditGuest: Binding<Bool>, selectedGuestIndex: Binding<Int>) {
    selectedGuestIndex.wrappedValue = index // Set the selected guest index
    showingEditGuest.wrappedValue = true // Show the edit guest sheet
}



struct HelpSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPage = 0
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Image("AppLogo") // Replace with the name of your logo image asset
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .padding()
                Spacer()
            }
            HStack {
                Text("Built with")
                ZStack {
                    Image(systemName: "heart")
                        .foregroundColor(.red)
                        .scaleEffect(animationAmount)
                        .animation(
                            Animation.spring(response: 0.2, dampingFraction: 0.3, blendDuration: 0.8) // Change this line
                                .delay(0.02)
                                .repeatForever(autoreverses: true),
                            value: animationAmount)
                        .onAppear {
                            animationAmount = 1.2
                        }
                }
                Text("by Jake")
            }
            .padding()
            
            // Segmented control
            Picker(selection: $selectedPage, label: Text("")) {
                Text("Terms of Use").tag(0)
                Text("How to Use").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Content based on selected page
            if selectedPage == 0 {
                showTermsOfUse()
            } else {
                showHowToUse()
            }
            
            Spacer()
            
            // Accept and Close button
            Button(action: {
                dismiss()
            }) {
                Text("Accept & Close")
                    .foregroundColor(.blue)
                    .font(.headline)
            }
        }
        .padding()
    }
    
    func showTermsOfUse() -> some View {
        let termsFileName = "Terms"
        let termsFileExtension = "txt"
        
        if let termsURL = Bundle.main.url(forResource: termsFileName, withExtension: termsFileExtension),
           let termsData = try? Data(contentsOf: termsURL),
           let termsString = String(data: termsData, encoding: .utf8) {
            return AnyView(
                ScrollView {
                    HStack(
                    ){
                        Image(systemName: "building.columns.fill")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Terms of Use")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                    }
                    // Use a Text view to display the terms of usage
                    Text(termsString)
                        .padding()
                }
            )
        } else {
            return AnyView(
                Text("Terms of Use not available.")
            )
        }
    }
    
    func showHowToUse() -> some View {
        if true {
            return AnyView(
                ScrollView {
                    Text("How to Use")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    // Instructions for how to use the app
                    // ...
                    
                    Text("Placeholder Content")
                        .font(.subheadline)
                        .padding()
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
