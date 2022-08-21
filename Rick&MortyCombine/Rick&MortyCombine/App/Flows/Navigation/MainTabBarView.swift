//
//  MainTabBarView.swift
//  Rick&MortyCombine
//
//  Created by Мария Коханчик on 18.08.2022.
//

import SwiftUI

struct MainTabBarView: View {
    
    // MARK: - Content view
    
    var body: some View {
        TabView {
            CharactersView(model: CharactersViewModel())
                .tabItem {
                    Image(systemName: "person.crop.square.fill.and.at.rectangle")
                    Text("Characters")
                }
//            LocationsView()
//                .tabItem {
//                    Image(systemName: "map")
//                    Text("Locations")
//                }
            EpisodesView()
                .tabItem {
                    Image(systemName: "tv")
                    Text("Episodes")
                }
        }
    }
}

// MARK: - Screen content view

struct MainTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarView()
    }
}
