//
//  gameRow.swift
//  gameAttack
//
//  Created by test on 2023/12/20.
//
import Foundation
import SwiftUI
import Pow


struct favorRow: View {
    let item: GamesItem
    
    @State var isAdded = true
    var body: some View {

            
            ZStack{
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.random)
                    .frame(width: 380, height: 330)
                    .opacity(0.5)
                if isAdded {
                    VStack{
                        AsyncImage(url: URL(string: item.thumbnail)){ phase in
                            if let image = phase.image{
                                image
                                    .resizable()
                                
                                    .scaledToFit()
                            } else if phase.error != nil{
                                Color.gray
                                
                            } else{
                                Image(systemName: "arrow.triangle.2.circlepath.icloud.fill")
                                    
                                    .resizable()
                                    .foregroundStyle(Color.blue)
                                    .frame(width: 206,height: 206)
                                    .scaledToFit()
                                
                                
                                
                            }
                            
                        }
                        
                        //.frame(width: 460*0.4, height: 215*0.4)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        //Spacer()
                        VStack(alignment: .center) {
                            Text(item.title)
                                .bold()
                            Text(item.platform)
                            
                        }
                        Text(item.short_description)
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                        
                    }
                    .padding()//.background(Color.gray)
                    .transition(.movingParts.blur)
                }
                else{
                    Text(item.short_description)
                        .multilineTextAlignment(.center)
                }
                Button(action: {
                    
                     var favorList:[Int] = UserDefaults.standard.value(forKey: "favorList") as? [Int] ?? []
                    //favorList.append(item.id)
                    //
                    if let index = favorList.firstIndex(of: item.id) {
                        favorList.remove(at: index)
                        print(item.id, index, favorList)
                    }
                    
                    UserDefaults.standard.set(favorList, forKey: "favorList")
                    print(UserDefaults.standard.value(forKey: "favorList") )
                    //print(UserDefaults.standard.dictionaryRepresentation())
                    
                }) {
                    Text("❌")
                        .font(.system(size: 36))
                    
                    
                }.offset(x:130,y: 60)
                
                ShareLink(item: URL(string: item.game_url)!).offset(x:120,y: 90)
                
            }.onTapGesture {
                withAnimation {
                    isAdded.toggle()
                }
            }
            
            
        
    }
}


#Preview {
    favorRow(item: GamesItem(id: 13, title: "Overwatch 2", thumbnail: "https://www.freetogame.com/g/540/thumbnail.jpg", platform: "PC (Windows)", short_description: "A hero-focused first-person team shooter from Blizzard Entertainment.", game_url: "https://www.freetogame.com/open/overwatch-2"))
}
