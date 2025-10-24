//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Данил Третьяченко on 22.10.2025.
//

import Testing
import XCTest

class MovieQuizUITests: XCTestCase {
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

            
            app.buttons["Да"].tap()
            app/*@START_MENU_TOKEN@*/.staticTexts["Нет"]/*[[".buttons[\"Нет\"].staticTexts[\"Нет\"]",".staticTexts[\"Нет\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        }

        func testYesButton() {
            let indexLabel = app.staticTexts["Index"]
            sleep(15)
            let firstPoster = app.images["Poster"]
            
            let firstPosterData = firstPoster.screenshot().pngRepresentation

            app.buttons["Yes"].tap()
            sleep(15)
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
            let id = "MyAlert"
            for _ in 1...10 {
                sleep(1)
                app.buttons["Yes"].tap()
            }
            sleep(1)
            XCTAssertTrue(app.alerts[id].exists)
            let alert = app.alerts[id]
            XCTAssertEqual(alert.label, "Раунд окончен")
            XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз!")
        }

        func testAlertDisappear() {
            let id = "MyAlert"
            sleep(2)
            for _ in 1...10 {
                app.buttons["Yes"].tap()
                sleep(1)
            }
            let alert = app.alerts[id]
            alert.buttons.firstMatch.tap()
            sleep(1)
            let indexLabel = app.staticTexts["Index"]
            XCTAssertFalse(alert.exists)
            XCTAssertEqual(indexLabel.label, "1/10")
        }

    }
