//
//  ContentView.swift
//  infoIP
//
//  Created by Max Victor on 02/06/23.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @EnvironmentObject var launchScreenManager : LaunchScreenManager
    
    var body: some View {
        
       
            VStack {
                Text("InfoIP")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                
                MainView()
                    
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now()+5){
                    launchScreenManager.dismiss()
                }
            }
        
        
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ReviewsRequestManager())
            .environmentObject(LaunchScreenManager())
            
    }
}
