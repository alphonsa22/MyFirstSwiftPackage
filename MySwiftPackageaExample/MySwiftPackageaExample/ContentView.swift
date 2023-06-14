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
           SwiftUIView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
