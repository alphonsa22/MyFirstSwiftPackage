//
//  ContentView.swift
//  MySwiftPackageaExample
//
//  Created by Alphonsa Varghese on 14/06/23.
//

import SwiftUI
import MyFirstSwiftPackage

struct ContentView: View {
    var body: some View {
        VStack {
            SwiftUIView(str:"Package Testing....")
            Button {
                Log.d("debug testing")
            } label: {
                Text("Click to log")
            }

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
