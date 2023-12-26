//
//  GameView.swift
//  gameAttack
//
//  Created by test on 2023/12/20.
//


import SwiftUI

struct GameView: View {
    @Environment(GamesDataFetcher.self) var fetcher
    @State private var showError = false
    @State private var error: Error?
    @State private var searchText = ""
    var searchResult: [GamesItem] {
        if searchText.isEmpty {
            fetcher.items
        } else {
            fetcher.items.filter {
                $0.title.contains(searchText)
            }
        }
        
    }

    var body: some View {
        
        NavigationStack{
            //Text("haha")
            ScrollView(.vertical) {
                ForEach(searchResult) { item in
                    gameRow(item: item)
                        
                }
            }
            
            .task {
                if fetcher.items.isEmpty {
                    do {
                        try await fetcher.fetchData(term: "swift")
                        fetcher.items.shuffle()
                    } catch {
                        print(error)
                        self.error = error
                        showError = true
                    }
                }
            }.alert(error?.localizedDescription ?? "", isPresented: $showError, actions: {
            })
            .overlay {
                if !searchText.isEmpty, searchResult.isEmpty {
                    
                    ContentUnavailableView(
                        "找不到",
                        systemImage: "exclamationmark.magnifyingglass",
                        description: Text("請再試試")
                    ).transition(
                        .movingParts.blinds(slatWidth: 25)
                      )
                }
                else if searchResult.isEmpty{
                    
                    ContentUnavailableView(
                        "載入中請稍候",
                        systemImage: "arrow.triangle.2.circlepath.icloud.fill",
                        description: Text("請稍候")
                    ).transition(
                        .movingParts.blinds(slatWidth: 25)
                      )
                }
                else  {
                    
                    ContentUnavailableView(
                        "網路有問題",
                        systemImage: "network.slash",
                        description: Text("請檢查網路")
                    ).transition(
                        .movingParts.blinds(slatWidth: 25)
                      )
                }
                
            }
            
        }.refreshable {
            do {
                try await fetcher.fetchData(term: "swift")
                fetcher.items.shuffle()
            } catch {
                print(error)
                self.error = error
                showError = true
            }
        }.searchable(text: $searchText)
            
    }
    
}


#Preview {
    GameView()
        .environment(GamesDataFetcher())
}
