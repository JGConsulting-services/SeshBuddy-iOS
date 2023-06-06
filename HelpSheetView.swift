//
//  HelpSheetView.swift
//  SeshBuddy
//
//  Created by Jake Gibbons on 05/06/2023.
//

import SwiftUI

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
                    HStack {
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

struct HelpSheetView_Previews: PreviewProvider {
    static var previews: some View {
        HelpSheetView()
    }
}
