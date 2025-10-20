//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Данил Третьяченко on 20.10.2025.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    private let gamesCountKey = "gamesCount"
        private let bestGameKey = "bestGameResult"
        private let correctAnswersKey = "correctAnswers"
        private let totalQuestionsKey = "totalQuestions"
        

        private let userDefaults = UserDefaults.standard
        private let encoder: JSONEncoder = JSONEncoder()
        private let decoder: JSONDecoder = JSONDecoder()

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
                guard let data = userDefaults.data(forKey: bestGameKey),
                      let result = try? decoder.decode(GameResult.self, from: data) else {
                    return GameResult(correct: 0, total: 0, date: Date())
                }
                return result
            }
            set {
                guard let data = try? encoder.encode(newValue) else {
                    print("Не удалось закодировать bestGame")
                    return
                }
                userDefaults.set(data, forKey: bestGameKey)
            }
        }

        // Вычисляемое свойство общей точности
        var totalAccuracy: Double {
            guard totalQuestionsAsked > 0 else {
                return 0.0
            }
            return Double(totalCorrectAnswers) / Double(totalQuestionsAsked) * 100.0
        }
        
        // Метод для сохранения результата
        func store(correct count: Int, total amount: Int) {
            
            let newResult = GameResult(correct: count, total: amount, date: Date())
            
            // Обновляем общее количество сыгранных игр
            gamesCount += 1
            
            // Обновляем количество вопросов и правильных ответов
            totalCorrectAnswers += count
            totalQuestionsAsked += amount
            
            if newResult.correct > bestGame.correct {
                bestGame = newResult
            } else if newResult.correct == bestGame.correct && newResult.total < bestGame.total {
                 bestGame = newResult
            }
        }
    }
