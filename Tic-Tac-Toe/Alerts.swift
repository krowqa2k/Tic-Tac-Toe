//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by admin on 06/07/2024.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                             message: Text("You are so smart"),
                             buttonTitle: Text("Play again!"))
    
    static let computerWin = AlertItem(title: Text("You lost!"),
                             message: Text("I guess AI is smarter"),
                             buttonTitle: Text("Play again!"))
    
    static let Draw = AlertItem(title: Text("Draw!"),
                             message: Text("Battle is over but the war is just starting..."),
                             buttonTitle: Text("Try again"))
}
