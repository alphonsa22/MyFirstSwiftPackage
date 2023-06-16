//
//  ContentView.swift
//  Example
//
//  Created by Alphonsa Varghese on 15/06/23.
//

import SwiftUI
import MyFirstSwiftPackage

struct ContentView: View {
    @State private var showToast = false
    var body: some View {
        VStack {
//            SwiftUIView(str:"Package Testing....")
            Button {
                Log.d("debug testing")
            } label: {
                Text("Click to log")
            }
            .padding()
            ToastView(isPresented: $showToast) {
                VStack {
                    Text("Toast Message")
                        .foregroundColor(.white)
                    Button("Dismiss") {
                        showToast.toggle()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
