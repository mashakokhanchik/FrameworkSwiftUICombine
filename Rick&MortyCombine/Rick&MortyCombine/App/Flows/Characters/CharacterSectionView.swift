//
//  CharacterCell.swift
//  Rick&MortyCombine
//
//  Created by Мария Коханчик on 12.08.2022.
//

import SwiftUI
import Combine
import Kingfisher

struct CharacterSectionView: View {
    
    // MARK: - Properties
    
    var character: Character
    @State private var characterDetailIsPresented: Bool = false
    
    // MARK: - Content view
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(character.name)
                    .multilineTextAlignment(.leading)
                Spacer()
                Button("More") {
                    self.characterDetailIsPresented = true
                }
                .font(.callout)
            }
            .sheet(isPresented: self.$characterDetailIsPresented, content: {
                CharacterDetailView(character: character)
            })
            
            .font(.title)
            KFImage(URL(string: character.image))
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("Gender: " + character.gender)
            Text("Status: " + character.status)
            if character.type.isEmpty == false {
                Text("Type: " + character.type)
            }
        }
        .padding()
    }
}


