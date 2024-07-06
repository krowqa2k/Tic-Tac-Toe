//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by admin on 06/07/2024.
//

import SwiftUI

struct ContentView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisabled = false
    @State private var alertItem: AlertItem?
    @State private var playerScore: Int = 0
    @State private var computerScore: Int = 0
    
    var body: some View {
        HStack{
            Text("Player: \(playerScore)")
                .font(.title)
                .fontWeight(.semibold)
            Spacer()
            Text("Computer: \(computerScore)")
                .font(.title)
                .fontWeight(.semibold)
        }
        .padding(.horizontal)
        LazyVGrid(columns: columns, spacing: 2, content: {
            ForEach(0..<9) { i in
                ZStack {
                    Circle()
                        .foregroundStyle(.purple).opacity(0.7)
                    
                    Image(systemName: moves[i]?.indicator ?? "")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                }
                .onTapGesture {
                    if isSquareOccupied(in: moves, forIndex: i) { return }
                    moves[i] = Move(player: .human, boardIndex: i)
                    
                    if checkWinCondition(for: .human, in: moves) {
                        alertItem = AlertContext.humanWin
                        playerScore += 1
                        return
                    }
                    
                    if checkForDraw(in: moves) {
                        alertItem = AlertContext.Draw
                        return
                    }
                    
                    isGameboardDisabled.toggle()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let computerPosition = determineComputerMovePosition(in: moves)
                        moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                        isGameboardDisabled.toggle()
                        
                        if checkWinCondition(for: .computer, in: moves) {
                            alertItem = AlertContext.computerWin
                            computerScore += 1
                            return
                        }
                        
                        if checkForDraw(in: moves) {
                            alertItem = AlertContext.Draw
                            return
                        }
                    }
                }
            }
        })
        .alert(item: $alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: .default(alertItem.buttonTitle,
                                          action: {resetGame()}))
        })
        .disabled(isGameboardDisabled)
        .padding()
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        // If AI can win, take it
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositons = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPostions = pattern.subtracting(computerPositons)
            
            if winPostions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPostions.first!)
                if isAvailable { return winPostions.first! }
            }
        }
        
        // If AI cant win then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositons = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPostions = pattern.subtracting(humanPositons)
            
            if winPostions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPostions.first!)
                if isAvailable { return winPostions.first! }
            }
        }
        
        // If AI can't block, then take middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        
        // If AI can't win take middle square, ake random available square
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositons = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositons) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
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
    ContentView()
}
