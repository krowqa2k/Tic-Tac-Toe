//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by admin on 06/07/2024.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        HStack{
            Text("Player: \(viewModel.playerScore)")
                .font(.title)
                .fontWeight(.semibold)
            Spacer()
            Text("Computer: \(viewModel.computerScore)")
                .font(.title)
                .fontWeight(.semibold)
        }
        .padding(.horizontal)
        LazyVGrid(columns: viewModel.columns, spacing: 2, content: {
            ForEach(0..<9) { i in
                ZStack {
                    GameSquareView()
                    
                    PlayerIndicator(systemImageName: viewModel.moves[i]?.indicator ?? "")
                }
                .onTapGesture {
                    viewModel.processPlayerMove(for: i)
                    }
                }
            })
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                        message: alertItem.message,
                        dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() }))
                })
                .disabled(viewModel.isGameboardDisabled)
                .padding()
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

#Preview {
    GameView()
}

struct GameSquareView: View {
    var body: some View {
        Circle()
            .foregroundStyle(.purple).opacity(0.7)
    }
}

struct PlayerIndicator: View {
    
    var systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
    }
}
