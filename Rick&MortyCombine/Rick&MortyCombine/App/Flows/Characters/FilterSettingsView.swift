//
//  FilterSettingsView.swift
//  Rick&MortyCombine
//
//  Created by Мария Коханчик on 12.08.2022.
//

import SwiftUI
import Combine

struct FilterSettingsView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var filter: Filter
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Content view
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Tag.allCases) { tag in
                    Button(action: {
                        self.changeTagState(tag)
                    }, label: {
                        HStack {
                            if self.filter.tags.contains(tag) {
                                Image(systemName: "checkmark.circle.fill")
                            }
                            Text(tag.rawValue.capitalized)
                        }
                    })
                }
            }
            .navigationBarTitle(Text("Tags"))
            .navigationBarItems(trailing:
                Button("Done") {
                dismiss()
                }
            )
        }
    }
    
    func changeTagState(_ tag: Tag) {
        filter.tags.contains(tag)
            ? filter.tags.removeAll(where: { $0 == tag })
            : filter.tags.append(tag)
    }

}

