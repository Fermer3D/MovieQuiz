//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Данил Третьяченко on 20.10.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() 
    func didFailToLoadData(with error: Error)
}
