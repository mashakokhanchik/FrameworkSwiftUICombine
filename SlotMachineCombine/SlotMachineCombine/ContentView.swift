//
//  ContentView.swift
//  SlotMachineCombine
//
//  Created by Мария Коханчик on 11.08.2022.
//

import SwiftUI
import Combine

class SlotMachineModel: ObservableObject {
    
    @Published var running = false
    @Published var gameStart = false
    
    @Published var slotEmoji1 = "🍒"
    @Published var slotEmoji2 = "🍋"
    @Published var slotEmoji3 = "🍉"
    
    @Published var textTitle = ""
    @Published var textButton = ""
    
    private var cancellables = Set<AnyCancellable>()
    private var emojiArray = ["🍒", "🍋", "🍉"]
    private let timer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
    init() {
        timer
            .receive(on: RunLoop.main)
            .sink { _ in self.randomize() }
            .store(in: &cancellables)
        
        $running
            .receive(on: RunLoop.main)
            .map {
                guard !$0 && self.gameStart else { return "Let's play!" }
                return self.slotEmoji1 == self.slotEmoji2 && self.slotEmoji2 == self.slotEmoji3 ? "You won!!!" : "Bad luck"
            }
            .assign(to: \.textTitle, on: self)
            .store(in: &cancellables)
        
        $running
            .receive(on: RunLoop.main)
            .map { $0 == true ? "Stop" : "Play" }
            .assign(to: \.textButton, on: self)
            .store(in: &cancellables)
    }
    
    private func randomize() {
        guard running else { return }
        slotEmoji1 = emojiArray[Int.random(in: 0...emojiArray.count - 1)]
        slotEmoji2 = emojiArray[Int.random(in: 0...emojiArray.count - 1)]
        slotEmoji3 = emojiArray[Int.random(in: 0...emojiArray.count - 1)]
    }
}

struct SlotView <Content: View>: View {
    
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) { self.content = content}
    
    var body: some View {
        content()
            .font(.system(size: 64.0))
            .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)))
            .animation(.default)
            .id(UUID())
    }
}

struct ContentView: View {
    
    @ObservedObject private var slotMachineModel = SlotMachineModel()
    
    var body: some View {
        
        VStack {
            Spacer()
            Text(slotMachineModel.textTitle)
            Spacer()
            
            HStack {
                SlotView { Text(slotMachineModel.slotEmoji1) }
                SlotView { Text(slotMachineModel.slotEmoji2) }
                SlotView { Text(slotMachineModel.slotEmoji3) }
            }
            
            Spacer()
            Button(action: { slotMachineModel.running.toggle(); slotMachineModel.gameStart = true }, label: { Text(slotMachineModel.textButton) })
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
