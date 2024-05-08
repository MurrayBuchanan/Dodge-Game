//
//  ContentView.swift
//  LugaWatch Watch App
//
//  Created by Murray Buchanan on 03/07/2023.
//  Copyright © 2023 Murray Buchanan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
