//
//  ContentView.swift
//  TryCreditCards
//
//  Created by Francisco Javier Alarza Sanchez on 6/4/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Home()
                .preferredColorScheme(.light)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
