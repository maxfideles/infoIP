//
//  ContentView.swift
//  infoIP
//
//  Created by Max Victor on 02/06/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack {
            VStack {
                Text("InfoIP")
                    .font(.title)
                MainView()
                    
            }
        
        }
            }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
