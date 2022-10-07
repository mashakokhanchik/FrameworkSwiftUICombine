//
//  SceneDelegate.swift
//  Rick&MortyCombine
//
//  Created by Мария Коханчик on 12.08.2022.
//

import UIKit
import SwiftUI
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - UISceneSession 
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let viewModel = CharactersViewModel()
        
        let filter = Filter()
        filter.$tags
            .assign(to: \.filterTags, on: viewModel)
            .store(in: &subscriptions)
        
        let contentView = CharactersView(model: viewModel)
            .environmentObject(filter)
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
            viewModel.fetchCharacters()
        }
    }

}
    
    
