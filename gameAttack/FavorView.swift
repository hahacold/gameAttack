//
//  FavorView.swift
//  gameAttack
//
//  Created by test on 2023/12/27.
//

import SwiftUI

import LocalAuthentication
import TipKit
struct disfavorTip: Tip {
    var title: Text {
        Text("按叉叉解除收藏吧！")
    }
    var message: Text? {
        Text("對這個遊戲沒興趣了，按叉取消收藏")
    }
    var image: Image? {
        Image(systemName: "x.square")
        
    }
}
struct privacyTip: Tip {
    @Parameter
    static var isLoggedIn: Bool = false
    var title: Text {
        Text("先解鎖以查看收藏")
    }
    var message: Text? {
        Text("你的收藏隱藏了，保護隱私")
    }
    var image: Image? {
        Image(systemName: "lock.doc.fill")
        
    }
    var rules: [Rule] {
        [
            // Define a rule based on the app state.
            #Rule(Self.$isLoggedIn) {
                // Set the conditions for when the tip displays.
                $0 == false
            }
        ]
    }
}
struct FavorView: View {
    @Environment(GamesDataFetcher.self) var fetcher
    @State private var isUnlocked = false
    @State private var showError = false
    @State private var error: Error?
    @State private var searchText = ""
    //@appstorage
    var tip1 = disfavorTip()
    var tip2 = privacyTip()
    var favorList:[Int] = UserDefaults.standard.value(forKey: "favorList") as? [Int] ?? []
    func authenticate() {
        isUnlocked = false
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                // authentication has now completed
                if success {
                    isUnlocked = true
                    tip2.invalidate(reason: .actionPerformed)
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
                    TipView(tip1)
                        .tint(.red)
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
                    .bold()
                    .font(.system(size: 36))
                    .popoverTip(tip2)
                    .offset(y:-200)
                
            }
        }.onAppear(perform: authenticate)
        
    }
    init() {
        try? Tips.resetDatastore()
        try? Tips.configure()
    }
}


#Preview {
    FavorView()
        .environment(GamesDataFetcher())
}
