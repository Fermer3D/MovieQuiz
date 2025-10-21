//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Данил Третьяченко on 20.10.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func compareRecords (_ previousRecord: GameResult) -> Bool {
        return correct > previousRecord.correct ? true : false
    }
}
