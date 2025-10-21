//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Данил Третьяченко on 20.10.2025.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    private let gamesCountKey = "gamesCount"
    private let bestGameCorrectKey = "bestGameCorrect"
    private let bestGameTotalKey = "bestGameTotal"
    private let bestGameDateKey = "bestGameDate"
    private let correctAnswersKey = "correctAnswers"
    private let totalQuestionsKey = "totalQuestions"
    
    private let userDefaults = UserDefaults.standard
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: gamesCountKey)
        }
        set {
            userDefaults.set(newValue, forKey: gamesCountKey)
        }
    }
    
    var totalCorrectAnswers: Int {
        get {
            return userDefaults.integer(forKey: correctAnswersKey)
        }
        set {
            userDefaults.set(newValue, forKey: correctAnswersKey)
        }
    }
    
    var totalQuestionsAsked: Int {
        get {
            return userDefaults.integer(forKey: totalQuestionsKey)
        }
        set {
            userDefaults.set(newValue, forKey: totalQuestionsKey)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = userDefaults.integer(forKey: bestGameCorrectKey)
            let total = userDefaults.integer(forKey: bestGameTotalKey)
            let date = userDefaults.object(forKey: bestGameDateKey) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            userDefaults.set(newValue.correct, forKey: bestGameCorrectKey)
            userDefaults.set(newValue.total, forKey: bestGameTotalKey)
            userDefaults.set(newValue.date, forKey: bestGameDateKey)
        }
    }
    
    
    var totalAccuracy: Double {
        guard totalQuestionsAsked > 0 else {
            return 0.0
        }
        return Double(totalCorrectAnswers) / Double(totalQuestionsAsked) * 100.0
    }
    
    
    func store(correct count: Int, total amount: Int) {
        
        let newResult = GameResult(correct: count, total: amount, date: Date())
        
        gamesCount += 1
        
        totalCorrectAnswers += count
        totalQuestionsAsked += amount
        
        if newResult.correct > bestGame.correct {
            bestGame = newResult
        } else if newResult.correct == bestGame.correct && newResult.total < bestGame.total {
            bestGame = newResult
        }
    }
}
