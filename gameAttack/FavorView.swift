//
//  FavorView.swift
//  gameAttack
//
//  Created by test on 2023/12/27.
//

import SwiftUI

import LocalAuthentication
struct FavorView: View {
    @Environment(GamesDataFetcher.self) var fetcher
    @State private var isUnlocked = false
    @State private var showError = false
    @State private var error: Error?
    @State private var searchText = ""
    //@appstorage
    @State var favorList:[Int] = UserDefaults.standard.object(forKey: "favorList") as? [Int] ?? []
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                isUnlocked = true
                // authentication has now completed
                if success {
                    // authenticated successfully
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
    var body: some View {
        VStack{
            if isUnlocked {
                //Text("Unlocked")
                
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
            else {
                Text("Locked")
            }
        }.onAppear(perform: authenticate)
    }
}


#Preview {
    FavorView()
        .environment(GamesDataFetcher())
}
