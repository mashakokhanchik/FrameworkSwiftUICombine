//
//  EpisodesView.swift
//  Rick&MortyCombine
//
//  Created by Мария Коханчик on 18.08.2022.
//

import SwiftUI

struct EpisodesView: View {
    
    // MARK: - Properties
    
    var model: EpisodeViewModel = EpisodeViewModel()
    //var episode: Episode
    
    // MARK: - Content view
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.episodes) { episode in
                    VStack(alignment: .leading) {
                        Text(episode.name)
                        Text(episode.episode)
                            .font(.footnote)
                    }
                    Spacer()
                    Text(episode.airDate)
                        .font(.footnote)
                }
            }
            .navigationBarTitle(Text("Episodes"))
        }
    }
}

// MARK: - Screen content view

struct EpisodesView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodesView()
    }
}
