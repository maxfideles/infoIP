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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(reviewsManager)
        }
    }
}
