//
//  ContentView.swift
//  ShareDemo
//
//  Created by Lyudmila Tokar on 10/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showShareSheet = false
    let dataToShare = "Hello from my demo app!" // This mimics your WhatsApp message

    var body: some View {
        VStack(spacing: 40) {
            Text("WhatsApp Share Demo")
                .font(.title)
                .bold()
            
            Button(action: {
                showShareSheet = true
            }) {
                Text("Share Data")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ActivityView(activityItems: [dataToShare])
        }
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
