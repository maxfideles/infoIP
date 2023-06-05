//
//  ContentView.swift
//  infoIP
//
//  Created by Max Victor on 02/06/23.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    var body: some View {
        
        VStack {
            VStack {
                Text("InfoIP")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                
                MainView()
                    
            }
        
        }
            }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ReviewsRequestManager())
    }
}
