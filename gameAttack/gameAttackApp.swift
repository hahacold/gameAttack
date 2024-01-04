//
//  gameAttackApp.swift
//  gameAttack
//
//  Created by test on 2023/12/20.
//

import SwiftUI

@main
struct gameAttackApp: App {
    @State private var gamesfetcher = GamesDataFetcher()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(gamesfetcher)
        }
    }
}
