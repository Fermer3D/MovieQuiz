import Foundation
import UIKit



final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    private var correctAnswers = 0
    
    private var currentQuestionIndex = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter = AlertPresenter()
    private lazy var statisticService: StatisticServiceProtocol = StatisticService()
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
            
            let model = AlertModel(title: "Ошибка",
                                   message: message,
                                   buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                self.questionFactory?.requestNextQuestion()
            }
            
            alertPresenter.show(in: self, model: model)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFill // устраняет белые полосы на постере
        imageView.clipsToBounds = true // устраняет белые полосы на постере
        imageView.layer.masksToBounds = true // устраняет белые полосы на постере
        imageView.layer.cornerRadius = 20
        
            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
            statisticService = StatisticService()

            showLoadingIndicator()
            questionFactory?.loadData()
        }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true 
            questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text, 
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isCorrect = currentQuestion.correctAnswer
        showAnswerResult(isCorrect: isCorrect)
        if isCorrect {
            correctAnswers += 1
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isCorrect = !currentQuestion.correctAnswer
        showAnswerResult(isCorrect: isCorrect)
        if isCorrect {
            correctAnswers += 1
        }
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self = self else { return }
                
                
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
                
            }
        )
        
        alertPresenter.show(in: self, model: alertModel)
    }
    
    private func showAnswerResult(isCorrect: Bool){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        let colorName: String
        
        if isCorrect {
            colorName = "YP Green (iOS)"
        } else {
            colorName = "YP Red (iOS)"
        }
        
        if let customColor = UIColor(named: colorName) {
            imageView.layer.borderColor = customColor.cgColor
        } else {
            
            print("Не удалось найти цвет '\(colorName)' в Assets. Используется стандартный цвет.")
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.resetImageViewBorder()
            self.showNextQuestionOrResults()
        }
    }
    
    func resetImageViewBorder() {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.borderWidth = 0.0
    }
    
    
    private func showNextQuestionOrResults() {
        resetImageViewBorder()
        if currentQuestionIndex == questionsAmount - 1 {
            
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let bestGame = statisticService.bestGame
            let accuracyString = String(format: "%.2f", statisticService.totalAccuracy)
            
            let message = """
                Ваш результат: \(correctAnswers) из \(questionsAmount)
                Всего сыграно игр: \(statisticService.gamesCount)
                Рекорд: \(bestGame.correct)/\(bestGame.total) от \(bestGame.date.dateTimeString())
                Средняя точность: \(accuracyString)%
                """
            let viewModel = AlertModel(
                title: "Этот раунд окончен!",
                message: message,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    guard let self = self else { return }
                    
                    
                    self.currentQuestionIndex = 0
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()
                }
            )
            
            
            alertPresenter.show(in: self, model: viewModel)
            
        } else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }
}
