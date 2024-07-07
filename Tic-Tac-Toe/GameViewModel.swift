//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by admin on 07/07/2024.
//

import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    @Published var playerScore: Int = 0
    @Published var computerScore: Int = 0
    
    func processPlayerMove(for i: Int) {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
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
