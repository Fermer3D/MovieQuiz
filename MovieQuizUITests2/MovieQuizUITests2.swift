//
//  MovieQuizUITests2.swift
//  MovieQuizUITests2
//
//  Created by Данил Третьяченко on 26.10.2025.
//

import XCTest

final class MovieQuizUITests2: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        
        
        continueAfterFailure = false
        
    }
    
    override func tearDownWithError() throws {
        
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testExample() throws {
        
        let app = XCUIApplication()
        app.launch()
    }
    
    func testScreenCast() throws {
        
        
        app.buttons["Yes"].tap()
        app.buttons["No"].tap()
    }
    
    func testYesButton() {
        let indexLabel = app.staticTexts["Index"]
        sleep(5)
        let firstPoster = app.images["Poster"]
        
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(5)
        let secondPoster = app.images["Poster"]
        
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        let res = indexLabel.label
        XCTAssertEqual(res, "2/10")
    }
    
    func testNoButton() {
        var indexLabel = app.staticTexts["Index"]
        sleep(5)
        let firstPoster = app.images["Poster"]
        let firstPosterData  = firstPoster.screenshot().pngRepresentation
        XCTAssertEqual(indexLabel.label, "1/10")
        app.buttons["No"].tap()
        indexLabel = app.staticTexts["Index"]
        sleep(5)
        let secondPoster = app.images["Poster"]
        let secondPosterData  = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlertDialog() {
        let alertId = "GameResults"
        
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(1)
        }
        
        let alert = app.alerts[alertId]
        let alertExists = alert.waitForExistence(timeout: 5)
        
        XCTAssertTrue(alertExists, "Alert should appear after 10 questions")
        
        if alertExists {
            XCTAssertEqual(alert.label, "Этот раунд окончен!")
            XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
        }
    }
    
    func testAlertDisappear() {
        let alertId = "GameResults"
        
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(1)
        }
        
        let alert = app.alerts[alertId]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        
        alert.buttons["Сыграть ещё раз"].tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(alert.exists, "Alert should disappear after tap")
        XCTAssertEqual(indexLabel.label, "1/10")
    }
    
}
