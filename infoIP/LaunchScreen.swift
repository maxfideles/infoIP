//
//  LaunchScreen.swift
//  infoIP
//
//  Created by Max Victor on 04/06/23.
//

import SwiftUI

struct LaunchScreen: View {
    
    @State private var firstPhaseisAnimating: Bool = false
    private let timer =   Timer.publish(every:0.65,on:.main,in:.common).autoconnect()
    
    var body: some View {
        
        
        ZStack {
            background
            logo
        }.onReceive(timer) { input in
            withAnimation(.spring()){
                firstPhaseisAnimating.toggle()
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}

private extension LaunchScreen {
    
    var background: some View{
        Color("launchScreen-background")
            .edgesIgnoringSafeArea(.all)
    }
    
    var logo: some View{
        Image("Logo")
            .scaleEffect(firstPhaseisAnimating ? 0.9:1.5)
    }
    
}
