//
//  ContentView.swift
//  ezgamer
//
//  Created by test on 2023/12/13.
//

import SwiftUI
import Pow

struct ContentView: View {
    
    var body: some View {
        
        TabView{
            GameView()
                .tabItem {
                    Label("免費遊戲", systemImage: "gamecontroller")
                }.transition(
                    .movingParts.blinds(slatWidth: 25)
                  )
            

            FavorView()
                .tabItem {
                    Label("收藏夾", systemImage: "folder")
                }.transition(
                    .movingParts.blinds(slatWidth: 25)
                  )
//            StoryView()
//                .tabItem {
//                    Label("特價遊戲", systemImage: "gamecontroller")
//                }
            
            WebView()
                .tabItem {
                    Label("小遊戲", systemImage: "figure.play")
                }.transition(
                    .movingParts.blinds(slatWidth: 25)
                  )
        }
        
       
        
    }
}


#Preview {
    ContentView()
        .environment(GamesDataFetcher())
}
