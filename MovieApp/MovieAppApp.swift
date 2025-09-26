//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by selinay ceylan on 23.09.2025.
//

import SwiftUI

@main
struct MovieAppApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView().environment(\.font, .custom("Lato-Regular", size: 18))
        }
    }
}
