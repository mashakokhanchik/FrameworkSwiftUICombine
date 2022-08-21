//
//  CharactersView.swift
//  Rick&MortyCombine
//
//  Created by Мария Коханчик on 12.08.2022.
//

import SwiftUI
import Combine
import Kingfisher

struct CharactersView: View {
    
    // MARK: - Properties
    
    @ObservedObject var model: CharactersViewModel
    @State private var filterSettingsIsPresented: Bool = false
    @State var currentDate: Date = Date()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var filter: Filter
    
    private let timer = Timer.publish(every: 10, on: .main, in: .common)
        .autoconnect()
        .eraseToAnyPublisher()
    
    // MARK: - Initialization
    
    init(model: CharactersViewModel) {
        self.model = model
    }
    
    // MARK: - Content view
    
    var body: some View {
        let filter: String = model.filterText
        
        return NavigationView {
            List {
                Section(header: SectionHeaderView(header: filter, lastUpdateTime: model.lastUpdateTime, currentDate: self.currentDate)) {
                    ForEach(self.model.characters) { character in
                        CharacterSectionView(character: character)
                    }
                     .onReceive(timer) {
                        self.currentDate = $0
                    }
                }
                .padding(2)
            }
            .sheet(isPresented: self.$filterSettingsIsPresented, content: {
               FilterSettingsView()
                .environmentObject(self.filter)
            })
            .alert(item: self.$model.error) { error in
                Alert(title: Text("Network error"),
                      message: Text(error.localizedDescription),
                      dismissButton: .cancel())
            }
            .navigationBarTitle(Text("Characters"))
            .navigationBarItems(trailing:
                Button("Filter") {
                    self.filterSettingsIsPresented = true
                }
                .foregroundColor(self.colorScheme == .light ? .blue : .orange)
            )
        }
        .onAppear() {
            model.fetchCharacters()
        }
    }

}

// MARK: - Screen content view

struct CharactersView_Previews: PreviewProvider {
    
    static var previews: some View {
        CharactersView(model: CharactersViewModel())
    }

}

