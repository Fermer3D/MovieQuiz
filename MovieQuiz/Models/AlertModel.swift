//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Данил Третьяченко on 20.10.2025.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
} 
