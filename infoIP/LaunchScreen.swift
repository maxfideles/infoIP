//
//  LaunchScreen.swift
//  infoIP
//
//  Created by Max Victor on 04/06/23.
//

import SwiftUI

struct LaunchScreen: View {
    @EnvironmentObject var launchScreenManager : LaunchScreenManager
    @State private var firstPhaseisAnimating: Bool = false
    @State private var secondPhaseisAnimating: Bool = false

    
    private let timer =   Timer.publish(every:0.65,on:.main,in:.common).autoconnect()
    
    var body: some View {
        
        
        ZStack {
            background
            logo
        }.onReceive(timer) { input in
            
            switch launchScreenManager.state{
            case .first:
                withAnimation(.spring()){
                    firstPhaseisAnimating.toggle()
                }
            case .second:
                withAnimation(.spring()){
                    secondPhaseisAnimating.toggle()
                }
            default: break
            }
            
            
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
            .environmentObject(LaunchScreenManager())
    }
}

private extension LaunchScreen {
    
    var background: some View{
        Color("launchScreen-background")
            .edgesIgnoringSafeArea(.all)
    }
    
    var logo: some View{
        Image("Logo")
            .scaleEffect(firstPhaseisAnimating ? 1:1.5)
            .scaleEffect(secondPhaseisAnimating ? 0:1.4)
    }
    
}
