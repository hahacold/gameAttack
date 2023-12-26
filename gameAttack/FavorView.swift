//
//  FavorView.swift
//  gameAttack
//
//  Created by test on 2023/12/27.
//

import SwiftUI


struct FavorView: View {
    @Environment(GamesDataFetcher.self) var fetcher
    
    @State private var showError = false
    @State private var error: Error?
    @State private var searchText = ""
    //@appstorage
    @State var favorList:[Int] = UserDefaults.standard.object(forKey: "favorList") as? [Int] ?? []
    var body: some View {
        VStack{
            
            //Text("haha")
            ScrollView(.vertical) {
                ForEach(fetcher.favoritems) { item in
                    favorRow(item: item)
                }
                
            }
            .refreshable {
                do {
                    try await fetcher.fetchData(term: "swift")
                    fetcher.items.shuffle()
                } catch {
                    print(error)
                    self.error = error
                    showError = true
                }
            }
            .task {
                if fetcher.favoritems.isEmpty {
                    do {
                        for val in favorList{
                            try await fetcher.fetchidData(term: val)
                        }
                    
                    } catch {
                        print(error)
                        self.error = error
                        showError = true
                    }
                }
            }
            .alert(error?.localizedDescription ?? "", isPresented: $showError, actions: {
            })
        }
    }
}


#Preview {
    FavorView()
        .environment(GamesDataFetcher())
}
