//
//  infoIPApp.swift
//  infoIP
//
//  Created by Max Victor on 02/06/23.
//

import SwiftUI

@main
struct infoIPApp: App {
    @StateObject private var reviewsManager = ReviewsRequestManager()
    @StateObject  var launchScreenManager = LaunchScreenManager()
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(reviewsManager)
                
                if launchScreenManager.state != .completed  {
                    LaunchScreen()
                }
                
                
            }.environmentObject(launchScreenManager)
        }
    }
}
