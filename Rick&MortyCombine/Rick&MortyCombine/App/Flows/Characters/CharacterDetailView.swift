//
//  CharacterDetailView.swift
//  Rick&MortyCombine
//
//  Created by Мария Коханчик on 15.08.2022.
//

import SwiftUI
import Kingfisher

struct CharacterDetailView: View {
    
    var character: Character
    
    var body: some View {
        VStack {
            KFImage(URL(string: character.image))
                .frame(width: 300, height: 300)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                .offset(y: -160)
                .padding(.bottom, -160)
            VStack(alignment: .leading, spacing: 8.0) {
                Text(character.name)
                    .font(.title)
                HStack {
                    Text("Specie:")
                    Text(character.species)
                }
                HStack {
                    Text("Gender:")
                    Text(character.gender)
                }
                HStack {
                    Text("Status:")
                    Text(character.status)
                }
            }
            .font(.callout)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

